module ALU_tb();
reg [31:0] ReadData1;
reg [31:0] ReadData2;
reg [31:0] imm32;
reg ALUSrc;
    //1'b0, the operand2 is ReadData2, 1'b1, imm32 
reg [1:0] ALUOp;
reg [2:0] funct3;
reg [6:0] funct7;
wire [31:0] ALUResult;
wire zero;
    //1'b1 while AULResult is zero
    
ALU ur(.ReadData1(ReadData1),
.ReadData2(ReadData2),
.imm32(imm32),
.ALUSrc(ALUSrc),
.ALUOp(ALUOp),
.funct3(funct3),
.funct7(funct7),
.ALUResult(ALUResult),
.zero(zero));    

initial begin
ReadData1=32'b0;
forever #10 ReadData1=ReadData1+5;
end
    
initial begin
ReadData2=32'b1;
forever #10 ReadData2=ReadData2+3;
end   

initial begin
imm32=32'b0;
forever #10 imm32=imm32+2;
end 

initial begin
ALUOp=2'b00;
repeat(2) begin
#10 ALUOp=ALUOp+1;
#10 ALUOp=ALUOp+1;
#40 ALUOp=ALUOp+1;
#10 ALUOp=ALUOp+1;
end
end

//initial begin
//{funct7, funct3}=10'b0000000_000;
//#10;
//{funct7, funct3}=10'b0100000_000;
//#10;
//{funct7, funct3}=10'b0000000_111;
//#10;
//{funct7, funct3}=10'b0000000_110;
//#10;
//end

initial begin
repeat(2) begin
{funct7, funct3}=10'b0000000_000;
#30 {funct7, funct3}<=10'b0100000_000;
#10 {funct7, funct3}<=10'b0000000_111;
#10 {funct7, funct3}<=10'b0000000_110;
#20;
end
end



initial begin
ALUSrc=0;
#70;
ALUSrc=1;
#70;
$finish;
end

endmodule