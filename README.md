# CPU Design — CS202 Computer Architecture

[![SUSTech](https://img.shields.io/badge/SUSTech-CS202-blue)](https://www.sustech.edu.cn/)
[![Course](https://img.shields.io/badge/Course-Computer%20Architecture-green)]()
[![FPGA](https://img.shields.io/badge/Platform-Xilinx%20Vivado-orange)]()
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)]()

> **CS202 Computer Architecture · Capstone Project**
>
> A pipelined RISC processor designed from scratch in Verilog/VHDL, validated on a Xilinx FPGA board with complex memory-mapped I/O and multi-scenario co-design.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [ISA Design](#isa-design)
- [Pipeline Design](#pipeline-design)
- [Memory-Mapped I/O](#memory-mapped-io)
- [Implementation & Validation](#implementation--validation)
- [Test Program](#test-program)
- [Results](#results)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)

---

## Overview

This project implements a **5-stage pipelined RISC processor** as the capstone of CS202 Computer Architecture at SUSTech. Starting from instruction set design and single-cycle datapath, we progressively built a fully pipelined microarchitecture with hazard detection, data forwarding, and memory-mapped I/O, culminating in FPGA bitstream generation and real board verification on a Xilinx development platform.

### Design Highlights

| Feature | Description |
|---------|-------------|
| **5-stage pipeline** | IF → ID → EX → MEM → WB with single-cycle throughput for non-hazard cases |
| **Hazard handling** | Full forwarding paths (EX→EX, MEM→EX) + pipeline stall unit for load-use hazards |
| **Harvard L1** | Separate instruction and data memory ports, zero structural hazard |
| **Memory-mapped I/O** | Unified addressing for buttons, DIP switches, LEDs, and 7-segment displays |
| **16 test scenarios** | Comprehensive assembly-level validation covering arithmetic, control, CRC, floating-point |
| **Co-designed toolchain** | Python-based automated testing + Vivado synthesis + on-board debugging |

```
�─────────────────────────────────────────────────────────────────┐
│                    CS202 CPU Design Flow                         │
│                                                                  │
│  ISA Definition → Single-Cycle → Pipeline → Hazard & Forward    │
│       ↓              ↓              ↓            ↓              │
│  Assembly tests   Datapath sim   Throughput   FPGA bitstream    │
│       └─────────────┴──────────────┴────────────�               │
│                          ↓                                       │
│              �───────────────────────�                          │
│              │  FPGA Board Validation │                          │
│              │  (Switches→CPU→LEDs)   │                          │
│              └───────────────────────┘                          │
└─────────────────────────────────────────────────────────────────�
```

---

## Architecture

### Pipeline Datapath

```
   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐
   │  IF  │──▶│  ID  │──▶│  EX  │──▶│ MEM  │──▶│  WB  │
   │      │   │      │   │      │   │      │   │      │
   │ IMem │   │ Reg  │   │ ALU  │   │ DMem │   │ Reg  │
   │  PC  │   │ Decode│  │Branch│   │ I/O  │   │Write │
   └──────┘   └──────�   └──────┘   └──────┘   └──────┘
      ▲           │           │           │          │
      │           │    ┌──────┴──────┐    │          │
      │           └───▶│  Forwarding │◀───┘          │
      │                │    Unit     │               │
      │                └─────────────�               │
      │                                              │
      └──────────── WB to RegFile ──────────────────�
```

### Key Microarchitectural Decisions

- **Separate IMem/DMem ports**: Hardwired Harvard-style memory eliminates all structural hazards
- **ALU result forwarding**: Directly from EX/MEM pipeline register to ALU inputs in next cycle, breaking dependency chain after 1 bubble
- **MEM target forwarding**: For load-use patterns (e.g., `lw` → `add`), a single-cycle stall is inserted only when no forwarding path can resolve the hazard
- **Early branch resolution**: Branch condition evaluation performed in EX stage to minimize branch penalty

---

## ISA Design

A custom RISC instruction set designed around compactness and pipeline efficiency, supporting **3 instruction formats** (R, I, B) with clean decode boundaries:

| Format | Usage | Fields |
|--------|-------|--------|
| **R-type** | ALU ops with 2 register sources | `funct7 \| rs2 \| rs1 \| funct3 \| rd \| opcode` |
| **I-type** | Immediate arithmetic, loads, JALR | `imm[11:0] \| rs1 \| funct3 \| rd \| opcode` |
| **B-type** | Conditional branches | `imm \| rs2 \| rs1 \| funct3 \| imm \| opcode` |

### Instruction List (30 instructions)

| Type | Instructions |
|------|-------------|
| **Arithmetic** | `add`, `addi`, `sub`, `lui` |
| **Logical / Shift** | `andi`, `srli`, `srl`, `slli`, `sll` |
| **Data Transfer** | `lw`, `sw`, `lb`, `lbu`, `li` |
| **Control Flow** | `beq`, `blt`, `bltu`, `j`, `jal`, `jalr` |
| **Comparison** | `slt`, `sltu` |

### Design Choices
- **RISC philosophy**: Fixed instruction width for single-cycle decode, load/store architecture, only register-to-register ALU operations
- **Position-independent branches**: PC-relative B-type encoding for relocatable code
- **Synthesizable immediates**: Clean sign-extension and concatenation paths for every I/B-type field, avoiding timing-critical paths

---

## Pipeline Design

### Single-Cycle Baseline

Initial implementation executes each instruction within one clock cycle. Simple but inefficient — clock period limited by the sum of all stage latencies.

**Design insight**: While straightforward, single-cycle gives a clean reference for functional correctness before pipeline decomposition.

### 5-Stage Pipeline

The processor is decomposed into five stages for significant throughput improvement:

| Stage | Operation | Pipeline Register Output |
|-------|-----------|-------------------------|
| **IF** | IMem access, PC + 4 | Instr, PC+4 |
| **ID** | RegFile read, immediate decode | RegData1, RegData2, Imm, PC+4 |
| **EX** | ALU compute, branch ALU | ALU result, branch target, zero flag |
| **MEM** | DMem read/write, I/O access | Mem read data, ALU result pass-through |
| **WB** | Mux select, RegFile write | Write register data |

### Hazard Unit

The processor implements dynamic hazard detection and resolution:

| Hazard Type | Detection | Resolution |
|-------------|-----------|------------|
| **Data (RAW)** | Src reg in IF/ID matches dst reg in EX/MEM | Forward from pipeline registers; insert 1 bubble for load-use |
| **Control** | Branch resolves in EX; next 2 IF/ID may be wrong | Flush IF/ID and ID/EX after branch; redirect PC |
| **Structural** | (Eliminated) Separate IMem/DMEM ports | None needed |

**Forwarding paths:**
- EX → EX: EX/MEM result → ALU input A/B (resolves most back-to-back ALU dependencies)
- MEM → EX: MEM/WB result → ALU input A/B (resolves dependencies 2+ instructions back)
- WB → EX: Written register → read port (register file internal forwarding)

---

## Memory-Mapped I/O

The processor communicates with external peripherals through a **memory-mapped I/O** scheme. The address space is partitioned into data memory (normal range) and I/O space (top of 32-bit address).

| Peripheral | Address | Dir | Width | Purpose |
|------------|---------|-----|-------|---------|
| Confirm Key | `0xFFFFFC7C` | Input | 32-bit | User button (acknowledge) |
| Scene Select | `0xFFFFFC74` | Input | 3-bit | DIP switch (scene ID) |
| Data Input | `0xFFFFFC70` | Input | 8-bit | DIP switch (8-bit data) |
| LED Output | `0xFFFFFC60` | Output | 8-bit | Onboard LEDs |
| Display A | `0xFFFFFC64` | Output | 32-bit | 7-segment (value A) |
| Display B | `0xFFFFFC68` | Output | 32-bit | 7-segment (value B) |
| Float A (internal) | `0xFFFFEC60` | — | 32-bit | Working storage |
| Float B (internal) | `0xFFFFEC64` | — | 32-bit | Working storage |

**I/O mechanism:** A simple address decoder in the MEM stage routes `lw`/`sw` to DMem or I/O registers. All peripherals appear as normal memory operations — no special I/O instructions needed.

---

## Implementation & Validation

### Tools & Flow

```
�────────────�    �────────────�    �────────────�    �────────────�
│  RTL (HDL)  │───▶│  Vivado     │───▶│ Simulation │───▶│ Bitstream  │
│  Verilog +  │    │  Synthesis  │    │ + Python   │    │ + Board    │
│  VHDL       │    │  P&R        │    │ automation │    │ programming│
└────────────┘    └────────────┘    └────────────�    └────────────┘
```

- **RTL**: Verilog + VHDL mixed-language design
- **Synthesis**: Xilinx Vivado (Artix-7 FPGA target)
- **Simulation**: Vivado behavioral simulator + custom Python test harness
- **Validation**: Python-driven test scenario execution against expected vectors
- **Board**: Onboard verification via DIP switches → CPU → LEDs/7-segment

### Test & Verification Strategy

The `proj.asm` assembly program systematically covers every ISA instruction category and pipeline path:

```python
# Test_scenario2_tc2_3_4_5.py — Automated pipeline test
for scene in range(16):
    load_inputs(switches, scene)     # Set DIP switches
    reset_cpu()
    run_clocks(10)                   # Let pipeline drain
    capture_outputs(leds, display)   # Read results
    assert equal(capture, expected)  # Check correctness
```

---

## Test Program

The complete assembly test (`proj.asm`) consists of **16 scenes** (2 groups × 8 sub-scenes) that collectively exercise every processor feature. Selected highlights:

### Scene Group 1: Basic Pipeline Paths

| Scene | Feature | What It Tests |
|-------|---------|---------------|
| 0 | LED passthrough | `lw` + `sw` through I/O address range; basic memory-mapped output |
| 1 | Signed display | `lb` sign-extension → display register; ID-stage imm decode |
| 2 | Unsigned display | `lbu` zero-extension; distinguishes signed vs. unsigned paths |
| 3–5 | Conditional branches | `beq`, `blt`, `bltu`; tests **branch flush + control hazard** |
| 6–7 | Set-on-less-than | `slt`/`sltu` → ALU result forwarding (**data hazard on EX path**) |

### Scene Group 2: Advanced Features

| Scene | Feature | What It Tests |
|-------|---------|---------------|
| 8 | Bit reversal (8-bit) | String of `srl`/`slli`/`andi` — tests shift instruction chains and **3 consecutive forwarding** scenarios |
| 9 | Palindrome check | Combination arithmetic + branch; exercises full pipeline interplay |
| 10–11 | Custom 8-bit float add | Simulated IEEE-like format (1s + 3exp + 4man), multi-register computation, MEM-stage pipeline flushing |
| 12 | CRC-4 encoding | Feedback shift register pattern — tight loop with `xor`/`slli` referencing previous result (**load-use stall**) |
| 13 | CRC-8 verification | Longer feedback pattern + error/valid branching; tests branch in tight loop |
| 14 | `lui` instruction | Upper immediate load → big-value pipeline test |
| 15 | Subroutine call | `jal` + `jalr` — tests **call/return pipeline** with PC redirection and `ra` register writeback |

---

## Results

### Summary

- ✅ All 30 ISA instructions verified in behavioral simulation
- ✅ All 16 assembly test scenes pass simulation + automated Python check
- ✅ FPGA successfully programmed and responsive to all DIP switch inputs
- ✅ LED and 7-segment outputs match expected values for every scene
- ✅ Pipeline hazards resolved correctly (verified by controlled benchmark sequences)
- ✅ `jal`/`jalr` subroutine linkage confirmed working on hardware

---

## Repository Structure

```
CPU_design/
├── project_1.xpr                  # Vivado project file
├── project_1.srcs/                # RTL source files
│   ├── *.v / *.vhdl               # Pipeline stages, hazard unit, control
│   └── constraints.xdc            # Pin constraints for target board
├── project_1.sim/                 # Simulation testbenches
├── project_1.runs/                # Synthesis & implementation runs
│   └── impl_1/                    # Post-place-and-route results
├── project_1.hw/                  # Hardware manager config
├── project_1.ip_user_files/       # Xilinx IP core settings
├── project_1.cache/               # Incremental compile cache
├── proj.asm                       # Full assembly test (16 scenes)
├── proj.coe                       # ROM initialization file
├── Test_scenario2_tc2_3_4_5.py    # Python automated simulation tests
├── 中期答辩/                       # Mid-term defense (slides & notes)
│   └── *.pptx
├── 项目总结文档.docx                # Detailed design report (Chinese)
└── Project要求.pdf                 # Course requirements & grading rubric
```

---

## Getting Started

### Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| **Xilinx Vivado** | 2018.3+ | Synthesis, implementation, bitstream generation |
| **Python** | 3.8+ | Automated test scripting |
| **FPGA Board** | Xilinx 7-series compatible | Hardware validation (optional for simulation only) |

### Workflow

```bash
# 1. Behavioral simulation (no hardware needed)
vivado project_1.xpr
# Run: Run Simulation → Behavioral Simulation

# 2. Run automated tests
python Test_scenario2_tc2_3_4_5.py

# 3. Generate bitstream for FPGA
# Run: Generate Bitstream → Program Device

# 4. Validate on hardware
# Set DIP switches → press confirm → observe LEDs / 7-segment display
```

---

*CS202 Computer Architecture — SUSTech 2025*
