`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module controller_tb();
    reg [31:0] inst;
    reg [21:0] Alu_resultHigh;

    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemorIOtoReg;
    wire IORead;
    wire IOWrite;

    Controller uut (
        .inst(inst),
        .Alu_resultHigh(Alu_resultHigh),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemorIOtoReg(MemorIOtoReg),
        .IORead(IORead),
        .IOWrite(IOWrite)
    );

    initial begin
        Alu_resultHigh = 22'h0;
        // Test R-type: add x1,x2,x3
        inst = 32'b00000000001100010000000010110011;
        #10;
        // Test I-type: addi x2,x1,1
        inst = 32'b00000000000100001000000100010011;
        #10;
        // Test S-type: sw x5,100(x6)
        inst = 32'b00001100010100110010001000100011;
        Alu_resultHigh = 22'h0;
        #10;
        // Test B-type: beq x6,x7,8
        inst = 32'b00000000011100110000010001100011;
        #10;
        // Test J-type: jal x0, 16
        inst = 32'b00000001000000000000000001101111;
        #10;
        // Test U-type: lui x3, 0x12345
        inst = 32'b00010010001101000001000110110111;
        #10;
        // Test IORead: lw  000000001000 11111  010  00001  0000011
        inst = 32'b00000000100011111010000010000011; // lw x1,8(x31)
        Alu_resultHigh = 22'h3FFFFF;
        #10;
        // Test IOWrite: sw 000011  000101  00110  010  00100  0100011
        inst = 32'b00001100010100110010001000100011; // sw x5,100(x6)
        Alu_resultHigh = 22'h3FFFFF;
        #10;
        $finish;
    end

endmodule

