`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////

module Imm_Gen(
    input wire [31:0] instruction,   
    output reg [31:0] imm32   
    );
    wire [6:0] opcode = instruction[6:0];
    always @(*) begin
    case(opcode)
        7'b0110011: //R_type
            imm32 = 32'b0;
        7'b0010011,7'b0000011,7'b1100111,7'b1110011: //I_type
            imm32 = {{20{instruction[31]}}, instruction[31:20]};           
        7'b0100011: //S_type
            imm32 = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        7'b1100011: //B_type
            imm32 = {{21{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8]};
        7'b0110111,7'b0010111: //U_type
            imm32 = {instruction[31:12], 12'b0};
        7'b1101111: //J_type
            imm32 = {{13{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]};//改成不补全0，在ifetch里面左移
        default:
            imm32 = 32'b0;
    endcase
    end
endmodule
