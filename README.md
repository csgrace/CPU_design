# CPU_design
CS202计算机组成原理project

本仓库主要用于保存和展示一个CPU设计课程项目的全部内容，包括设计文档、代码、仿真脚本以及相关资料。项目涵盖了CPU架构设计、汇编程序、仿真测试与答辩材料等。

## 仓库结构

- `项目总结文档.docx`  
  项目总结文档，详细总结了本次CPU设计项目的思路、实现过程、关键技术及项目成果。

- `Project要求.pdf`  
  项目任务书，包含项目目标、功能需求及评分标准。

- `proj.asm`  
  汇编源代码，描述了在自设计CPU上运行的测试/演示程序。

- `proj.coe`  
  存储初始化文件，通常用于FPGA等平台的存储器或ROM初始化。

- `Test_scenario2_tc2_3_4_5.py`  
  仿真测试脚本，实现对CPU部分功能点的仿真验证。

- `project_1.xpr`  
  Vivado工程主文件，用于打开并管理整个FPGA设计工程。

- `project_1.cache/`, `project_1.hw/`, `project_1.ip_user_files/`, `project_1.runs/`, `project_1.sim/`, `project_1.srcs/`  
  Vivado工程生成的缓存、硬件描述、内核、运行、仿真和源码等工作目录，包含具体的RTL代码、IP核配置和中间结果等。

- `中期答辩/`  
  项目中期答辩相关材料。

- `.gitattributes`, `README.md`  
  Git配置和说明文件。

## 快速开始

1. 阅读 `Project要求.pdf` 了解项目目标。
2. 浏览 `项目总结文档.docx` 获取实现思路及总结。
3. 查看 `proj.asm` 和 `proj.coe` 理解汇编程序与存储初始化方式。
4. 使用 Vivado 打开 `project_1.xpr` 进行工程管理与综合实现。
5. 运行 `Test_scenario2_tc2_3_4_5.py` 进行仿真测试。

