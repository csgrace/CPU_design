
module Instruction_fetch(
    input wire clk,         
    input wire rst, //低电平有效     
    input wire branch,  //1'b1 beq     
    input wire zero,  //1'b1 beq         
    input wire blt_if,
    input wire bltu_if,
    input wire jalr_if,
    input wire [31:0] ReadData1,
    input wire [31:0] imm32,  
    input wire [2:0] funct3,
    output wire [31:0] inst,
    output reg [31:0] pc_latch
    );
    
    reg [31:0] pc; 
    prgrom urom (
        .clka(clk),         
        .addra(pc[15:2]),   
        .douta(inst) 
    );
    
    always @(posedge clk or negedge rst) begin
        if (rst)
            pc_latch <= 32'h00000000;
        else
            pc_latch <= pc; // 锁存上一个周期的pc
    end
    
    always @(negedge clk or negedge rst) begin
        if (rst)                  
            pc <= 32'h0000_0000;
        else                        
            if (funct3==3'b0 && branch && zero)   //beq且二者相等      
                pc <= pc + (imm32 << 1); // 立即数左移 1 位  
//                pc <= pc + imm32 ; 
            else if(funct3==3'b100 && branch && blt_if)
                pc <= pc + (imm32 << 1); 
            else if(funct3==3'b110 && branch && bltu_if)
                pc <= pc + (imm32 << 1); 
            else if(jalr_if)
                pc <=  ReadData1;
                //pc <= (ReadData1 + imm32) & 32'hfffffffe;
            else                     
                pc <= pc + 4;        
    end
endmodule


