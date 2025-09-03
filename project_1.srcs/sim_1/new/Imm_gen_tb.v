`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Imm_gen_tb();
    reg [31:0] instruction;
    wire [31:0] imm32;
    Imm_Gen u2 (
        .instruction(instruction),
        .imm32(imm32)
    );
    initial begin
        instruction = 32'b00000000001100010000000010110011; // R-type
        #10;      
        instruction = 32'b00000000000100001000000100010011; // I-type
        #10;
        instruction = 32'b00001100010100110010001000100011; // S-type
        #10;
        instruction = 32'b00000000011100110000010001100011; // B-type
        #10;        
        instruction = 32'b00000001000000000000000001101111; // J-type
        #10;        
        instruction = 32'b00010010001101000001000110110111; // U-type
        #10;   
        instruction = 32'b00000000000000000000000000000000; // Default
        #10;
        $finish;
    end
endmodule