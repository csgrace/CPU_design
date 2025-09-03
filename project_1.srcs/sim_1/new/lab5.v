module lab5();
reg [31:0] instruction;
wire [31:0] imm;

computer_organization_lab5_practice1 ur(.instruction(instruction), .imm(imm));

initial begin
instruction = 32'b0000000_00010_00001_000_00011_0110011;
#10;
instruction = 32'b100000000101_00001_000_00010_0010011;
#10;
instruction = 32'b0000000_00010_00001_000_00011_0100011;
#10;
instruction = 32'b0_000000_00010_00001_000_0001_1_1100011;
#10;
instruction = 32'b00000000000000000001_00001_0110111;
#10; 
instruction = 32'b0_0000000000_0_00000010_00001_1101111;
#10; 
end

initial begin
#60;
$finish;
end

endmodule