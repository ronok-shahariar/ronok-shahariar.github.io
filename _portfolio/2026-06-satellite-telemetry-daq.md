---
title: "High-Throughput Satellite DAQ & Record/Playback Telemetry Platform"
collection: portfolio
type: systems
date: 2026-07-25
permalink: /portfolio/satellite-telemetry-daq
classes: wide
excerpt: "Scalable line-rate satellite data acquisition platform supporting MIMO and Ultra-Wideband profiles (up to 4 GHz) with DPDK zero-copy capture, primary/secondary IPC, and record-playback anomaly validation."
---

<div style="margin: 15px 0 30px 0; display: flex; flex-wrap: wrap; gap: 12px;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/intro" target="_blank" rel="noopener noreferrer" class="btn btn--primary" style="padding: 10px 18px; font-weight: 600; text-decoration: none; border-radius: 6px;">
    <i class="fas fa-external-link-alt"></i> Open Full Interactive Documentation & Code Walkthrough
  </a>
</div>

## Master System Architecture

This platform captures high-speed satellite telemetry across multiple RF profiles, records streams to non-volatile storage at line rate, and plays back data across an isolated loopback link to verify signal integrity and screen for anomalies with zero packet loss.

<div style="margin: 25px 0; text-align: center;">
  <img src="/images/systems/satellite-dpdk-telemetry-architecture.png" 
       alt="Satellite Telemetry Ingestion and Playback Master Architecture" 
       style="width: 100%; border-radius: 8px; border: 1px solid #e2e8f0; box-shadow: 0 4px 12px rgba(0,0,0,0.08);" />
  <p style="font-size: 0.85em; color: #64748b; margin-top: 8px; font-style: italic;">
    End-to-End System Topology: Satellite Flex Compute SDRs → Ingestion & Playback Server → Primary DPDK Fast Path → Telemetry Pipeline → Remote Instrumentation.
  </p>
</div>

---

## Part 1: RF Signal Capture & Ingress (Flex Compute FPGA)

The front-end acquisition layer digitizes wideband satellite RF downlinks and encapsulates raw I/Q samples into high-speed Ethernet streams.

<div style="margin: 20px 0; text-align: center;">
  <!-- Replace with your Part 1 FPGA / SDR diagram or screenshot -->
  <img src="/images/systems/part1_flex_compute_fpga.png" 
       alt="Flex Compute FPGA Architecture" 
       style="width: 100%; max-width: 850px; border-radius: 6px; border: 1px solid #e2e8f0;" />
</div>

* **Hardware Layer:** Multiple Software-Defined Radio (SDR) units stream packets across high-speed optical links (up to 25 Gbps per channel) into the capture server NICs .
* **Packet Framing & Header Metadata:** The FPGA channelizer injects nanosecond-resolution hardware timestamps and monotonically increasing sequence counters into packet headers to enable packet-drop auditing and inter-channel time alignment .
* **Supported RF Topologies:**
  * **4T4R MIMO:** 4 channels / packet @ 491.52 MHz per channel (**1.966 GHz** aggregate).
  * **3T3R MIMO:** 3 channels / packet @ 491.52 MHz per channel (**1.476 GHz** aggregate).
  * **Wideband (1-CH):** 1 channel @ **1.4756 GHz**.
  * **Wideband (2-CH):** 2 channels @ 1.4756 GHz (**2.951 GHz** aggregate).
  * **Wideband (4-CH):** 4 channels @ 1.4756 GHz (**5.902 GHz** aggregate).

<div style="margin: 10px 0 25px 0;">
  <a href="https://YOUR_EXTERNAL_DOCS_URL_HERE/part1-fpga" target="_blank" rel="noopener noreferrer" style="font-weight: 600; font-size: 0.9em; text-decoration: none;">
    → Read Part 1 Detailed Technical Notes: Flex Compute Framing & Channel Specs
  </a>
</div>

---

## Part 2: Dual Triggering Subsystem & Test Automation (LabVIEW & Python)

Capture routines can be initiated synchronously via physical line transitions or remotely via software test benches.

<div style="margin: 20px 0; text-align: center;">
  <!-- Replace with your Part 2 LabVIEW front panel / VISA bridge diagram -->
  <img src="/images/systems/part2_trigger_labview_visa.png" 
       alt="LabVIEW and VISA SCPI Automation Bridge" 
       style="width: 100%; max-width: 850px; border-radius: 6px; border: 1px solid #e2e8f0;" />
</div>

* **Hardware Triggering:** Synchronized trigger pulses from the FPGA front-end or external lab generators drive deterministic, low-latency burst captures.
* **Software Triggering:** Remote operators issue trigger requests using Python scripts or National Instruments (NI) LabVIEW Virtual Instruments (VIs).
* **VISA / SCPI Protocol Bridge:** Translates incoming client Remote Procedure Calls into standard SCPI instructions over TCP/IP sockets to automate RF center frequencies, receiver gains, and recording schedules.
* **Connection Resiliency:** Implemented state-machine reconnection handling, socket write locks to resolve thread contention, and strict CRLF delimiter parsing for message transport.

<div style="margin: 10px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/LabVIEW-gRPC-VISA/introduction" target="_blank" rel="noopener noreferrer" style="font-weight: 600; font-size: 0.9em; text-decoration: none;">
    → Read Part 2 Detailed Technical Notes: LabVIEW VIs, SCPI Commands & Socket Traces
  </a>
</div>

---

## Part 3: High-Speed Core Data Plane (Primary & Secondary DPDK)

The server software runs a decoupled primary/secondary process model in C to process line-rate traffic while ensuring non-blocking telemetry access.

<div style="margin: 20px 0; text-align: center;">
  <!-- Replace with your Part 3 DPDK Shared Memory & Seqlock diagram -->
  <img src="/images/systems/part3_dpdk_data_plane.jpg" 
       alt="DPDK Primary Secondary Architecture" 
       style="width: 100%; max-width: 850px; border-radius: 6px; border: 1px solid #e2e8f0;" />
</div>

* **Primary DPDK Process (DSP & Ingestion):**
  * Direct user-space polling using Poll Mode Drivers (PMD) running over pre-allocated HugePage ring buffers (`rte_mempool`).
  * Bypasses the Linux kernel network stack and hardware interrupts to capture packets at wire speed with zero memory copies.
* **Secondary DPDK Process & IPC:**
  * Maps into POSIX shared memory segments (`shm_open`, `mmap`) managed by sequence locks (`seqlocks`).
  * Reads runtime performance counters without locking or degrading fast-path packet throughput.
* **Hardware-Level Node Licensing:**
  * Validates hardware cryptographic signatures (NIC MAC address and platform hardware IDs) before binding the DPDK Environment Abstraction Layer (EAL).

<div style="margin: 10px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/Secondary-gRPC/introduction" target="_blank" rel="noopener noreferrer" style="font-weight: 600; font-size: 0.9em; text-decoration: none;">
    → Read Part 3 Detailed Technical Notes: DPDK EAL Initialization, Seqlocks & Buffer Pools
  </a>
</div>

---

## Part 4: Observability & Cloud-Native Metrics Pipeline (gRPC, Prometheus, Grafana)

Raw hardware counters are converted into a cloud-native monitoring stream without taxing the fast-path packet engine.

<div style="margin: 20px 0; text-align: center;">
  <!-- Replace with your Part 4 Prometheus/Grafana architecture or dashboard screenshot -->
  <img src="/images/systems/part4_prometheus_grafana_dashboard.jpg" 
       alt="Prometheus and Grafana Telemetry Dashboard" 
       style="width: 100%; max-width: 850px; border-radius: 6px; border: 1px solid #e2e8f0;" />
</div>

* **Local UNIX Socket:** `/tmp/dpdk_kpi.sock` serves non-blocking query responses for local terminal telemetry scripts.
* **gRPC Telemetry Daemon:** Exposes streaming RPC endpoints to distribute ingress metrics to external microservices.
* **Custom Prometheus Exporter:** Regularly scrapes the UNIX domain socket and converts raw metrics into standard Prometheus exposition format over HTTP.
* **Grafana Visualization:** Live dashboards plot packet arrival rates, buffer pool fill percentages, queue backpressures, and thread latency profiles.

<div style="margin: 10px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/Grafana-Prometheus/Introduction" target="_blank" rel="noopener noreferrer" style="font-weight: 600; font-size: 0.9em; text-decoration: none;">
    → Read Part 4 Detailed Technical Notes: Exporter Setup & Grafana Dashboard Panels
  </a>
</div>

---

## Part 5: Operator Interfaces, Intel VTune Profiling & Line-Rate Verification Benchmarks

Operators configure and monitor captures through interactive user interfaces, validate runtime performance using Intel VTune, and perform offline replay to screen for RF distortions, sequence discontinuities, and transmission errors.

<div style="margin: 20px 0; text-align: center;">
  <!-- Replace with your Part 5 Operator UI, Intel VTune, or packet test screenshot -->
  <img src="/images/systems/part5_operator_ui_benchmarks.png" 
       alt="Operator UI, Intel VTune Profiling and Line-Rate Verification Benchmarks" 
       style="width: 100%; max-width: 850px; border-radius: 6px; border: 1px solid #e2e8f0;" />
</div>

* **Operator Interfaces:** Both a terminal-based CLI and a graphical application interface provide operator control for starting, stopping, configuring, and monitoring acquisition and playback workflows.

* **Intel VTune Performance Profiling:** Intel VTune is used to profile CPU utilization, processing hotspots, thread/core behavior, and runtime execution characteristics during sustained high-throughput workloads, helping identify performance bottlenecks beyond packet-level validation.

* **Record & Playback Verification:** Recorded telemetry files are re-injected over an isolated loopback link to a secondary verification server to audit sequence continuity, packet integrity, and replay consistency.

* **Zero-Drop Line-Rate Benchmarks:** Rigorous multi-profile stress runs demonstrated **0 packet drops** across the reported validation workloads:

| Test Benchmark Profile | Max Trigger Length | Processed Packets | Ingestion Time | Packet Loss | Verification Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Burst Ingress Run** | 262,144 | 98,304 | 0.012 sec | **0** | Verified Line Rate |
| **Sustained Stream** | 320,000,000 | 120,000,000 | 14.4 sec | **0** | Verified Line Rate |
| **Stress Run 1** | Unlimited | 145,709,343 | 17.5 sec | **0** | Verified Line Rate |
| **Stress Run 2** | Unlimited | 788,060,948 | 1.60 min | **0** | Verified Line Rate |
| **Peak Endurance Run** | Unlimited | **859,314,436** | 1.72 min | **0** | Verified Line Rate |

<div style="margin: 10px 0 25px 0;">
  <a href="https://ronok-6-g-research-portfolio.vercel.app/docs/Grafana-Prometheus/Introduction"
     target="_blank"
     rel="noopener noreferrer"
     style="font-weight: 600; font-size: 0.9em; text-decoration: none;">
    → Read Part 5 Detailed Technical Notes: Intel VTune Profiling, Terminal Logs & Verification Evidence
  </a>
</div>

---

## Technical Stack & Competencies
`C` `DPDK (PMD)` `Linux Kernel Bypass` `HugePages` `Zero-Copy Shm` `Seqlocks` `gRPC` `Prometheus & Grafana` `LabVIEW / SCPI` `FPGA SDR`