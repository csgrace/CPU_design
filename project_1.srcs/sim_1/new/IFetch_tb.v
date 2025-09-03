`timescale 1ns / 1ps

module IFetch_tb();

    // 输入信号
    reg clk;
    reg rst;
    reg branch;
    reg zero;
    reg [31:0] imm32;

    // 输出信号
    wire [31:0] instruction;

    // 实例化被测模块
    IFetch uut (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .zero(zero),
        .imm32(imm32),
        .instruction(instruction)
    );

    // 时钟生成 (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns周期
    end

    // 测试序列
    initial begin
        // 初始化输入
        rst = 1;
        branch = 0;
        zero = 0;
        imm32 = 0;
        
        // 波形记录
        $dumpfile("ifetch_wave.vcd");
        $dumpvars(0, IFetch_tb);
        
        // 打印标题
        $display("Time(ns)\tPC\t\tInstruction\tBranch\tZero\timm32");
        $display("------------------------------------------------------------");
        
        // 1. 复位测试
        #10; // 等待一个时钟边沿
        rst = 0;
        print_state();
        
        // 2. 顺序执行测试 (PC+4)
        $display("\n[测试1] 顺序执行 (PC+4)");
        repeat(3) begin
            #10;
            print_state();
        end
        
        // 3. 分支跳转测试 (branch=1, zero=1)
        $display("\n[测试2] 分支跳转 (branch=1, zero=1)");
        branch = 1;
        zero = 1;
        imm32 = 32'h0000_0010; // 分支偏移量 +16
        #10;
        print_state();
        
        // 4. 分支不跳转测试 (branch=1, zero=0)
        $display("\n[测试3] 分支不跳转 (branch=1, zero=0)");
        zero = 0;
        #10;
        print_state();
        
        // 5. 复位功能测试
        $display("\n[测试4] 复位功能测试");
        rst = 1;
        #10;
        print_state();
        rst = 0;
        #10;
        print_state();
        
        // 6. 负偏移分支测试
        $display("\n[测试5] 负偏移分支测试");
        branch = 1;
        zero = 1;
        imm32 = 32'hFFFF_FFFC; // 分支偏移量 -4
        #10;
        print_state();
        
        // 结束仿真
        #10;
        $display("\n仿真完成");
        $finish;
    end

    // 打印状态的任务
    task print_state;
        begin
            $display("%0t\t\t%h\t%h\t%b\t%b\t%h", 
                    $time, uut.pc, instruction, branch, zero, imm32);
        end
    endtask

    // 模拟的指令存储器行为
    // 在实际仿真中，这应该替换为真实的prgrom模块
    // 这里仅提供基本功能模拟
    reg [31:0] simulated_rom [0:16383]; // 16K条目
    initial begin
        // 初始化ROM内容
        for (integer i = 0; i < 16384; i = i + 1) begin
            simulated_rom[i] = 32'h0000_0000; // 初始化为NOP指令
        end
        
        // 设置特定地址的指令
        simulated_rom[0] = 32'h00000000;  // 地址 0x00000000
        simulated_rom[1] = 32'h11111111;  // 地址 0x00000004
        simulated_rom[2] = 32'h22222222;  // 地址 0x00000008
        simulated_rom[3] = 32'h33333333;  // 地址 0x0000000C
        simulated_rom[6] = 32'h66666666;  // 地址 0x00000018
    end

    // 将模拟ROM连接到IFetch模块
    assign instruction = simulated_rom[uut.pc[15:2]];

endmodule