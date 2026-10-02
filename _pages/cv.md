---
layout: archive
title: "Curriculum Vitae"
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

<div style="margin-bottom: 25px;">
  <a href="{{ base_path }}/files/CV_Md_Shahariar_Hassan_Ronok.pdf" class="btn btn--primary" target="_blank" style="padding: 10px 18px; font-weight: 600; text-decoration: none; border-radius: 6px;">
    <i class="fas fa-file-pdf"></i> Download Full Academic CV (PDF)
  </a>
</div>

## Research & Academic Interests

* **Wireless Systems & Security:** Physical layer security, 6G wireless transport infrastructure, high-throughput packet processing (DPDK), and channel modeling.
* **Digital Systems & Microarchitecture:** RISC-V microarchitecture, digital IC design & verification, FPGA hardware prototyping (Xilinx Artix-7), and pipelined datapaths.
* **Embedded Systems & Low Latency:** Bare-metal C/C++ firmware, real-time operating systems (RTOS), and Linux kernel bypass (HugePages, core pinning).

---

## Education

**Rajshahi University of Engineering & Technology (RUET) — Rajshahi, Bangladesh**  
*Bachelor of Science in Electrical & Computer Engineering (ECE)* | Jan 2018 – Oct 2023  
* **Cumulative GPA:** 3.21 / 4.00 | Dual Track Specialization in Electrical & Electronic Engineering (EEE) and Computer Science & Engineering (CSE)
* **Undergraduate Thesis:** "Analyzing Secrecy Performance in Wireless Communication Networks with Randomly Distributed Eavesdroppers"  
  Supervisor: Milton Kumar Kundu, Assistant Professor, Dept. of ECE, RUET. Evaluated secrecy outage probability and achievable secrecy rates under spatial Poisson point distributions using stochastic geometry and wireless fading channel models.
* **Undergraduate Review Paper:** "A Review on Wearable Technologies in Early Detection of Lymphedema"  
  Dept. of ECE, RUET. Surveyed non-invasive wearable biosensing architectures (force-sensitive resistor cuffs, epidermal dielectric/strain LC patches, and ultrasonic transducers) for continuous monitoring, and evaluated growth models and change-point algorithms for early detection.
* **Core Coursework:** VLSI Design, Computer Architecture, Digital Logic Design, Microprocessors & Microcontrollers, Embedded Systems Design, Analog Electronics.

---

## Standardized Tests & Language Proficiency

* **IELTS Academic:** Overall Band 6.5 (Listening: 6.0, Reading: 6.0, Writing: 6.5, Speaking: 7.0) — *September 2026*

---

## Technical Skillset

* **High-Speed Networking & Systems:** DPDK, Kernel Bypass, HugePages Allocation, CPU Pinning, Core Isolation, POSIX Shared Memory (SHM), TAP Interfaces, `dpdk-testpmd`.
* **Digital Design & Architectures:** Verilog, SystemVerilog fundamentals, 3-Stage RISC-V Microarchitecture, Hazard Detection & Forwarding Logic, Synchronous FIFOs, Moore & Mealy FSM Controllers, ALU Design.
* **Verification & Automation:** Cocotb (Python Testbenches), Verilator, Icarus Verilog, GTKWave, GDBWave, Microarchitectural Assertions, Makefile Test Automation, GitHub Actions, GitLab CI, Docker.
* **EDA & FPGA Prototyping:** Xilinx Vivado (Simulation, Synthesis, Implementation, Timing Constraints/XDC, Hardware Manager), Artix-7 FPGA Implementation.
* **Embedded & Firmware:** Bare-Metal C, STM32 (ARM Cortex-M), AVR/Arduino, ESP32, UART, SPI, I2C, gRPC (Python/C).
* **PCB & Lab Equipment:** KiCAD, Multisim, Proteus, Digital Storage Oscilloscopes (DSO), Logic Analyzers.

---

## Professional Engineering Experience

**[Siliconova.Ltd](https://siliconova.com/) — Dhaka, Bangladesh**  
*Embedded Software Engineer I* | July 2024 – Present  
* Develop high-throughput data plane software in C using DPDK to process network packets at line rate with low latency.
* Configure Linux servers using HugePages, CPU core pinning, and POSIX shared memory to enable zero-copy packet processing pipelines.
* Write and test Verilog RTL modules on Xilinx Artix-7 FPGAs to stream packetized data over Ethernet to host servers.
* Work with FPGA implementation flows in Vivado, covering RTL simulation, timing closure using XDC constraints, and programming bitstreams onto physical boards.
* Build gRPC services in Python and C to manage hardware registers, update link settings, and monitor system telemetry.
* Containerize test environments using Docker and automate network testing with TAP interfaces and `dpdk-testpmd` inside CI/CD pipelines.

---

## Selected Hardware & Research Projects

**3-Stage Pipelined RISC-V Core & Automated Cocotb Regression Suite**  
*Siliconova VLSI Track* | *Verilog, Cocotb, Verilator, GTKWave*  
* Converted a single-cycle PicoRV32 processor into a 3-stage pipelined core (IF, ID/EX, MEM/WB) using Verilog.
* Implemented a Hazard Detection Unit to handle 1-cycle load-use dependencies along with combinational data forwarding logic.
* Integrated branch-flushing logic within the decode stage to clear speculatively fetched instructions on branch mispredictions.
* Wrote cycle-accurate Python testbenches in Cocotb for directed instruction tests and set up automated regression runs using Makefiles.

**Digital Logic Blocks & Verification Suite**  
*Academic & Open-Source Track* | *Verilog, Cocotb, Icarus Verilog*  
* Designed a configurable synchronous FIFO in Verilog with full, empty, almost-full, and almost-empty flag indicators.
* Tested simultaneous read/write operations using Cocotb to verify pointer synchronization, overflow/underflow logic, and data accuracy.
* Designed Moore and Mealy FSM controllers with glitch-free registered outputs for serial bus communication protocols.

**Microcontroller System Board & Multi-Sensor Interface**  
*RUET Academic Capstone* | *KiCAD, Multisim, Bare-Metal C*  
* Designed schematics and a 2-layer PCB layout in KiCAD with split ground planes for low-noise sensor performance.
* Verified power decoupling, clock integrity, and signal noise levels using digital oscilloscopes in the lab.
* Wrote non-blocking, interrupt-driven bare-metal C drivers for UART and SPI to stream multi-sensor data.

---

## Academic Referees

* **Milton Kumar Kundu**  
  Assistant Professor, Department of ECE, RUET  
  Email: `milton.kundu@ece.ruet.ac.bd` | *Undergraduate Thesis Supervisor*  
  *Research Focus:* Wireless Communications, Physical Layer Security & Network Modeling

* **Md. Robiul Islam**  
  Assistant Professor, Department of ECE, RUET  
  Email: `robiul@ece.ruet.ac.bd` | *Academic Instructor / Department Referee*  
  *Research Focus:* Embedded Systems, Digital Systems & Signal Processing

---

## Online CV Viewer

<div style="width: 100%; height: 850px; margin: 25px 0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
  <iframe 
    src="{{ base_path }}/files/CV_Md_Shahariar_Hassan_Ronok.pdf" 
    width="100%" 
    height="100%" 
    style="border: none;">
    <p>Your browser does not support inline PDF viewing. <a href="{{ base_path }}/files/CV_Md_Shahariar_Hassan_Ronok.pdf">Click here to download the CV</a> instead.</p>
  </iframe>
</div>