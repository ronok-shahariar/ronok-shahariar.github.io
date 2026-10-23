---
title: "RISC-V-Based Fault-Resilient INT8 AI Accelerator"
collection: portfolio
type: vlsi
permalink: /portfolio/riscv-resilient-ai-accelerator/
date: 2026-08-01
classes: wide
excerpt: "Custom SoC featuring a PicoRV32 soft-core, 32-bit MMIO bus, and a fault-resilient signed INT8 MAC co-processor targeting an Artix-7 FPGA with runtime SEU fault injection and dynamic saturation clamping."
---


The project implements a custom System-on-Chip (SoC) centered around a PicoRV32 soft-core processor connected via a 32-bit Memory-Mapped I/O (MMIO) bus to 16 KB of block RAM, a UART telemetry interface, and a custom signed INT8 multiply-accumulate (MAC) co-processor targeting an Artix-7 FPGA (`xc7a200t-fbg484-2`). The architectural motivation is driven by the reality that environmental radiation, cosmic rays, or abnormal operating conditions can induce transient bit flips, which risk causing severe computational corruption or system failure in critical applications. To counteract this, the design embeds runtime fault resilience directly into the arithmetic datapath through software-controlled Single-Event Upset (SEU) injection—using XOR bit-masking across operand registers—coupled with dynamic saturation clamping that monitors accumulated values to clip anomalous activations and raise sticky error flags (`CLAMP_HIT`) without interrupting primary execution.

The implementation achieves exceptional area efficiency, consuming under 1% of total logic resources and 1.1% of block RAM, and is fully verified through exhaustive simulation of 65,536 signed INT8 activation-weight pairs alongside successful physical synthesis and bitstream generation (`riscv_soc_top.bit`). However, the design encounters a critical timing closure bottleneck when evaluated against a strict 200 MHz system clock, recording a Worst Negative Slack (WNS) of `-5.782 ns`. This violation originates from a deep combinatorial critical path (`10.650 ns`) where multiplication, fault-injection emulation, and saturation clamping execute entirely within a single clock cycle—revealing an architectural trade-off between control simplicity and operating frequency, despite robust signal routing stability and passing hold timing.


![Xilinx Artix-7 ALINX AX7203 FPGA Hardware Deployment]({{ '/images/riscv-accelerator/fpga.jpg' | relative_url }})

---


---

##  System Architecture

![RISC-V SoC Block Diagram]({{ '/images/riscv-accelerator/riscv_soc_block_diagram.jpeg' | relative_url }})

The system connects the PicoRV32 CPU over a 32-bit memory bus to **16 KB of instruction/data RAM**, a memory-mapped fault-resilient INT8 MAC controller across `0x80000000`–`0x8000001C`, and differential clock buffers.

### Datapath Highlights:
1. **Operand Registers:** `ACTIVATION` (`0x00`) and `WEIGHT` (`0x04`) storing signed INT8 operands.
2. **Fault Injection Unit (FIU):** Software-controlled runtime single-event upset (SEU) injection via XOR bit-masking (`FAULT_CONFIG` at `0x14`).
3. **Signed INT8 MAC:** 8 x 8 -> 16-bit multiplier sign-extended to a 32-bit accumulator.
4. **Dynamic Saturation Clamping:** Low-overhead bounding logic (`PROTECTION` at `0x18`, `CLAMP_BOUND` at `0x1C`) that clips anomalous activations and raises sticky status bit `CLAMP_HIT`.

---

## Verification & Process Flow

![Verification Flowchart]({{ '/images/riscv-accelerator/riscv_soc_verification_flow.jpeg' | relative_url }})

### Verified Results Summary

| Verification Scope | Result | Details |
| :--- | :--- | :--- |
| **PicoRV32 Baseline** | Passed | RV32I instruction execution in simulation |
| **Bare-Metal Firmware** | Passed | GCC-compiled C firmware writes expected MMIO values |
| **INT8 MAC Arithmetic** | **213 checks passed** | Signed arithmetic, boundaries, and idle/clear controls |
| **Exhaustive Simulation** | **65,536 pairs passed** | Every signed INT8 activation/weight combination tested |
| **Fault Resilience** | **9 checks passed** | Bit-flip sweeps (b0–b7) and dynamic clamping verification |
| **MMIO Peripheral** | **16 checks passed** | Register operations, status, and clear handshakes |
| **CPU-Accelerator Integration** | Passed | Firmware-issued MAC commands accumulator transition (**35 -> 23 -> 39**) |
| **FPGA Synthesis & Bitstream** | **Passed (0 Errors)** | Physical synthesis, timing closure, and `riscv_soc_top.bit` generation |

All **seven regression suites** pass locally and in automated CI pipelines.

---

---

## Vivado Synthesis & Implementation Analysis Summary


### 1. Architectural Layout & Resource Footprint
Post-synthesis netlist inspection confirms a clean hierarchical design consisting of 9 cells and 244 nets, maintaining an exceptionally lightweight resource footprint (<1% total logic usage).
* **Slice LUTs:** 1,319 / 133,800 (0.99%)
* **Slice Registers:** 741 / 267,600 (0.28%)
* **Block RAM (BRAM):** 4 tiles (1.10%) for 16KB system memory.

![Top-Level Schematic]({{ '/images/riscv-accelerator/top_level_schematic.png' | relative_url }})  
*Figure: Post-synthesis top-level schematic (`soc_top`) showing differential clock buffers and unified MMIO routing.*

![Resource Utilization]({{ '/images/riscv-accelerator/resource_utilization.png' | relative_url }})
*Figure: Hierarchical resource breakdown showing low logic density and high fabric availability.*

### 2. Timing Performance & Architectural Trade-off
* **The Trade-off (Simplicity vs. Speed):** Executing multiplication, SEU fault-injection emulation, and dynamic saturation clamping entirely within a **single clock cycle** simplifies control logic but creates a deep combinatorial path (`10.650 ns` propagation delay).
* **Timing Metrics:** Against a strict 200 MHz system clock constraint (5.000 ns period), the implementation records a Worst Negative Slack (WNS) of `-5.782 ns`. However, hold timing (`+0.099 ns`) and pulse width (`+1.370 ns`) pass cleanly, proving physical routing stability.

![Timing Summary]({{ '/images/riscv-accelerator/timing_summary.png' | relative_url }})  
*Figure: Vivado Design Timing Summary indicating setup slack violations at 200 MHz.*

### 3. Version 2.0 Roadmap
- **Pipeline Datapath:** Transition single-cycle MAC and saturation logic into a multi-stage pipeline to achieve 200 MHz timing closure.
- **Clock Scaling:** Alternatively target 100 MHz constraints for immediate board deployment.
- **Dual-Core Redundancy:** Leverage remaining FPGA fabric (>98%) for Dual-Modular Redundancy (DMR).

---
---

## Repository Guide & Full Documentation

For complete source code, testbenches, automated non-GUI Vivado scripts, and full weekly engineering reports, explore the GitHub repository below:

* **Main Repository:** [ronok-shahariar/riscv-resilient-ai-accelerator](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator)

### Directory & Documentation Mapping

| Directory / Resource | Description & Contents |
| :--- | :--- |
| [`architecture/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/architecture) | System architecture overviews, pin mappings, and MMIO maps |
| [`rtl/cpu/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/rtl/cpu) | PicoRV32 processor RTL sources |
| [`rtl/accelerator/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/rtl/accelerator) | Custom INT8 MAC RTL and MMIO controller |
| [`rtl/soc/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/rtl/soc) | Top-level SoC wrapper (`soc_top.v`) |
| [`constraints/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/constraints) | Board pin constraints (`ax7203.xdc`) |
| [`vivado_run_command/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/vivado_run_command) | Automated non-GUI Vivado build and synthesis scripts |
| [`firmware/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/firmware) | Bare-metal C runtime and accelerator test firmware |
| [`simulation/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/simulation) | Self-checking verification testbenches |
| [`scripts/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/scripts) | Test runner and build automation scripts |
| [`docs/weekly-reports/`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/tree/main/docs/weekly-reports) | Comprehensive weekly engineering reports |
| [`Vivado Report Analysis`](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator/blob/main/docs/vivado_report_analysis/report_v1.0.md) | In-depth timing, resource utilization, and trade-off documentation |


##  Authorship & Licensing

- **Maintainer & Author:** Md Shahariar Hassan ([346ronokarya@gmail.com](mailto:346ronokarya@gmail.com))
- **Repository:** [ronok-shahariar/riscv-resilient-ai-accelerator](https://github.com/ronok-shahariar/riscv-resilient-ai-accelerator)
- **License:** Apache License 2.0 (See `LICENSE` and `NOTICE` for details).
- **Third-Party IP:** Includes [PicoRV32](https://github.com/YosysHQ/picorv32) by Claire Xenia Wolf (ISC License).