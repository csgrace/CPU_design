module Controller(
input wire [31:0] inst,
input wire [23:0] Alu_resultHigh,
output wire [6:0] funct7,
output wire [2:0] funct3,
output wire [4:0] ReadRegister1,
output wire [4:0] ReadRegister2,
output wire [4:0] WriteRegister,
output wire Branch,//1'b1 ��ָ��Ϊ beq ʱ
output wire MemRead,//1'b1 while need to read from Data Memory(load),
//output wire MemtoReg, //1'b1 ͬʱѡ��� Data Memory ��ȡ�����ݵ����͵� Registers
output wire MemWrite,//1'b1 ʱ��Ҫд�����ݴ洢����store��
output wire ALUSrc,//1'b1 ͬʱѡ�� Immediate ��Ϊ ALU ������������� Registers��ѡ�� read data2��
output wire RegWrite, //1'b1 ʱ��Ҫд�� Reisters������д
output reg [1:0] ALUOp,//��ALUһ���ǡ�2'b00����ػ�洢ʱ��2'b01��ָ����beqʱ��2'b10��ָ����R��ʱ������ 2'b11
output wire MemorIOtoReg,//1'b1˵��data��Ҫ��mmory/IO����register
output wire IORead,//1˵��IOread
output wire IOWrite,//1˵��IOWrite
output wire jump,//jal
output wire jalr_if //jalr
);
    
//    assign ReadRegister1 = inst[19:15];
//    assign ReadRegister2 = inst[24:20];
       
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    assign jump = (opcode == 7'b1101111); //jal
    assign jalr_if = (opcode == 7'b1100111); //jalr
    assign funct7 = (opcode == 7'b0110011) ? inst[31:25]:7'b0;
    assign funct3 = (opcode == 7'b0110111 || opcode == 7'b1101111) ? 3'b0:inst[14:12];
    assign WriteRegister = (opcode == 7'b0100011 || opcode == 7'b1100011) ? 5'b0:inst[11:7];  
   assign ReadRegister1 = (opcode==7'b0110111 || opcode==7'b1101111) ? 5'b0:inst[19:15];
   assign ReadRegister2 = (opcode==7'b0110011 || opcode==7'b0100011 || opcode==7'b1100011) ? inst[24:20]:5'b0;
    
   assign Branch   = (opcode == 7'b1100011 || opcode == 7'b1101111); // B����/jal
   assign MemRead  = (opcode == 7'b0000011); // lw
   //assign MemtoReg = (opcode == 7'b0000011); // lw
   assign MemWrite = ((opcode == 7'b0100011)&&(Alu_resultHigh != 24'hfffffc))?1'b1:1'b0;
   assign ALUSrc   = (opcode == 7'b0000011 || opcode == 7'b0100011 || opcode == 7'b0010011 
   || opcode == 7'b0110111 ); // lw/sw/addi��/lui/jal //|| opcode == 7'b1101111
   assign RegWrite = (opcode == 7'b0000011 || opcode == 7'b0110011 || opcode == 7'b0010011 
   || opcode == 7'b0000011 || opcode == 7'b0110111 || (opcode == 7'b1101111 && inst[11:7] != 5'b00000)); 
   // lw/R-type/I-type/lui/jal�Ҳ���x0
   //assign IORead = ((opcode == 7'b0000011) && (Alu_resultHigh[21:0] == 22'h3FFFFF)); // ���� I/O �豸��ȡ
   assign IORead = ((opcode === 7'b0000011) && (Alu_resultHigh === 24'hfffffc));
   //assign IOWrite = (opcode == 7'b0100011) && (Alu_resultHigh[21:0] == 22'h3FFFFF); // ���� I/O �豸д��
   assign IOWrite = (opcode === 7'b0100011) && (Alu_resultHigh === 24'hfffffc);
   assign MemorIOtoReg = IORead || MemRead;
    always @(*) begin
          if (opcode == 7'b0110011 || opcode == 7'b0010011) begin
                 ALUOp = 2'b10; // R-type
          end else if (opcode == 7'b1100011 ) begin//|| opcode == 7'b1101111
                 ALUOp = 2'b01; // beq
          end else if (opcode == 7'b0000011 || opcode == 7'b0100011 || opcode == 7'b1101111) begin//|| opcode == 7'b1101111   || opcode == 7'b0010011
                 ALUOp = 2'b00; // lw/sw/addi��/jal
          end else begin
                 ALUOp = 2'b11; //lui
          end
    end
endmodule



