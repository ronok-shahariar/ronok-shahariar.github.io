---
layout: archive
title: ""
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}


# Research & Academic Interests

- **Wireless Systems & Security:** Physical-layer security, future wireless communication systems, network performance, channel modeling, and high-speed packet processing using <a href="https://www.dpdk.org/" target="_blank" rel="noopener noreferrer">Data Plane Development Kit (DPDK)</a>.

- **Digital Systems & Computer Architecture:** <a href="https://riscv.org/" target="_blank" rel="noopener noreferrer">Reduced Instruction Set Computer Five (RISC-V)</a> processor design, digital Integrated Circuit (IC) design and verification, pipelined processor architectures, and Field-Programmable Gate Array (FPGA) prototyping.

- **Embedded & Low-Latency Systems:** Bare-metal C/C++ development, Real-Time Operating Systems (RTOS), low-level Linux systems, shared memory, CPU core isolation, and low-latency data processing.

---

# Education

### <a href="https://www.ruet.ac.bd/" target="_blank" rel="noopener noreferrer">Rajshahi University of Engineering & Technology (RUET)</a>

**Rajshahi, Bangladesh**

**Bachelor of Science in Electrical & Computer Engineering (ECE)** 
January 2018 – October 2023

- **Cumulative GPA:** 3.21 / 4.00
- **Specialization:** Dual track in Electrical & Electronic Engineering (EEE) and Computer Science & Engineering (CSE)

### Undergraduate Thesis

<a href="/publication/2023-wireless-secrecy-simo" target="_blank" rel="noopener noreferrer"><strong>Analyzing Secrecy Performance in Wireless Communication Networks with Randomly Distributed Eavesdroppers</strong></a>

**Supervisor:** Milton Kumar Kundu 
Assistant Professor, Department of ECE, RUET

The research studied the security performance of wireless communication networks in the presence of randomly located eavesdroppers. The work included secrecy outage probability, achievable secrecy rates, wireless fading models, stochastic geometry, and <a href="https://en.wikipedia.org/wiki/Poisson_point_process" target="_blank" rel="noopener noreferrer">Poisson Point Process (PPP)</a> based network modeling.

### Undergraduate Review Paper

<a href="/publication/2023-wearables-lymphedema-early-detection" target="_blank" rel="noopener noreferrer"><strong>A Review on Wearable Technologies in Early Detection of Lymphedema</strong></a>

Department of ECE, RUET

The review explored wearable and non-invasive sensing technologies that can support the early detection and continuous monitoring of lymphedema. The work covered force-sensitive sensors, wearable dielectric and strain sensors, ultrasonic sensing, and data-based methods for detecting changes over time.

---

# Standardized Tests & Language Proficiency

<div style="display:flex; flex-wrap:wrap; align-items:center; gap:8px; margin:10px 0 20px; font-size:0.88em; color:#4a4a4a;">
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">IELTS Academic: 6.5</span>
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">Listening: 6.0</span>
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">Reading: 6.0</span>
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">Writing: 6.5</span>
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">Speaking: 7.0</span>
  <span style="padding:6px 10px; background:#f5f7fa; border:1px solid #e1e5ea; border-radius:6px;">September 2026</span>
</div>


📄 <a href="https://drive.google.com/file/d/1-vCYDBBsLa9ZqDDnm2rlZHthlneazzjU/view?usp=drive_link" target="_blank" rel="noopener noreferrer"><strong>View / Download IELTS Test Report Form (TRF)</strong></a>


---

# Professional Engineering Experience

### <a href="https://siliconova.com/" target="_blank" rel="noopener noreferrer">Siliconova Ltd.</a>
**Dhaka, Bangladesh**

**Embedded Software Engineer I** 
July 2024 – July 2026

- Develop high-speed data-plane software in C using <a href="https://www.dpdk.org/" target="_blank" rel="noopener noreferrer">Data Plane Development Kit (DPDK)</a> for low-latency and high-throughput packet processing.

- Configure Linux systems using HugePages, CPU core pinning, core isolation, and Portable Operating System Interface (POSIX) shared memory to support efficient zero-copy packet-processing pipelines.

- Develop and test Verilog Register-Transfer Level (RTL) modules for Xilinx Artix-7 Field-Programmable Gate Arrays (FPGAs).

- Work on high-speed Ethernet communication between FPGA hardware and Linux host systems.

- Use AMD Xilinx Vivado for RTL simulation, synthesis, implementation, timing analysis, Xilinx Design Constraints (XDC), bitstream generation, and FPGA programming.

- Achieved sustained packet-processing throughput of up to **100 Gbps with zero packet loss** during end-to-end system validation.

- Collaborate with international engineering teams on telecom and high-speed data-processing projects, including design discussions, debugging, system validation, performance testing, and project delivery.


---

# Selected Hardware & Research Projects

## RISC-V-Based Fault-Resilient INT8 AI Accelerator

**Primary Research & VLSI Design** 
**Technologies:** Verilog, PicoRV32, Artix-7 FPGA, Vivado, Cocotb, C

- Designed a custom System-on-Chip (SoC) featuring a PicoRV32 soft-core, 32-bit MMIO bus, and a signed INT8 MAC co-processor targeting an Artix-7 FPGA (`xc7a200t-fbg484-2`).

- Embedded runtime fault resilience into the arithmetic datapath via software-controlled Single-Event Upset (SEU) injection (XOR bit-masking) and dynamic saturation clamping raising sticky error flags (`CLAMP_HIT`).

- Achieved exceptional area efficiency (<1% logic resources, 1.1% Block RAM) alongside successful physical synthesis and bitstream generation (`riscv_soc_top.bit`).

- Verified through exhaustive simulation of 65,536 signed activation-weight pairs and 7 automated regression suites.

## 3-Stage Pipelined RISC-V Core & Automated Cocotb Regression Suite

**Advanced Processor Architecture Track** 
**Technologies:** Verilog, Cocotb, Verilator, GTKWave

- Refactored a single-cycle <a href="https://github.com/YosysHQ/picorv32" target="_blank" rel="noopener noreferrer">PicoRV32</a> processor into a 3-stage pipelined architecture (IF, ID/EX, MEM/WB).

- Implemented a Hazard Detection Unit for load-use dependencies and combinational data forwarding to minimize RAW pipeline stalls.

- Developed cycle-accurate Python testbenches using <a href="https://www.cocotb.org/" target="_blank" rel="noopener noreferrer">Cocotb</a> and <a href="https://verilator.org/" target="_blank" rel="noopener noreferrer">Verilator</a> for automated regression testing.

## Digital Logic Blocks & Verification Suite

**Verification & RTL Design Track** 
**Technologies:** Verilog, Cocotb, Icarus Verilog

- Designed a configurable synchronous First-In, First-Out (FIFO) buffer with full, empty, and almost-status indicators, verified under simultaneous read/write operations.

- Designed Moore and Mealy Finite State Machine (FSM) controllers with registered outputs to reduce glitches and ensure predictable digital behavior.

---

# Academic Referees

### Milton Kumar Kundu

Assistant Professor 
Department of ECE 
Rajshahi University of Engineering & Technology (RUET)

**Email:** `milton.kundu@ece.ruet.ac.bd` 
**Relationship:** Undergraduate Thesis Supervisor

**Research Areas:** Wireless Communication, Physical-Layer Security, Wireless Network Modeling

### Fariya Tabassum

Assistant Professor 
Department of ECE 
Rajshahi University of Engineering & Technology (RUET)

**Email:** `fariya@ece.ruet.ac.bd` 
**Relationship:** Academic Instructor

**Research Areas:** Power Station, Switchgear and Protection; and Control Systems

---

# Online CV Viewer

<div style="width: 100%; height: 850px; margin: 25px 0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
 <iframe
   src="{{ base_path }}/files/CV_Md_Shahariar_Hassan_Ronok.pdf"
   width="100%"
   height="100%"
   title="Md. Shahariar Hassan Ronok Academic CV"
   style="border: none;">
   <p>
     Your browser does not support inline PDF viewing.
     <a href="{{ base_path }}/files/CV_Md_Shahariar_Hassan_Ronok.pdf"
        target="_blank"
        rel="noopener noreferrer">
       Click here to open or download the CV
     </a>.
   </p>
 </iframe>
</div>