`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//3'b001 lb,x1,a
module lba(input [7:0] a, output [31:0] inst);
assign inst = {4'b0000, a, 20'h00083};
endmodule
