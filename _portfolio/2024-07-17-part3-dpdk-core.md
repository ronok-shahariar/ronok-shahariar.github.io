---
title: "Part 3: High-Speed DPDK Core Data Plane – Kernel Bypass & Seqlocks"
collection: portfolio
type: systems
date: 2024-07-17
classes: wide
excerpt: "Core user-space ingestion engine: C, DPDK Poll Mode Drivers, HugePages memory management, POSIX shared memory, and non-blocking sequence locks."
---

<div style="margin: 15px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/Secondary-gRPC/introduction" target="_blank" rel="noopener noreferrer" class="btn btn--primary" style="padding: 10px 18px; text-decoration: none; border-radius: 6px;">
    <i class="fas fa-external-link-alt"></i> View Detailed DPDK Core & Seqlock Docs
  </a>
</div>



# Part 3: High-Speed DPDK Telemetry Data Plane

## Overview

The **DPDK Telemetry Data Plane** provides real-time visibility into a
high-performance packet-processing system without placing the monitoring workload
directly on the critical packet-processing path.

The architecture separates responsibilities between two processes:

- The **Primary DPDK Process** performs the performance-critical packet workload
  and continuously publishes telemetry information.
- The **Secondary DPDK Process** reads telemetry independently and exposes it to
  external monitoring services.

Telemetry is transferred through **POSIX shared memory**, protected using
**sequence locks (seqlocks)** to provide consistent snapshots without forcing
the primary process to wait for telemetry readers.

The resulting data is exposed locally through a lightweight
**UNIX domain socket** and then converted into structured **gRPC / Protobuf**
messages for remote monitoring, streaming, and control applications.

This creates a clean separation between the **fast packet-processing path**
and the **monitoring/control plane**.

---

## Architecture at a Glance

| Layer | Technology | Responsibility |
|---|---|---|
| Fast Path | Primary DPDK Process | High-performance packet processing and telemetry generation |
| IPC | POSIX Shared Memory | Transfers telemetry between processes |
| Synchronization | Sequence Lock | Protects readers from inconsistent snapshots |
| Telemetry Process | Secondary DPDK Process | Reads and formats telemetry without packet processing |
| Local IPC | UNIX Domain Socket | Low-overhead local telemetry transport |
| Remote API | gRPC / Protobuf | Remote polling and streaming |
| Consumers | gRPC Clients / Monitoring Systems | Visualization, diagnostics, automation and analysis |

---

# Key Engineering Functions

## Primary DPDK Process

The **Primary DPDK Process** owns the performance-critical packet-processing
workload.

Its main responsibilities include:

- Processing the high-speed networking workload
- Maintaining operational KPIs and statistics
- Updating telemetry counters and control parameters
- Publishing telemetry into a dedicated shared-memory region
- Remaining isolated from remote monitoring activity

Instead of allowing monitoring applications to directly access the packet
processing logic, the primary process writes the information required for
telemetry into shared memory.

```text
High-Speed Packet Processing
          |
          v
   Primary DPDK Process
          |
          | Update KPIs
          v
   Shared Telemetry Region
```

This keeps monitoring activity separated from the critical processing path.

---

## Secondary DPDK Telemetry Process

A lightweight **Secondary DPDK Process** runs alongside the primary process.

Unlike the primary application, the secondary process does **not perform packet
processing**.

Its role is focused entirely on telemetry.

The secondary process:

- Waits for the primary telemetry memory region to become available
- Attaches to the telemetry region
- Reads telemetry snapshots
- Validates snapshots using sequence numbers
- Prints periodic telemetry information
- Responds to local telemetry requests
- Provides data to the gRPC layer

This separation prevents remote telemetry consumers from interacting directly
with the primary packet-processing process.

---

## POSIX Shared Memory

Telemetry exchange between the primary and secondary processes is implemented
using standard **POSIX shared memory**.

The main APIs are:

```c
shm_open()
mmap()
```

The telemetry memory region is exposed as:

```text
/dpdk_kpi_shm
```

### Why POSIX Shared Memory?

- Direct memory access between local processes
- Minimal communication overhead
- No network transport required
- Fine-grained memory permissions
- Read-only access for the telemetry reader
- Simple and portable Linux/POSIX implementation

The basic architecture is:

```mermaid
flowchart LR

    PRIMARY["Primary DPDK Process"]

    SHM["POSIX Shared Memory<br/>/dpdk_kpi_shm"]

    SECONDARY["Secondary Telemetry Process"]

    PRIMARY -->|Write Telemetry| SHM

    SHM -->|Read-Only Access| SECONDARY
```

---

# Sequence Lock Synchronization

Shared memory creates a synchronization challenge.

The primary process may update telemetry at the same time that the secondary
process is reading it.

Without protection, the secondary could receive a partially updated or
**torn snapshot**.

The system solves this using a lightweight **sequence lock**.

---

## Seqlock Read Logic

The reader first checks the sequence number.

```text
Read Sequence Number
        |
        v
Is Sequence Odd?
   /          \
 Yes           No
  |             |
Writer Active   Copy Telemetry
  |             |
Retry           v
           Read Sequence Again
                  |
                  v
        Sequence Unchanged?
             /        \
           Yes         No
            |           |
       Valid Data     Retry
```

A successful telemetry read requires:

```text
seq_before == seq_after
```

and the final sequence value must be even.

---

## Seqlock Flow

```mermaid
flowchart TD

    START["Begin Telemetry Read"]

    READ1["Read update_seq → seq1"]

    ACTIVE{"seq1 is odd?"}

    COPY["Copy Telemetry Snapshot"]

    READ2["Read update_seq → seq2"]

    VALID{"seq1 == seq2<br/>and seq2 is even?"}

    SUCCESS["Return Consistent Snapshot"]

    RETRY["Retry Read"]

    START --> READ1

    READ1 --> ACTIVE

    ACTIVE -->|Yes| RETRY

    ACTIVE -->|No| COPY

    COPY --> READ2

    READ2 --> VALID

    VALID -->|Yes| SUCCESS

    VALID -->|No| RETRY

    RETRY --> READ1
```

This allows the monitoring process to obtain consistent telemetry while keeping
the synchronization mechanism lightweight.

---

# UNIX Domain Socket Interface

After obtaining a consistent telemetry snapshot, the secondary process exposes
the data through a **UNIX domain socket**.

The socket endpoint is:

```text
/tmp/dpdk_kpi.sock
```

Configuration:

| Parameter | Value |
|---|---|
| Socket Type | `AF_UNIX` |
| Transport | `SOCK_STREAM` |
| Socket Path | `/tmp/dpdk_kpi.sock` |
| Primary Command | `poll_telemetry` |
| Communication | Local request/response |

UNIX sockets are used because communication occurs between services running
on the same host.

This avoids unnecessary TCP/IP networking overhead for the local telemetry
bridge.

---

## Local Telemetry Request

The gRPC service requests the latest snapshot using:

```text
poll_telemetry
```

The local flow is:

```mermaid
flowchart LR

    GRPC["gRPC Server"]

    SOCKET["UNIX Domain Socket<br/>/tmp/dpdk_kpi.sock"]

    SECONDARY["Secondary Process"]

    SHM["POSIX Shared Memory"]

    GRPC -->|"poll_telemetry"| SOCKET

    SOCKET --> SECONDARY

    SECONDARY -->|Read Snapshot| SHM

    SHM -->|Telemetry| SECONDARY

    SECONDARY -->|Formatted Response| SOCKET

    SOCKET -->|Telemetry Response| GRPC
```

---

# gRPC Remote Telemetry Layer

The gRPC server converts the local telemetry response into structured
**Protobuf messages**.

This allows telemetry to be consumed by remote applications without exposing
the shared-memory or UNIX-socket implementation.

Two primary access patterns are supported.

### PollTelemetry

Returns the current telemetry snapshot on demand.

```text
Client
   |
   | PollTelemetry()
   v
gRPC Server
   |
   | poll_telemetry
   v
UNIX Socket
   |
   v
Secondary DPDK Process
   |
   v
Shared Memory
   |
   v
TelemetrySnapshot
   |
   v
Client
```

### StreamTelemetry

Provides continuously updated telemetry to a connected client.

```text
gRPC Client
     |
     | StreamTelemetry()
     v
gRPC Server
     |
     v
Read Latest Telemetry
     |
     v
Check Sequence Number
     |
     v
New Snapshot Available?
     |
     v
Send TelemetrySnapshot
     |
     v
Repeat
```

---

# Complete Control & Data Flow

```mermaid
flowchart LR

    subgraph FASTPATH["High-Speed DPDK Fast Path"]

        PACKETS["Network Traffic"]

        PRIMARY["Primary DPDK Process"]

    end

    subgraph IPC["Telemetry IPC"]

        SHM["POSIX Shared Memory<br/>/dpdk_kpi_shm"]

        SEQ["Sequence Lock<br/>update_seq"]

    end

    subgraph TELEMETRY["Telemetry Plane"]

        SECONDARY["Secondary DPDK Process"]

        SOCKET["UNIX Domain Socket<br/>/tmp/dpdk_kpi.sock"]

    end

    subgraph API["Remote Interface"]

        GRPC["gRPC Server"]

        CLIENT["gRPC Client"]

        MONITOR["Monitoring / Analytics"]

    end

    PACKETS --> PRIMARY

    PRIMARY -->|Update KPIs| SHM

    PRIMARY -->|Update Sequence| SEQ

    SEQ --> SHM

    SHM -->|Consistent Snapshot| SECONDARY

    SECONDARY -->|Formatted Telemetry| SOCKET

    GRPC -->|"poll_telemetry"| SOCKET

    SOCKET -->|Telemetry Data| GRPC

    GRPC -->|PollTelemetry| CLIENT

    GRPC -->|StreamTelemetry| CLIENT

    CLIENT --> MONITOR
```

---

# End-to-End Telemetry Path

The complete telemetry pipeline can be summarized as:

```text
High-Speed Network Traffic
            |
            v
    Primary DPDK Process
            |
            | KPI / Statistics Update
            v
     POSIX Shared Memory
      /dpdk_kpi_shm
            |
            | Seqlock-Protected Read
            v
   Secondary DPDK Process
            |
            | Formatted Telemetry
            v
     UNIX Domain Socket
     /tmp/dpdk_kpi.sock
            |
            | poll_telemetry
            v
        gRPC Server
            |
            | Protobuf
            v
        gRPC Client
            |
            v
 Monitoring / Analytics
```

---

# Telemetry Data

The telemetry snapshot can contain multiple RF and signal-processing metrics.

| Telemetry Field | Purpose |
|---|---|
| Peak Maximum | Maximum detected signal magnitude |
| Peak Minimum | Minimum detected magnitude |
| SFO | Sampling Frequency Offset |
| CFO | Carrier Frequency Offset |
| Timestamp | Measurement time |
| Sequence | Change / update tracking |
| Interference Active | Indicates active interference detection |
| Number of Interferers | Detected interference sources |
| Interferer Peaks | Magnitudes of detected interferers |
| Primary SNR | Signal-to-noise measurement |
| Interference Cycle Count | Detection cycle tracking |
| Total Peaks | Number of detected peaks |
| Good Frames | Successfully processed frames |
| Bad Frames | Failed or invalid frames |

The socket representation uses a lightweight key-value format such as:

```text
telemetry
peak_max=-12.45
peak_min=-45.30
sfo=0.123456
cfo=-245.67
seq=123
good_frames=98
bad_frames=2
```

The gRPC layer parses these fields and creates a structured:

```text
TelemetrySnapshot
```

Protobuf message.

---

# Performance Isolation

One of the most important design goals is preventing telemetry collection from
interfering with the primary packet-processing workload.

The architecture achieves this through:

| Technique | Benefit |
|---|---|
| Dedicated Secondary Process | Separates telemetry from packet processing |
| Read-Only Shared Memory | Prevents telemetry consumers from corrupting primary data |
| Sequence Locks | Provides consistent snapshots without conventional reader locking |
| POSIX Memory Mapping | Enables efficient local IPC |
| UNIX Domain Socket | Low-overhead local service communication |
| gRPC Boundary | Keeps remote applications away from the DPDK process |
| Sequence Tracking | Prevents unnecessary duplicate telemetry delivery |

---

# Error Handling & Reliability

The telemetry system includes several mechanisms to improve operational
reliability.

### Shared Memory

- Secondary waits until the primary creates the shared-memory region
- Retry logic handles startup-order differences
- Read-only mappings reduce accidental modifications

### Sequence Lock

- Detects concurrent writes
- Retries inconsistent reads
- Prevents torn telemetry snapshots

### UNIX Socket

- Removes stale socket files during startup
- Uses local filesystem-based socket addressing
- Supports non-blocking event handling
- Handles telemetry requests independently from packet processing

### gRPC Layer

- Socket timeout prevents indefinite blocking
- Invalid responses are handled safely
- Communication exceptions are logged
- Empty snapshots can be returned when telemetry is unavailable
- Sequence checking prevents duplicate streamed samples

---

# Remote Monitoring Architecture

```mermaid
flowchart LR

    PRIMARY["Primary DPDK"]

    SECONDARY["Secondary Telemetry"]

    GRPC["gRPC Server"]

    POLL["Polling Client"]

    STREAM["Streaming Client"]

    DASH["Monitoring System"]

    PRIMARY -->|Shared Memory| SECONDARY

    SECONDARY -->|UNIX Socket| GRPC

    GRPC -->|PollTelemetry| POLL

    GRPC -->|StreamTelemetry| STREAM

    POLL --> DASH

    STREAM --> DASH
```

This enables external monitoring applications to consume DPDK performance
information without direct access to the primary process.

---

# Process Deployment

The system consists of four logical runtime components.

```text
Terminal 1
Primary DPDK Process
        |
        v
Terminal 2
Secondary Telemetry Server
        |
        v
Terminal 3
gRPC Server
        |
        v
Terminal 4
gRPC Client / CLI
```

Typical startup order:

```bash
# Primary DPDK process
sudo build/primary -l 0-11 --socket-mem 1024,0

# Secondary telemetry process
sudo build/secondary_server --proc-type=secondary -l 0-11

# gRPC server
python run_server.py

# gRPC client
python run_client.py --cli
```

---

# Engineering Result

The completed architecture creates a **non-intrusive telemetry path** around
the high-performance DPDK packet-processing system.

It provides:

- High-performance primary DPDK processing
- Independent secondary telemetry extraction
- POSIX shared-memory IPC
- Seqlock-protected consistent snapshots
- Read-only telemetry access
- Low-overhead UNIX socket communication
- Remote gRPC polling
- Real-time gRPC streaming
- Structured Protobuf telemetry
- Error and timeout handling
- Sequence-based change detection
- Integration with external monitoring systems

The result is a modular architecture in which the **critical DPDK processing
path remains isolated**, while operational metrics remain accessible to remote
monitoring and control applications.

---

## Final Architecture Summary

```text
                    HIGH-SPEED DATA PLANE
                            |
                            v
                  +--------------------+
                  | Primary DPDK       |
                  | Packet Processing  |
                  +---------+----------+
                            |
                      Telemetry Write
                            |
                            v
                  +--------------------+
                  | POSIX Shared Memory|
                  | /dpdk_kpi_shm      |
                  +---------+----------+
                            |
                     Seqlock Read
                            |
                            v
                  +--------------------+
                  | Secondary DPDK     |
                  | Telemetry Process  |
                  +---------+----------+
                            |
                      UNIX Socket
                            |
                            v
                  +--------------------+
                  | /tmp/dpdk_kpi.sock |
                  +---------+----------+
                            |
                            v
                  +--------------------+
                  | gRPC Server        |
                  | Poll / Stream      |
                  +---------+----------+
                            |
                          Protobuf
                            |
                            v
                  +--------------------+
                  | Remote Clients /   |
                  | Monitoring Systems |
                  +--------------------+
```