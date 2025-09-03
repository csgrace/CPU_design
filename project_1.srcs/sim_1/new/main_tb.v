`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module main_tb();
reg clk;
reg rst;
reg sure_btn1; // 确认按钮
reg [15:0] switches; // 八个拨码开关输入

wire zero;
wire [31:0] instruction, ALUResult;
wire [31:0] imm32, ReadData1, ReadData2;
//wire [31:0] ReadData2;
wire RegWrite,Branch, MemRead, MemorIOtoReg, MemWrite, ALUSrc;
wire [31:0] r_wdata;
wire [1:0] ALUOp;
wire IORead;
wire IOWrite;
wire [31:0] WriteData, Readdata;    
wire [31:0] addr_out;
wire [4:0] ReadRegister1;  // rs1
wire [4:0] ReadRegister2;  // rs2
wire [4:0] WriteRegister;
wire [31:0] pc_latch;
wire jump;
wire jalr_if;
//wire sure_btn1_pressed;
 
wire [15:0] leds; // 八个灯的输出
wire [7:0] num;
wire [7:0] led;
wire [7:0] led1;


initial begin
clk=1'b0;
forever #2 clk=~clk;
end

initial begin
rst=1'b1;
#5 rst=1'b0;
end

initial begin
sure_btn1=1'b0;
#5 sure_btn1=1'b1;
end

initial begin
switches=16'h0000;
#500 switches=16'h3C41; //0011 1100 //010
#500 switches=16'h01E1; //0000 0001 //011
//#100 switches=16'h0240;
//#100 switches=16'h0060;
//#100 switches=16'h0220;
//#100 switches=16'h0060;
//#100 switches=16'h00c0;
//#100 switches=16'h00e0;
#200 $finish;
end

//initial begin
//    $monitor("Time=%t: pc=%h, inst=%h", $time, umain.ufetch.pc, instruction);
//end

Main uut (
        .clk(clk),
        .rst(rst),
        .sure_btn1(sure_btn1),
        .switches(switches),
        
        .zero(zero),
        .instruction(instruction),
        .ALUResult(ALUResult),
        .imm32(imm32),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemorIOtoReg(MemorIOtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .r_wdata(r_wdata),
        .ALUOp(ALUOp),
        .IORead(IORead),
        .IOWrite(IOWrite),
        .WriteData(WriteData),
        .Readdata(Readdata),
        .addr_out(addr_out),
        .ReadRegister1(ReadRegister1),  // rs1
        .ReadRegister2(ReadRegister2),  // rs2
        .WriteRegister(WriteRegister),
        .pc_latch(pc_latch),
        .jump(jump),
        .jalr_if(jalr_if),
//        .sure_btn1_pressed(sure_btn1_pressed),
        
        .leds(leds),
        .num(num),
        .led(led),
        .led1(led1)
    );

endmodule
