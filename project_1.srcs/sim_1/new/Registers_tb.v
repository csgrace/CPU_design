`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Registers_tb();
reg clk;
reg rst;
reg RegWrite; //来自Controller
reg [4:0] ReadRegister1;
reg [4:0] ReadRegister2;
reg [4:0] WriteRegister; 
reg [31:0] ALUResult;
reg [31:0] Readdata;
reg MemtoReg;
wire [31:0] ReadData1; //给到ALU
wire [31:0] ReadData2; //给到ALU
Registers u1 (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .ReadRegister1(ReadRegister1),
        .ReadRegister2(ReadRegister2),
        .WriteRegister(WriteRegister),
        .ALUResult(ALUResult),
        .Readdata(Readdata),
        .MemtoReg(MemtoReg),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
);

always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 0;
        RegWrite = 0;
        ReadRegister1 = 5'b00000;
        ReadRegister2 = 5'b00000;
        WriteRegister = 5'b00000;
        ALUResult = 32'h00000000;
        Readdata = 32'h00000000;
        MemtoReg = 0;       
        #10 rst = 1;
        
        // R : add x1,x2,x3 0000000 00011 00010 000 00001 0110011                
        RegWrite = 1;
        WriteRegister = 5'b00001;
        ALUResult = 32'h00000002; // 模拟 x2 + x3 的结果
        MemtoReg = 0; 
        #10 RegWrite = 0; 
        ReadRegister1 = 5'b00001; 
        #10;

        // I : addi x2,x1,1 000000000001 00001 000 00010 0010011
        RegWrite = 1;
        WriteRegister = 5'b00010; 
        Readdata = 32'h00000003; // 模拟 x1 + 1 的结果
        MemtoReg = 1; 
        #10 RegWrite = 0;
        ReadRegister2 = 5'b00010; 
        #10;        
        //U : lui x3, 0x12345 00010010001101000001 00011 0110111
        RegWrite = 1'b1;
        WriteRegister = 5'b00011; 
        ALUResult = 32'h12345000; // 高 20 位立即数
        MemtoReg = 1'b0; 
        #10 RegWrite = 1'b0; 
        ReadRegister1 = 5'b00011;
        #10;

        // S : sw x5,100(x6) 0000110 00101 00110 010 00100 0100011  //100的二进制：000001100100
        RegWrite = 0;  //不涉及寄存器写入
        WriteRegister = 5'b00101; 
        ALUResult = 32'hFFFFFFFF; // Data to write
        MemtoReg = 0; // Select ALUResult as WriteData
        ReadRegister1 = 5'b00110; // Read register 0
        #10;

        // B : beq x6,x7,8 0 000000 00111 00110 000 0100 0 1100011
        RegWrite = 1'b0;// 不涉及寄存器写入
        ReadRegister1 = 5'b00110; 
        ReadRegister2 = 5'b00111; 
        #10; 
        
        //J : jal x0, 16 0 0000001000 0 00000000 00000 1101111
        RegWrite = 1'b0;// 不涉及寄存器写入
        WriteRegister = 5'b00000; 
        ALUResult = 32'h00000010;
        #10;       
        $finish;
    end
endmodule
