---
title: "Part 4: Telemetry Pipeline & Cloud Observability (gRPC, Prometheus, Grafana)"
collection: portfolio
type: systems
date: 2024-07-16
classes: wide
excerpt: "Real-time network and system health metrics: gRPC-based telemetry daemon, custom Prometheus exporter, and interactive Grafana dashboards."
---

<div style="margin: 15px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/Grafana-Prometheus/Introductions" target="_blank" rel="noopener noreferrer" class="btn btn--primary" style="padding: 10px 18px; text-decoration: none; border-radius: 6px;">
    <i class="fas fa-external-link-alt"></i> View Detailed Telemetry Pipeline & Grafana Docs
  </a>
</div>


# Part 4: Real-Time Telemetry & Observability

## Overview

The **Telemetry & Observability Pipeline** provides real-time visibility into
a high-throughput satellite signal-processing architecture without placing
monitoring workloads directly on the performance-critical DPDK data path.

The complete platform processes satellite data through multiple stages:

- **4× Flex Compute SDRs**
- **100 Gbps DPDK ingress on Server 1**
- Intelligent reduction to approximately **10 Gbps**
- Advanced **DSP and anomaly detection on Server 2**
- POSIX shared-memory telemetry handoff
- Secondary telemetry processing
- gRPC-based remote access
- Custom Prometheus metric collection
- Interactive Grafana dashboards

The observability system transforms low-level DPDK counters, DSP measurements,
and anomaly information into structured metrics that operators can inspect
in real time.

---

## Architecture at a Glance

| Layer | Technology | Responsibility |
|---|---|---|
| RF Acquisition | Flex Compute SDR + FPGA | Satellite signal acquisition and preprocessing |
| High-Speed Ingress | DPDK / Server 1 | 100 Gbps packet reception and initial processing |
| Data Reduction | Server 1 DSP | Reduces high-rate input before deeper processing |
| DSP Engine | DPDK / Server 2 | Advanced DSP, parameter extraction and anomaly detection |
| Local IPC | POSIX Shared Memory | Transfers processed telemetry between local processes |
| Telemetry Process | Secondary DPDK Process | Prepares telemetry for external access |
| Service Layer | gRPC / Protobuf | Remote telemetry polling and streaming |
| Metrics Layer | Custom Prometheus Exporter | Converts runtime data into monitorable metrics |
| Time-Series Monitoring | Prometheus | Stores and queries telemetry metrics |
| Visualization | Grafana | Real-time dashboards, trends and operational visibility |

---

# End-to-End System Architecture

```mermaid
flowchart TD

    subgraph EDGE["RF / Edge Ingress"]
        direction TB
        SAT["Satellite Data"]
        SDR["4× Flex Compute SDRs<br/>FPGA Preprocessing"]
        SAT --> SDR
    end

    subgraph SERVER1["Server 1 Processing"]
        direction TB
        S1["Server 1<br/>100 Gbps DPDK Ingress"]
        REDUCE["Filtering / DSP<br/>Data Reduction"]
        S1 --> REDUCE
    end

    subgraph SERVER2["Server 2 Processing"]
        direction TB
        S2["Server 2<br/>DPDK + Advanced DSP<br/>Anomaly Detection"]
        SHM["POSIX Shared Memory"]
        SECONDARY["Secondary DPDK<br/>Telemetry Process"]
        S2 -->|"DSP Results / KPIs"| SHM
        SHM --> SECONDARY
    end

    subgraph MONITORING["Telemetry & Monitoring"]
        direction TB
        GRPC["gRPC Service"]
        EXPORTER["Custom Prometheus<br/>Exporter"]
        PROM["Prometheus"]
        GRAFANA["Grafana Dashboards"]
        GRPC --> EXPORTER
        EXPORTER --> PROM
        PROM --> GRAFANA
    end

    SDR -->|"High-Speed RF Data"| S1
    REDUCE -->|"Refined ~10 Gbps Stream"| S2
    SECONDARY --> GRPC
```

---

# Data Journey: Satellite to Dashboard

```mermaid
flowchart TD

    subgraph EDGE["RF Signal Acquisition"]
        direction TB
        A["Satellite Signal"]
        B["4× Flex Compute SDRs<br/>FPGA Processing"]
        A --> B
    end

    subgraph SERVER1["Server 1 — High-Speed Ingress"]
        direction TB
        C["Server 1<br/>100 Gbps DPDK Ingress"]
        D["Filtering / Initial DSP"]
        E["Data Reduction<br/>100 Gbps → ~10 Gbps"]
        C --> D
        D --> E
    end

    subgraph SERVER2["Server 2 — Advanced Processing"]
        direction TB
        F["Server 2<br/>Advanced DPDK + DSP"]
        G["Anomaly Detection<br/>Parameter Extraction"]
        H["POSIX Shared Memory"]
        I["Secondary DPDK Process"]
        F --> G
        G --> H
        H --> I
    end

    subgraph TELEMETRY["Telemetry & Monitoring"]
        direction TB
        J["gRPC Telemetry Service"]
        K["Prometheus Exporter"]
        L["Prometheus"]
        M["Grafana"]
        N["Real-Time Operational Visibility"]
        J --> K
        K --> L
        L --> M
        M --> N
    end

    B --> C
    E --> F
    I --> J
```

---

# Key Engineering Functions

## gRPC Telemetry Service

The **gRPC service layer** exposes processed telemetry and DSP information to
remote consumers.

Instead of allowing monitoring systems to directly access the DPDK processes,
the gRPC layer provides a clean service boundary.

The service can expose operations such as:

```protobuf
service DataService {
    rpc StreamAnomalies(SubscriptionRequest)
        returns (stream AnomalyResponse);

    rpc GetMetrics(Empty)
        returns (MetricsResponse);
}
```

This provides two complementary access patterns:

- **Streaming** for continuously changing anomaly information
- **On-demand queries** for current system and processing metrics

---

## gRPC Telemetry Flow

```mermaid
flowchart LR

    DSP["DSP / Anomaly Engine"]

    SHM["POSIX Shared Memory"]

    SECONDARY["Secondary Process"]

    GRPC["gRPC Server"]

    STREAM["StreamAnomalies"]

    METRICS["GetMetrics"]

    CLIENT["Remote Consumer"]

    DSP -->|Write Results| SHM

    SHM --> SECONDARY

    SECONDARY --> GRPC

    GRPC --> STREAM

    GRPC --> METRICS

    STREAM --> CLIENT

    METRICS --> CLIENT
```

The API layer isolates external applications from internal shared-memory and
DPDK implementation details.

---

# Custom Prometheus Exporter

A custom **Prometheus exporter** bridges high-performance system telemetry into
the monitoring stack.

The exporter collects metrics from two important sources:

1. **Application / DSP telemetry through gRPC**
2. **Low-level DPDK runtime statistics through the DPDK telemetry interface**

This creates a unified observability layer that can combine signal-processing
information with system-level network statistics.

---

## Exporter Architecture

```mermaid
flowchart TD

    subgraph APP["Application Telemetry"]

        DSP["DSP / Anomaly Results"]

        GRPC["gRPC API"]

        DSP --> GRPC

    end

    subgraph DPDK["DPDK Runtime"]

        TELEMETRY["DPDK Telemetry Socket"]

        NIC["NIC / Port Statistics"]

        RATE["Packet & Data Rates"]

        PORT["Port Configuration"]

        NIC --> TELEMETRY

        RATE --> TELEMETRY

        PORT --> TELEMETRY

    end

    GRPC --> EXPORTER["Custom Prometheus Exporter"]

    TELEMETRY --> EXPORTER

    EXPORTER --> PROM["Prometheus"]

    PROM --> GRAFANA["Grafana"]
```

---

# DPDK Telemetry Integration

DPDK provides a runtime telemetry interface that can be inspected independently
from the main application.

The monitoring workflow uses this telemetry interface to retrieve useful
runtime information such as:

- NIC statistics
- Packet rates
- Primary-process data rate
- Port information
- Port configuration
- Runtime DPDK statistics

This allows network-level performance information to be monitored alongside
DSP and anomaly metrics.

---

## Dual Telemetry Sources

```mermaid
flowchart TD

    DSP["DSP / Anomaly<br/>Processing"]
    EXPORTER["Prometheus<br/>Exporter"]
    DPDK["DPDK Runtime<br/>NIC / Packet / Port<br/>Statistics"]

    DSP -->|"gRPC API"| EXPORTER
    DPDK -->|"DPDK Telemetry"| EXPORTER
```

This gives operators visibility into both:

**What the signal-processing pipeline is detecting**

and

**How the underlying packet-processing infrastructure is behaving.**

---

# Prometheus Metrics Pipeline

The custom exporter periodically obtains the latest telemetry and makes it
available to the Prometheus monitoring layer.

```mermaid
flowchart LR

    GRPC["gRPC Metrics"]

    DPDK["DPDK Runtime Metrics"]

    EXPORT["Custom Exporter"]

    PROM["Prometheus"]

    QUERY["PromQL Queries"]

    GRAFANA["Grafana"]

    GRPC --> EXPORT

    DPDK --> EXPORT

    EXPORT --> PROM

    PROM --> QUERY

    QUERY --> GRAFANA
```

Prometheus provides the time-series layer required to analyze how system
behavior changes over time.

---

# Metrics Categories

The observability stack combines metrics from different parts of the system.

| Category | Example Information |
|---|---|
| Network | NIC statistics |
| Traffic | Packet rates |
| DPDK | Primary-process data rate |
| Ports | Port configuration and runtime state |
| DSP | Signal-processing parameters |
| Frequency Analysis | SFO / CFO and related measurements |
| Signal Quality | Peak levels and signal characteristics |
| Interference | Detected interferers and anomaly state |
| Frames | Good / bad processing statistics |
| Anomaly Detection | Detected signal abnormalities |
| Performance | Throughput and processing behavior |
| System Health | Overall pipeline operating state |

---

# Grafana Visualization

Grafana acts as the final operator-facing layer of the telemetry architecture.

Prometheus is configured as the data source, allowing dashboards to visualize
live and historical behavior.

Typical dashboard views can include:

- Network throughput
- Packet-rate trends
- DPDK runtime statistics
- DSP parameters
- Anomaly detection status
- Signal characteristics
- Interference trends
- Frame statistics
- Processing latency
- General system health

---

## Visualization Pipeline

```mermaid
flowchart TD

    A["Raw DPDK Counters"]
    B["DSP / Anomaly Metrics"]
    C["Custom Exporter"]
    D["Prometheus<br/>Time-Series Metrics"]
    E["PromQL Queries"]
    F["Grafana Panels"]
    G["Current System State"]
    H["Historical Trends"]
    I["Operator Insight"]

    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    F --> H
    G --> I
    H --> I
```

---

# Grafana Dashboard Architecture

```mermaid
flowchart TD

    PROM["Prometheus Data Source"]

    DASH["Grafana Dashboard"]

    THROUGHPUT["Throughput"]

    PACKETS["Packet Rates"]

    DSP["DSP Parameters"]

    ANOMALY["Anomaly Detection"]

    SIGNAL["Signal Metrics"]

    HEALTH["System Health"]

    PROM --> DASH

    DASH --> THROUGHPUT

    DASH --> PACKETS

    DASH --> DSP

    DASH --> ANOMALY

    DASH --> SIGNAL

    DASH --> HEALTH
```

The dashboard turns low-level numerical telemetry into immediate operational
visibility.

---

# Real-Time Anomaly Monitoring

Anomaly detection is performed in the Server 2 DSP processing stage.

The observability pipeline allows these results to move from the processing
engine to remote visualization.

```mermaid
flowchart TD

    subgraph PROCESSING["Signal Processing"]
        direction LR
        INPUT["Reduced Satellite Data"]
        DSP["Advanced DSP"]
        DETECT["Anomaly Detection"]

        INPUT --> DSP
        DSP --> DETECT
    end

    subgraph TELEMETRY["Telemetry Interface"]
        direction LR
        SHM["Shared Memory"]
        GRPC["gRPC"]

        SHM --> GRPC
    end

    subgraph MONITORING["Monitoring Pipeline"]
        direction LR
        EXPORT["Exporter"]
        PROM["Prometheus"]
        DASH["Grafana"]

        EXPORT --> PROM
        PROM --> DASH
    end

    DETECT --> SHM
    GRPC --> EXPORT
```

This creates a direct operational path from **signal intelligence** to
**human-readable visualization**.

---

# Performance Isolation

Monitoring a high-speed packet-processing system presents an important
engineering challenge:

> Observability must not become part of the performance bottleneck.

The design addresses this by separating monitoring from the primary data path.

| Component | Role |
|---|---|
| Primary DPDK | Performance-critical packet processing |
| Shared Memory | Efficient telemetry handoff |
| Secondary Process | Extracts telemetry independently |
| gRPC Service | Provides controlled remote access |
| Exporter | Converts data into monitoring metrics |
| Prometheus | Handles time-series monitoring workload |
| Grafana | Performs visualization independently of packet processing |

The primary data-processing workload therefore does not need to directly serve
dashboard or monitoring requests.

---

# Background Telemetry Services

The telemetry infrastructure is designed to run alongside the main processing
pipeline.

```mermaid
flowchart TD

    subgraph FOREGROUND["Foreground Processing"]
        direction TB
        A["Satellite Data"]
        B["DPDK + DSP"]
        C["Anomaly Detection"]

        A --> B
        B --> C
    end

    subgraph OBSERVABILITY["Background Observability"]
        direction TB
        D["Secondary Process"]
        E["gRPC Server"]
        F["Prometheus Exporter"]
        G["Prometheus"]
        H["Grafana"]

        D --> E
        E --> F
        F --> G
        G --> H
    end
```

This clean separation makes the architecture easier to operate and debug.

---

# Monitoring Workflow

The complete monitoring workflow is:

### Step 1 — Acquire Satellite Data

Flex Compute SDR units acquire or replay high-speed satellite data.

### Step 2 — Receive Data on Server 1

DPDK receives the aggregated high-rate traffic and performs initial processing.

### Step 3 — Reduce the Data

Server 1 filters and reduces the data before forwarding the refined stream to
Server 2.

### Step 4 — Perform Advanced DSP

Server 2 performs deeper DSP analysis, parameter extraction, and anomaly
detection.

### Step 5 — Publish Telemetry

Processed results are transferred through shared memory to the secondary
telemetry process.

### Step 6 — Expose gRPC APIs

The telemetry service makes current DSP and anomaly information available
through gRPC.

### Step 7 — Collect Prometheus Metrics

The custom exporter obtains application metrics and low-level DPDK telemetry.

### Step 8 — Store and Query Metrics

Prometheus maintains the time-series monitoring data.

### Step 9 — Visualize in Grafana

Grafana presents live dashboards and operational trends.

---

# Operational Verification

Each part of the monitoring chain can be tested independently.

```mermaid
flowchart TD

    A["DPDK / DSP"]
    B["Shared Memory"]
    C["Secondary Process"]
    D["gRPC"]
    E["Prometheus Exporter"]
    F["Prometheus"]
    G["Grafana"]
    H["Complete Observability Pipeline"]

    A -->|"Verify processed results"| B
    B -->|"Verify secondary access"| C
    C -->|"Verify telemetry output"| D
    D -->|"Test API calls"| E
    E -->|"Verify exported metrics"| F
    F -->|"Query stored metrics"| G
    G -->|"Validate dashboards"| H
```

This staged architecture makes troubleshooting significantly easier because
problems can be isolated to a specific layer.

---

# High-Level Production Architecture

```mermaid
flowchart TB

    subgraph ACQ["RF Acquisition"]

        SAT["Satellite"]

        SDR["4× Flex Compute SDRs"]

    end

    subgraph SERVER1["Server 1 – High-Speed Ingress"]

        RX["100 Gbps DPDK"]

        PREFILTER["Filtering / Initial DSP"]

        REDUCE["Data Reduction"]

    end

    subgraph SERVER2["Server 2 – Signal Intelligence"]

        CORE["DPDK Processing"]

        DSP["Advanced DSP"]

        ANOM["Anomaly Detection"]

    end

    subgraph IPC["Telemetry Handoff"]

        SHM["POSIX Shared Memory"]

        SEC["Secondary Process"]

    end

    subgraph OBS["Observability"]

        GRPC["gRPC Service"]

        EXP["Prometheus Exporter"]

        PROM["Prometheus"]

        GRAFANA["Grafana"]

    end

    SAT --> SDR

    SDR --> RX

    RX --> PREFILTER

    PREFILTER --> REDUCE

    REDUCE -->|~10 Gbps| CORE

    CORE --> DSP

    DSP --> ANOM

    ANOM --> SHM

    SHM --> SEC

    SEC --> GRPC

    GRPC --> EXP

    EXP --> PROM

    PROM --> GRAFANA
```

---

# Engineering Result

The completed telemetry architecture creates a dedicated **observability plane**
around the high-performance satellite processing pipeline.

It provides:

- Real-time visibility into DPDK processing
- Remote gRPC telemetry access
- DSP and anomaly information
- Low-level DPDK runtime metrics
- Custom Prometheus metric collection
- Time-series monitoring
- Interactive Grafana dashboards
- Live performance analysis
- Historical trend visualization
- Network and signal-processing insight
- Separation between monitoring and critical packet processing
- Layer-by-layer diagnostics

The result is a monitoring architecture in which the high-speed processing
pipeline remains focused on data acquisition and DSP while telemetry is
independently collected, transformed, stored, and visualized.

---

# Final Observability Pipeline

```mermaid
flowchart TD

    A["SATELLITE DATA"]
    B["4× Flex Compute SDRs<br/>FPGA Preprocessing"]
    C["Server 1<br/>100 Gbps DPDK Ingress"]
    D["Data Reduction<br/>~10 Gbps Output"]
    E["Server 2<br/>Advanced DSP + Anomaly Detection"]
    F["POSIX Shared Memory"]
    G["Secondary DPDK Process"]
    H["gRPC Telemetry Service"]
    I["Prometheus Exporter"]
    J["Prometheus<br/>Time-Series Monitoring"]
    K["Grafana<br/>Dashboards & Analysis"]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J
    J --> K
```

---

## From High-Speed Packets to Operational Insight

**100 Gbps DPDK processing → DSP intelligence → telemetry extraction → gRPC APIs → Prometheus metrics → Grafana visualization**

The observability layer transforms a complex high-performance signal-processing
system into an architecture that can be monitored, analyzed, and debugged in
real time.