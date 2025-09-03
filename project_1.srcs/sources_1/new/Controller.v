module Controller(
input wire [31:0] inst,
input wire [23:0] Alu_resultHigh,
output wire [6:0] funct7,
output wire [2:0] funct3,
output wire [4:0] ReadRegister1,
output wire [4:0] ReadRegister2,
output wire [4:0] WriteRegister,
output wire Branch,//1'b1 当指令为 beq 时
output wire MemRead,//1'b1 while need to read from Data Memory(load),
//output wire MemtoReg, //1'b1 同时选择从 Data Memory 读取的数据到发送到 Registers
output wire MemWrite,//1'b1 时需要写入数据存储器（store）
output wire ALUSrc,//1'b1 同时选择 Immediate 作为 ALU 的作数，否则从 Registers中选择 read data2。
output wire RegWrite, //1'b1 时需要写入 Reisters，否则不写
output reg [1:0] ALUOp,//与ALU一起考虑。2'b00需加载或存储时，2'b01当指令是beq时，2'b10当指令是R型时，否则 2'b11
output wire MemorIOtoReg,//1'b1说明data需要从mmory/IO读到register
output wire IORead,//1说明IOread
output wire IOWrite,//1说明IOWrite
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
    
   assign Branch   = (opcode == 7'b1100011 || opcode == 7'b1101111); // B类型/jal
   assign MemRead  = (opcode == 7'b0000011); // lw
   //assign MemtoReg = (opcode == 7'b0000011); // lw
   assign MemWrite = ((opcode == 7'b0100011)&&(Alu_resultHigh != 24'hfffffc))?1'b1:1'b0;
   assign ALUSrc   = (opcode == 7'b0000011 || opcode == 7'b0100011 || opcode == 7'b0010011 
   || opcode == 7'b0110111 ); // lw/sw/addi等/lui/jal //|| opcode == 7'b1101111
   assign RegWrite = (opcode == 7'b0000011 || opcode == 7'b0110011 || opcode == 7'b0010011 
   || opcode == 7'b0000011 || opcode == 7'b0110111 || (opcode == 7'b1101111 && inst[11:7] != 5'b00000)); 
   // lw/R-type/I-type/lui/jal且不是x0
   //assign IORead = ((opcode == 7'b0000011) && (Alu_resultHigh[21:0] == 22'h3FFFFF)); // 访问 I/O 设备读取
   assign IORead = ((opcode === 7'b0000011) && (Alu_resultHigh === 24'hfffffc));
   //assign IOWrite = (opcode == 7'b0100011) && (Alu_resultHigh[21:0] == 22'h3FFFFF); // 访问 I/O 设备写入
   assign IOWrite = (opcode === 7'b0100011) && (Alu_resultHigh === 24'hfffffc);
   assign MemorIOtoReg = IORead || MemRead;
    always @(*) begin
          if (opcode == 7'b0110011 || opcode == 7'b0010011) begin
                 ALUOp = 2'b10; // R-type
          end else if (opcode == 7'b1100011 ) begin//|| opcode == 7'b1101111
                 ALUOp = 2'b01; // beq
          end else if (opcode == 7'b0000011 || opcode == 7'b0100011 || opcode == 7'b1101111) begin//|| opcode == 7'b1101111   || opcode == 7'b0010011
                 ALUOp = 2'b00; // lw/sw/addi等/jal
          end else begin
                 ALUOp = 2'b11; //lui
          end
    end
endmodule



