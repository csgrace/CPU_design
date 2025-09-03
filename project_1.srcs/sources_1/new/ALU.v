module ALU(
    input wire [31:0] ReadData1,
    input wire [31:0] ReadData2,
    input wire [31:0] imm32,
    input wire ALUSrc,
    //1'b0, the operand2 is ReadData2, 1'b1, imm32 
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [31:0] ALUResult,
//    input wire jump,
//    input wire pc,
    output wire zero,  //1'b1 while AULResult is zero
    output wire blt_if,
    output wire bltu_if
);
    wire [31:0] operand2;
    assign operand2 = (ALUSrc) ? imm32 : ReadData2;
    //如果 ALUSrc == 1，那么 operand2 = imm32
    reg [3:0] ALUControl;

        always @(*) begin
            case (ALUOp)
                2'b00: ALUControl = 4'b0010; // lw, sw (add)
                2'b01: ALUControl = 4'b0110; // beq (subtract)
                2'b10: begin // R-type instructions
                    case ({funct7, funct3})
                        10'b0000000_000: ALUControl = 4'b0010; // add
                        10'b0100000_000: ALUControl = 4'b0110; // sub
                        10'b0000000_111: ALUControl = 4'b0000; // and
                        10'b0000000_110: ALUControl = 4'b0001; // or
                        
                        10'b0000000_010: ALUControl = 4'b0111;//slt
                        10'b0000000_011: ALUControl = 4'b1110;//sltu
                        10'b0000000_001: ALUControl = 4'b1000;//sll
                        10'b0000000_101: ALUControl = 4'b1100;//srl
                        10'b0000000_100: ALUControl = 4'b0100; // xor //4
                        default: ALUControl = 4'b1111; // Invalid
                    endcase
                end
                default: ALUControl = 4'b1111; // Invalid
            endcase
        end
        
        integer i;
                reg bltu_if_wire;
                always @(*) begin
                    begin:loop
                    for (i = 31; i >= 0; i = i - 1) begin
                        if(ReadData1[i]==1'b0 && ReadData2[i]==1'b1) begin
                            bltu_if_wire=1'b1;
                            disable loop;
                        end else if(ReadData1[i]==1'b1 && ReadData2[i]==1'b0)begin
                            bltu_if_wire=1'b0;
                            disable loop;
                        end else begin
                            bltu_if_wire=1'b0;
                        end
                    end
                    end
                end
                assign bltu_if = bltu_if_wire;
        
        wire [31:0] temp = ReadData1 - operand2;
      
        always @(*) begin
            case (ALUControl)
                4'b0010: ALUResult = ReadData1 + operand2; // add
                4'b0110: ALUResult = ReadData1 - operand2; // sub
                4'b0000: ALUResult = ReadData1 & operand2; // and
                4'b0001: ALUResult = ReadData1 | operand2; // or
                4'b1111: ALUResult = {operand2[31:12], 12'b0}; // lui 
                4'b0111: ALUResult = {31'b0, temp[31]};//slt
                4'b1110: ALUResult = bltu_if_wire;
                4'b1000: ALUResult = ReadData1 << operand2;
                4'b1100: ALUResult = ReadData1 >> operand2;
                4'b0100: ALUResult = ReadData1 ^ operand2; //xor
                default: ALUResult = 32'b0; // Default case
            endcase
        end

        assign zero = (ALUResult == 32'b0);
        
//        reg blt_if_wire;
//        always @(*) begin
//            if (ReadData1[31]==1 && ReadData2[31]==1)begin
//                blt_if_wire = (ALUResult[31]==1'b1);
//            end else if (ReadData1[31]==1 && ReadData2[31]==0)begin
//                blt_if_wire = 1'b1;
//            end else if (ReadData1[31]==0 && ReadData2[31]==1)begin
//                blt_if_wire = 1'b0;
//            end else begin
//                blt_if_wire = (ALUResult[31]==1'b1);
//            end
//        end
//        assign blt_if=blt_if_wire;

        assign blt_if = (ALUResult[31]==1'b1);
        
        
endmodule