---
title: "Configurable Synchronous FIFO & Protocol FSM Controllers"
collection: portfolio
type: vlsi
date: 2025-08-01
excerpt: "Design and verification of reusable RTL hardware blocks including parameterized synchronous FIFOs and glitch-free protocol FSM controllers using Verilog and Cocotb-based verification."
---


## Overview

This project focuses on the **RTL design and verification of reusable digital hardware components** using Verilog.

The objective was to develop robust, configurable hardware building blocks with emphasis on:

- Parameterized RTL architecture
- Reliable control logic implementation
- Edge-accurate sequential behavior
- Hardware verification through automated simulation

The project includes a **configurable synchronous FIFO buffer** and **serial protocol finite state machine (FSM) controllers**, both verified using a Python-based Cocotb co-simulation environment.

---

# System Architecture Overview

```mermaid
flowchart TD

    TB["Cocotb Testbench"]

    FIFO["Synchronous FIFO<br/>Controller"]
    FSM["Protocol FSM<br/>Controller"]

    BUFFER["Data Buffering Logic"]
    SERIAL["Serial Control Logic"]

    TB --> FIFO
    TB --> FSM

    FIFO --> BUFFER
    FSM --> SERIAL
```

---

# Key Modules Designed

## 1. Configurable Synchronous FIFO

A parameterized synchronous FIFO buffer was designed to provide reliable temporary data storage between digital processing blocks.

### Features

- Configurable data width
- Configurable FIFO depth
- Independent read and write pointers
- Full and empty detection logic
- Almost-full and almost-empty status indicators
- Circular pointer rollover handling

### Functional Behavior

The FIFO supports simultaneous read and write operations while maintaining correct data ordering.

<div style="
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:8px;
  margin:22px 0 26px;
  font-size:0.92em;
">

  <div style="
    width:min(100%,420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Write Interface</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Input Data &amp; Write Control
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%,420px);
    text-align:center;
    padding:16px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Synchronous FIFO</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Buffered Data Storage
    </div>
  </div>

  <div style="font-size:1.15em; opacity:0.65;">
    <i class="fas fa-arrow-down"></i>
  </div>

  <div style="
    width:min(100%,420px);
    text-align:center;
    padding:14px 18px;
    border:1px solid rgba(128,128,128,0.30);
    border-radius:8px;
    background:rgba(128,128,128,0.06);
    color:inherit;
  ">
    <div style="font-weight:600;">Read Interface</div>
    <div style="font-size:0.82em; opacity:0.70; margin-top:3px;">
      Output Data &amp; Read Control
    </div>
  </div>

</div>

### Verification Coverage

The FIFO was verified using Cocotb-based simulation with automated assertions covering:

- Concurrent read/write transactions
- Pointer increment behavior
- Pointer rollover conditions
- Full condition handling
- Empty condition handling
- Overflow prevention
- Underflow prevention

---

# 2. Serial Protocol FSM Controllers

Finite State Machine controllers were designed for serial protocol control applications.

The design implements both:

- **Moore FSM architecture**
- **Mealy FSM architecture**

with registered outputs to ensure stable and glitch-free control signals.

---

## FSM Design Flow

```mermaid
flowchart TD

    INPUT["Input Signals"]
    STATE["State Register"]
    NEXT["Next-State Logic"]
    OUTPUT["Output Logic"]
    CONTROL["Control Signals"]

    INPUT --> STATE
    STATE --> NEXT
    NEXT --> OUTPUT
    OUTPUT --> CONTROL
```

---

## FSM Design Features

- Deterministic state transitions
- Registered output generation
- Clock-edge synchronized operation
- Glitch-free control signaling
- Protocol timing validation

The controllers were simulated to validate:

- State transition accuracy
- Clock-edge behavior
- Reset operation
- Output timing correctness

---

# Verification Environment

The verification framework combines RTL simulation with Python-based automated testing.

## Verification Architecture

```mermaid
flowchart TD

    TB["Cocotb Python Testbench"]
    RTL["Verilog RTL Design"]
    SIM["Icarus Verilog Simulator"]
    WAVE["GTKWave Analysis"]
    ASSERT["Python Assertions"]

    TB --> RTL
    RTL --> SIM
    SIM --> WAVE
    TB --> ASSERT
```

---

# Verification Methodology

## Cocotb Co-Simulation

Cocotb was used as the primary verification framework to create automated hardware tests.

Verification features include:

- Python-driven stimulus generation
- Automated functional checks
- Transaction-based testing
- Assertion-based validation
- Simulation result analysis

---

## Simulation Tools

| Tool | Purpose |
|---|---|
| Verilog | RTL hardware description |
| Cocotb | Python-based verification framework |
| Python | Test automation and assertions |
| Icarus Verilog | RTL simulation engine |
| GTKWave | Waveform inspection and debugging |

---

# FIFO Verification Flow

```mermaid
flowchart TD

    START["Generate Test Transactions"]

    WRITE["FIFO Write Operations"]
    READ["FIFO Read Operations"]

    CHECK["Data Integrity Check"]
    STATUS["Verify Full / Empty Flags"]
    ASSERT["Cocotb Assertions"]
    RESULT["Verification Result"]

    START --> WRITE
    START --> READ

    WRITE --> CHECK
    READ --> CHECK

    CHECK --> STATUS
    STATUS --> ASSERT
    ASSERT --> RESULT
```

---

# FSM Verification Flow

```mermaid
flowchart TD

    INPUT["Protocol Stimulus"]
    FSM["FSM Controller"]
    STATE["State Transition Check"]
    OUTPUT["Output Signal Validation"]
    WAVE["GTKWave Timing Analysis"]

    INPUT --> FSM
    FSM --> STATE
    STATE --> OUTPUT
    OUTPUT --> WAVE
```

---

# Design Highlights

## Parameterized RTL Design

The FIFO architecture was designed with configurable parameters, allowing reuse across different hardware applications.

Key configurable elements:

- Data width
- Buffer depth
- Status thresholds

---

## Robust Sequential Control

The FSM controllers use clock-synchronized state updates and registered outputs to ensure reliable operation in synchronous digital systems.

---

## Automated Hardware Verification

The Cocotb environment enables repeatable regression testing without manual waveform inspection for every simulation run.

---

# Technology Stack

| Category | Technology |
|---|---|
| RTL Design | Verilog |
| Verification | Cocotb |
| Programming | Python |
| Simulation | Icarus Verilog |
| Waveform Debugging | GTKWave |

---

# Engineering Outcome

This project demonstrates the complete workflow of developing reusable digital hardware components:

```mermaid
flowchart TD

    A["RTL Architecture Design"]
    B["Parameterized Verilog Implementation"]
    C["Cocotb Verification Environment"]
    D["Simulation & Waveform Analysis"]
    E["Validated Hardware Building Blocks"]

    A --> B
    B --> C
    C --> D
    D --> E
```

The final design provides reusable, verified RTL modules suitable for integration into larger digital systems requiring reliable buffering, protocol control, and deterministic hardware behavior.