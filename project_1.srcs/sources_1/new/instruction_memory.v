`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/10 17:36:32
// Design Name: 
// Module Name: instruction_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_memory(
    input wire [31:0] address,       
    output reg [31:0] instruction    
);
    // 定义指令存储器，假设有 256 条指令
    reg [31:0] memory [0:255];
    always @(*) begin
         instruction = memory[address[7:0]]; // 使用地址的低 8 位作为索引
    end
endmodule
