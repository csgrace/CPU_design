# 🖥️ CS202 计算机组成原理 — CPU 设计

> **SUSTech CS202 Computer Architecture Course Project**
> 
> 从 ISA 设计、数据通路实现到流水线优化，在 FPGA 平台上构建一个完整的 RISC 处理器。

---

## 📌 项目概述

本项目是南方科技大学 **CS202 计算机组成原理** 的综合课程项目，以 Xilinx FPGA 为设计平台，使用 **Verilog / VHDL** 完成了一个支持多种测试场景的 RISC 处理器。

项目覆盖计算机体系结构设计的全流程：

```
ISA 设计 → 单周期数据通路 → 多级流水线 → 冒险检测 & 前递 → 仿真验证 → FPGA 上板
```

处理器支持 **内存映射 I/O**，可直接在 FPGA 板上通过拨码开关、按键、LED 和数码管进行交互，完整验证了处理器在实际硬件环境下的功能正确性。

---

## 🏗️ 处理器架构

### ISA 设计

自定义 RISC 风格精简指令集，支持以下指令类型：

| 类型 | 指令 | 说明 |
|------|------|------|
| **算术逻辑** | `add`, `addi`, `sub` | 整数算术运算 |
| **位运算** | `srl`, `srli`, `sll`, `slli`, `andi` | 移位与逻辑运算 |
| **数据传送** | `lw`, `sw`, `lb`, `lbu`, `li`, `lui` | 内存读写与立即数加载 |
| **分支跳转** | `beq`, `blt`, `bltu` | 条件分支 |
| **无条件跳转** | `j`, `jal`, `jalr` | 跳转与链接（支持函数调用） |
| **比较置位** | `slt`, `sltu` | 有符号/无符号比较 |

### 数据通路演进

1. **单周期实现** — 一条指令在一个时钟周期内完成，设计简单直观，作为验证基线
2. **多级流水线** — 将指令执行划分为多个阶段，提高吞吐率
   - 结构冒险：分离指令/数据存储器（哈佛结构）
   - 数据冒险：实现 **前递（Forwarding）** 机制与流水线暂停
   - 控制冒险：分支决策优化与流水线冲刷

### 内存映射 I/O

处理器通过特定内存地址与外设交互，地址分配如下：

| 外设 | 地址 | 位宽 | 说明 |
|------|------|------|------|
| 确认键输入 | `0xFFFFFC7C` | 32-bit | 用户确认按钮 |
| 测试场景选择 | `0xFFFFFC74` | 3-bit | 拨码开关选择 |
| 数据输入 | `0xFFFFFC70` | 8-bit | 8 位拨码开关 |
| LED 输出 | `0xFFFFFC60` | 8-bit | 红色 LED 显示 |
| 数码管输出 | `0xFFFFFC64` | 32-bit | 七段数码管显示 |

---

## 📂 仓库结构

```
CPU_design/
├── project_1.xpr              # Vivado 工程主文件
├── project_1.srcs/            # 源码目录（Verilog/VHDL）
├── project_1.sim/             # 仿真目录
├── project_1.runs/            # 综合与实现运行目录
├── project_1.hw/              # 硬件配置
├── project_1.cache/           # 工程缓存
├── project_1.ip_user_files/   # IP 核用户文件
├── proj.asm                   # 汇编测试程序（16 个场景）
├── proj.coe                   # ROM 初始化文件（coe 格式）
├── Test_scenario2_tc2_3_4_5.py # Python 自动化仿真测试脚本
├── 项目总结文档.docx            # 完整设计文档（含技术细节）
├── 中期答辩/                   # 中期答辩 PPT & 材料
├── Project要求.pdf             # 项目任务书（含评分标准）
└── README.md                  # 本文件
```

---

## 🚀 快速开始

### 环境要求

| 工具 | 版本（推荐） | 用途 |
|------|------------|------|
| **Vivado** | 2018.3+ | FPGA 综合、实现与下载 |
| **Python** | 3.8+ | 自动化测试脚本 |

### 设计与仿真

```bash
# 1. 打开 Vivado 工程
vivado project_1.xpr

# 2. 运行行为仿真（无需 FPGA 开发板）
#    Vivado: Flow → Run Simulation → Run Behavioral Simulation

# 3. Python 自动化测试
python Test_scenario2_tc2_3_4_5.py
```

### FPGA 上板

```bash
# 1. 生成比特流
#    Vivado: Flow → Generate Bitstream

# 2. 连接 FPGA 开发板，下载比特流
#    Hardware Manager → Auto Connect → Program Device

# 3. 通过拨码开关与按键选择和输入测试场景，观察 LED 与数码管输出
```

---

## 🧪 测试场景

汇编程序 `proj.asm` 实现 16 个测试场景（分为 2 大场景组），覆盖以下功能：

| 场景 | 功能模块 | 说明 |
|------|---------|------|
| **Set 0/1/2** | 基本 I/O | LED 直出、有符号/无符号输入显示 |
| **Set 3/4/5** | 整数比较 | `beq`、`blt`、`bltu` 分支跳转验证 |
| **Set 6/7** | 比较置位 | `slt`、`sltu` 指令功能验证 |
| **Set 8** | 位反转 | 8-bit 位逆序运算 |
| **Set 9** | 回文判断 | 输入数据正反读相同即确认 |
| **Set 10/11** | 浮点运算 | 自定义 8-bit 格式浮点数（1-bit 符号 + 3-bit 指数 + 4-bit 尾数）加法 |
| **Set 12** | CRC 编码 | 4-bit 数据 + CRC-4 校验码生成 |
| **Set 13** | CRC 校验 | 8-bit 数据 CRC 校验（正确/错误判断） |
| **Set 14** | LUI 指令 | `lui` 高位立即数加载验证 |
| **Set 15** | 函数调用 | `jal` / `jalr` 跳转与链接，验证过程调用机制 |

---

## � 设计流程总结

| 阶段 | 产物 | 工具 |
|------|------|------|
| ISA 规范 | 指令集文档 & 编码方案 | Markdown / docx |
| RTL 设计 | 数据通路、控制单元、流水线 | Verilog / VHDL |
| 功能仿真 | 波形验证 & 覆盖率检查 | Vivado Simulator |
| 综合与实现 | 时序报告 & 资源利用率 | Vivado Synthesis / Implementation |
| 板级验证 | 实时 I/O 交互测试 | FPGA 开发板 |

---

## 🛠️ 技术栈

- **硬件描述语言**：Verilog HDL、VHDL
- **开发工具**：Xilinx Vivado Design Suite
- **仿真测试**：Vivado Simulator + Python 自动化脚本
- **目标平台**：Xilinx FPGA（具体型号见 Vivado 工程配置）
- **汇编层**：自定义 RISC ISA + 配套汇编程序与 ROM 初始化文件
- **文档**：设计总结报告 + 中期答辩材料

---

*Built with ❤️ for CS202 @ SUSTech*
