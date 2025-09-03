`timescale 1ns / 1ps

module IFetch_tb();

    // �����ź�
    reg clk;
    reg rst;
    reg branch;
    reg zero;
    reg [31:0] imm32;

    // ����ź�
    wire [31:0] instruction;

    // ʵ��������ģ��
    IFetch uut (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .zero(zero),
        .imm32(imm32),
        .instruction(instruction)
    );

    // ʱ������ (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns����
    end

    // ��������
    initial begin
        // ��ʼ������
        rst = 1;
        branch = 0;
        zero = 0;
        imm32 = 0;
        
        // ���μ�¼
        $dumpfile("ifetch_wave.vcd");
        $dumpvars(0, IFetch_tb);
        
        // ��ӡ����
        $display("Time(ns)\tPC\t\tInstruction\tBranch\tZero\timm32");
        $display("------------------------------------------------------------");
        
        // 1. ��λ����
        #10; // �ȴ�һ��ʱ�ӱ���
        rst = 0;
        print_state();
        
        // 2. ˳��ִ�в��� (PC+4)
        $display("\n[����1] ˳��ִ�� (PC+4)");
        repeat(3) begin
            #10;
            print_state();
        end
        
        // 3. ��֧��ת���� (branch=1, zero=1)
        $display("\n[����2] ��֧��ת (branch=1, zero=1)");
        branch = 1;
        zero = 1;
        imm32 = 32'h0000_0010; // ��֧ƫ���� +16
        #10;
        print_state();
        
        // 4. ��֧����ת���� (branch=1, zero=0)
        $display("\n[����3] ��֧����ת (branch=1, zero=0)");
        zero = 0;
        #10;
        print_state();
        
        // 5. ��λ���ܲ���
        $display("\n[����4] ��λ���ܲ���");
        rst = 1;
        #10;
        print_state();
        rst = 0;
        #10;
        print_state();
        
        // 6. ��ƫ�Ʒ�֧����
        $display("\n[����5] ��ƫ�Ʒ�֧����");
        branch = 1;
        zero = 1;
        imm32 = 32'hFFFF_FFFC; // ��֧ƫ���� -4
        #10;
        print_state();
        
        // ��������
        #10;
        $display("\n�������");
        $finish;
    end

    // ��ӡ״̬������
    task print_state;
        begin
            $display("%0t\t\t%h\t%h\t%b\t%b\t%h", 
                    $time, uut.pc, instruction, branch, zero, imm32);
        end
    endtask

    // ģ���ָ��洢����Ϊ
    // ��ʵ�ʷ����У���Ӧ���滻Ϊ��ʵ��prgromģ��
    // ������ṩ��������ģ��
    reg [31:0] simulated_rom [0:16383]; // 16K��Ŀ
    initial begin
        // ��ʼ��ROM����
        for (integer i = 0; i < 16384; i = i + 1) begin
            simulated_rom[i] = 32'h0000_0000; // ��ʼ��ΪNOPָ��
        end
        
        // �����ض���ַ��ָ��
        simulated_rom[0] = 32'h00000000;  // ��ַ 0x00000000
        simulated_rom[1] = 32'h11111111;  // ��ַ 0x00000004
        simulated_rom[2] = 32'h22222222;  // ��ַ 0x00000008
        simulated_rom[3] = 32'h33333333;  // ��ַ 0x0000000C
        simulated_rom[6] = 32'h66666666;  // ��ַ 0x00000018
    end

    // ��ģ��ROM���ӵ�IFetchģ��
    assign instruction = simulated_rom[uut.pc[15:2]];

endmodule