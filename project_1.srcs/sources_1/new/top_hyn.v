`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module top_hyn(input wire clk, input wire rst_n, 
input wire [2:0] choose, input wire sure, 
input [7:0] ab, output [7:0] led0, 
output [7:0] num, output [7:0] led, output [7:0] led1);

wire [31:0] inst_1;
wire [31:0] inst_2;
reg [31:0] inst_final;
reg know;
//reg [1:0] know_0;
reg [7:0] led0_reg;

initial begin
inst_final=32'b0;
know=0;
led0_reg=8'b0;
//know_0=2'b00;
end

always @(*) begin
if(choose==3'b001) begin
    if(sure==1) begin
        know=1;
        inst_final=inst_1;
    end
end else if(choose==3'b010) begin
    if(sure==1) begin
        know=1;
        inst_final=inst_2;
    end 
end else begin
    know=0;
end
end

always @(*) begin
if(choose==3'b000) begin
    if(sure==1)begin
        led0_reg=ab;
        //know_0=know_0+1;
    end
end else begin
    led0_reg=8'b0;
end
end

assign led0=led0_reg;
lba ur1(.a(ab),.inst(inst_1));
lbub ur2(.b(ab),.inst(inst_2));
show ur(.clk(clk),.rst_n(rst_n),.know(know),.inst(inst_final),.num(num),.led(led),.led1(led1));
endmodule
