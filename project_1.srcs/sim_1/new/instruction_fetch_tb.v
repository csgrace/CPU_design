module instruction_fetch_tb();
reg clk;
reg rst; //低电平有效     
reg branch;  //1'b1 beq     
reg zero;  //1'b1 beq         
reg signed [31:0] imm32;  
wire [31:0] inst;

Instruction_fetch ur(
.clk(clk),         
.rst(rst), //低电平有效     
.branch(branch),  //1'b1 beq     
.zero(zero),  //1'b1 beq         
.imm32(imm32),  
.inst(inst));

initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end

initial begin
    rst=1'b1;
    #5 rst=1'b0;
end

initial begin
imm32=32'b0;
#60 imm32=32'hffff_ffec;
#10 imm32=32'b0;
end 

initial begin
    branch=1'b0;
    zero=1'b0;
    #10;
    branch=1'b1;
    zero=1'b0;
    #10;
    branch=1'b0;
    zero=1'b1;
    #40;
    branch=1'b1;
    zero=1'b1;
    #10;
    branch=1'b0;
    zero=1'b0;
    #10;
    $finish;
end

endmodule