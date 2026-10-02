---
title: "3-Stage Pipelined RISC-V Core & Automated Cocotb Regression Suite"
collection: portfolio
type: vlsi
date: 2025-09-15
excerpt: "Design and verification of a 3-stage pipelined RISC-V processor featuring hazard detection, data forwarding, branch flushing, and automated Cocotb regression testing."
---

# 3-Stage Pipelined RISC-V Core & Automated Cocotb Regression Suite

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

```
Instruction Stream

        |
        v

+----------------------+
| Instruction Fetch    |
|        IF            |
|                      |
| PC Update            |
| Instruction Fetch    |
+----------------------+

        |
        v

+----------------------+
| Decode / Execute     |
|       ID/EX          |
|                      |
| Instruction Decode   |
| Register Read        |
| ALU Execution        |
| Hazard Detection     |
| Forwarding Logic     |
+----------------------+

        |
        v

+----------------------+
| Memory / Writeback   |
|       MEM/WB         |
|                      |
| Memory Access        |
| Register Update      |
+----------------------+

        |
        v

 Architectural State
```

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

```
EX/MEM Stage
      |
      v
 ALU Operand Selection
      ^
      |
MEM/WB Stage
```

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

```
Hazard Detected

        |
        v

Freeze PC

Freeze IF/ID Register

Insert One Bubble

Continue Execution
```

---

# Branch Flush Logic

When a branch is taken:

```
Branch Decision

        |
        v

Incorrect Instructions Removed

        |
        v

Pipeline Continues From Correct Path
```

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

```
Cocotb Testbench

        |

Verilog RISC-V RTL

        |

Verilator Simulation

        |

Waveform Analysis

        |

Automated Regression Result
```

---

# Cocotb Regression Testing

## Load-Use Stall Verification

```
Inject Load Instruction

        |

Inject Dependent Instruction

        |

Monitor Stall Signal

        |

Verify Single-Cycle Stall
```

## Forwarding Verification

```
Dependent Instruction

        |

Forwarding Active

        |

No Stall

        |

Pipeline Continues
```

## Branch Flush Verification

```
Taken Branch

        |

Branch Resolution

        |

Pipeline Flush

        |

Correct Instruction Path
```

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

```
Microarchitecture Design

        |

Pipeline RTL Implementation

        |

Hazard Detection Development

        |

Forwarding Logic Integration

        |

Cocotb Verification

        |

Regression Testing

        |

Validated RISC-V Pipeline Core
```

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