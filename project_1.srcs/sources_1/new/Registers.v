`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Registers (
    input wire clk,
    input wire rst,
    input wire RegWrite, //来自Controller
    input wire [4:0] ReadRegister1, 
    input wire [4:0] ReadRegister2, 
    input wire [4:0] WriteRegister, 
    input wire [31:0] pc,
    input wire jump,
    input wire [31:0] ALUResult,
    input wire [31:0] Readdata, 
    input wire MemtoReg, 
    output wire [31:0] ReadData1, //给到ALU
    output wire [31:0] ReadData2  //给到ALU
);

    reg [31:0] register_file [31:0]; // 32个32位寄存器
    wire [31:0] WriteData;
     MUX umux2 (
         .input1(ALUResult),
         .input2(Readdata),
         .select(MemtoReg),
         .mux_out(WriteData)
     );
     
       integer i;
       always @(posedge clk or negedge rst) begin
           if (rst) begin
                   for (i = 0; i < 32; i = i + 1) begin
                       register_file[i] <= 32'h00000000; // 初始化为0
                   end
           end 
           else if (RegWrite && WriteRegister != 5'b00000) begin
                if (jump)
                    register_file[WriteRegister] <= pc + 4;
                else         
                    register_file[WriteRegister] <= WriteData;
           end
       end    
//       always @* begin
//             if (RegWrite && WriteRegister != 5'b00000) begin
//                       register_file[WriteRegister] <= WriteData;
//             end
//       end
       
       
       
//        always @(posedge clk or negedge rst) begin
//                 if (rst) begin
//                         ReadData1 <= 0;
//                         ReadData2 <= 0;
//                 end 
//                 else begin
//                      ReadData1 <= register_file[ReadRegister1];
//                      ReadData2 <= register_file[ReadRegister2];
//                 end
//       end    
       assign ReadData1 = register_file[ReadRegister1];
       assign ReadData2 = register_file[ReadRegister2];

endmodule
