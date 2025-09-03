`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/10 16:39:48
// Design Name: 
// Module Name: MUX
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


module MUX(
    input wire [31:0] input1,  
    input wire [31:0] input2,  
    input wire select,      
    output reg [31:0] mux_out 
    );

    always @(*) begin
          if (select) begin
              mux_out = input2;
          end else begin
              mux_out = input1;
          end
    end
endmodule
