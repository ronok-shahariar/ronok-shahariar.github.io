---
title: "3-Stage Pipelined RISC-V Core & Automated Cocotb Regression Suite"
collection: portfolio
type: vlsi
date: 2025-09-15
excerpt: "Design and verification of a 3-stage pipelined RISC-V processor featuring hazard detection, data forwarding, branch flushing, and automated Cocotb regression testing."
---

## Overview

This project focuses on the design and verification of a **3-stage pipelined RISC-V processor core** by transforming a baseline single-cycle PicoRV32-compatible architecture into a higher-throughput pipeline design.

The processor datapath is divided into three execution stages:

- Instruction Fetch (IF)
- Instruction Decode / Execute (ID/EX)
- Memory Access / Writeback (MEM/WB)

The redesign improves instruction throughput while maintaining correct execution through dedicated hazard management, forwarding logic, and branch recovery mechanisms.

The complete processor was verified using a **cycle-accurate Cocotb co-simulation environment** with automated regression testing.

---

# Processor Pipeline Architecture

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:10px;
  margin:24px 0 28px;
  font-size:0.92em;
">

  <div style="
    padding:10px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    font-weight:600;
    color:inherit;
  ">
    Instruction Stream
  </div>

  <div style="font-size:1.2em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 520px);
    padding:16px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:10px;
    background:rgba(128,128,128,0.06);
    color:inherit;
    text-align:center;
  ">
    <div style="font-size:1.05em; font-weight:600;">
      Instruction Fetch
    </div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:2px; margin-bottom:10px;">
      IF Stage
    </div>

    <div style="font-size:0.88em; line-height:1.7; opacity:0.88;">
      PC Update<br/>
      Instruction Fetch
    </div>
  </div>

  <div style="font-size:1.2em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 520px);
    padding:16px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:10px;
    background:rgba(128,128,128,0.06);
    color:inherit;
    text-align:center;
  ">
    <div style="font-size:1.05em; font-weight:600;">
      Decode / Execute
    </div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:2px; margin-bottom:10px;">
      ID / EX Stage
    </div>

    <div style="font-size:0.88em; line-height:1.7; opacity:0.88;">
      Instruction Decode<br/>
      Register Read<br/>
      ALU Execution<br/>
      Hazard Detection<br/>
      Forwarding Logic
    </div>
  </div>

  <div style="font-size:1.2em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 520px);
    padding:16px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:10px;
    background:rgba(128,128,128,0.06);
    color:inherit;
    text-align:center;
  ">
    <div style="font-size:1.05em; font-weight:600;">
      Memory / Writeback
    </div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:2px; margin-bottom:10px;">
      MEM / WB Stage
    </div>

    <div style="font-size:0.88em; line-height:1.7; opacity:0.88;">
      Memory Access<br/>
      Register Update
    </div>
  </div>

  <div style="font-size:1.2em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    padding:10px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    font-weight:600;
    color:inherit;
  ">
    Architectural State
  </div>

</div>

---

# Pipeline Design Features

## Instruction Fetch Stage (IF)

Responsibilities:

- Program counter management
- Instruction acquisition
- Instruction pipeline initialization

---

## Decode / Execute Stage (ID/EX)

This stage performs:

- Instruction decoding
- Register operand extraction
- ALU operations
- Hazard detection
- Forwarding selection

---

## Memory / Writeback Stage (MEM/WB)

Responsibilities:

- Memory access handling
- Result selection
- Register file update

---

# Hazard Mitigation

The design implements:

1. Data Forwarding
2. Hazard Detection and Pipeline Stall
3. Branch Flush Handling

---

# Data Forwarding Unit

The forwarding unit resolves Read-After-Write dependencies without unnecessary stalls.

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">EX / MEM Stage</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Forwarding Source
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">ALU Operand Selection</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Selects the Correct Forwarded Operand
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-up"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">MEM / WB Stage</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Forwarding Source
    </div>
  </div>

</div>

---

# Load-Use Hazard Detection

Example:

```
Instruction 1:
LOAD x2

Instruction 2:
ADD x3,x2,x4
```

Pipeline response:

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Hazard Detected</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Pipeline Dependency Identified
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Freeze PC</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Hold Program Counter
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Freeze IF / ID Register</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Preserve Current Pipeline State
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Insert One Bubble</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Stall the Pipeline for One Cycle
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Continue Execution</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Resume Normal Pipeline Flow
    </div>
  </div>

</div>

---

# Branch Flush Logic

When a branch is taken:

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Branch Decision</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Correct Control Flow Determined
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Incorrect Instructions Removed</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Wrong-Path Pipeline Entries Flushed
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%, 420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Pipeline Continues From Correct Path</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Instruction Flow Resumes at the Correct Target
    </div>
  </div>

</div>

---

# Verification Environment

The processor was verified using a Python-based Cocotb environment connected directly to the Verilog RTL.

Verification focuses on:

- Cycle-level behavior
- Pipeline state transitions
- Hazard handling
- Control correctness
- Regression testing

---

# Verification Flow

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Cocotb Testbench</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Python-Based Verification Environment</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Verilog RISC-V RTL</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Design Under Test</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Verilator Simulation</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Cycle-Accurate RTL Execution</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Waveform Analysis</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Inspect Pipeline and Control Signals</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Automated Regression Result</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Pass / Fail Verification Outcome</div>
  </div>

</div>

---

# Cocotb Regression Testing

## Load-Use Stall Verification

<div style="display:flex; flex-direction:column; align-items:center; gap:8px; margin:22px 0 26px; font-size:0.92em;">

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Inject Load Instruction</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Inject Dependent Instruction</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Monitor Stall Signal</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Verify Single-Cycle Stall</div>
  </div>

</div>

## Forwarding Verification

<div style="display:flex; flex-direction:column; align-items:center; gap:8px; margin:22px 0 26px; font-size:0.92em;">

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Dependent Instruction</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Forwarding Active</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">No Stall</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Pipeline Continues</div>
  </div>

</div>

## Branch Flush Verification

<div style="display:flex; flex-direction:column; align-items:center; gap:8px; margin:22px 0 26px; font-size:0.92em;">

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Taken Branch</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Branch Resolution</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Pipeline Flush</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Correct Instruction Path</div>
  </div>

</div>

---

# Simulation and Debugging

## Cocotb

Used for:

- Python-based test automation
- Instruction injection
- Cycle-level checking
- Assertion-based verification

## Verilator

Used for:

- Fast RTL simulation
- Automated regression execution

## GTKWave

Used for:

- Pipeline signal inspection
- Timing analysis
- Debugging state transitions

---

# Verification Coverage

| Feature | Verification Status |
|---|---|
| 3-Stage Pipeline | Verified |
| Instruction Flow | Verified |
| Load-Use Stall | Verified |
| Data Forwarding | Verified |
| Branch Flush | Verified |
| Pipeline Control | Verified |
| Automated Regression | Verified |

---

# Technology Stack

- Verilog
- RISC-V RV32I
- Cocotb
- Python
- Verilator
- GTKWave
- Makefiles

---

# Engineering Workflow

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Microarchitecture Design</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Define Pipeline Structure &amp; Datapath</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Pipeline RTL Implementation</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Implement Pipeline Stages in Verilog</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Hazard Detection Development</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Detect Data &amp; Control Hazards</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Forwarding Logic Integration</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Resolve RAW Dependencies Without Unnecessary Stalls</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Cocotb Verification</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Cycle-Accurate Functional Verification</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Regression Testing</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Automated Multi-Test Validation</div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;"><i class="fas fa-arrow-down"></i></div>

  <div style="width:min(100%,420px); text-align:center; padding:14px 18px; border:1px solid rgba(128,128,128,0.30); border-radius:8px; background:rgba(128,128,128,0.06); color:inherit;">
    <div style="font-weight:600;">Validated RISC-V Pipeline Core</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">Verified 3-Stage Processor Architecture</div>
  </div>

</div>

---

# Engineering Outcome

The completed project delivers a verified 3-stage pipelined RISC-V processor architecture with:

- Improved instruction throughput
- Correct hazard handling
- Efficient data forwarding
- Branch recovery support
- Automated verification environment
- Cycle-accurate testing methodology

The project demonstrates a complete RTL development workflow covering processor design, pipeline optimization, verification automation, and hardware debugging.