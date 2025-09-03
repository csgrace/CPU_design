
module Main(
    input clk,
    input rst,
    input sure_btn1, // 确认按钮
    input [15:0] switches, // 八个拨码开关输入
    
//   output wire zero,
//    output wire [31:0] instruction,
//    output wire [31:0] ALUResult,
//    output wire [31:0] imm32,
//    output wire [31:0] ReadData1,
//   output wire [31:0] ReadData2,
//    output wire RegWrite,
//    output wire Branch,
//    output wire MemRead,
//    output wire MemorIOtoReg,
//    output wire MemWrite,
//    output wire ALUSrc,
//    output wire [31:0] r_wdata,
//    output wire [1:0] ALUOp,
//    output wire IORead,
//    output wire IOWrite,
//    output wire [31:0] WriteData, Readdata,
//    output wire [31:0] addr_out,
//    output wire [4:0] ReadRegister1,  // rs1
//    output wire [4:0] ReadRegister2,  // rs2
//    output wire [4:0] WriteRegister,   // rd 
//    output wire [31:0] pc_latch,
//    output wire jump,
//    output wire jalr_if,
//    output wire sure_btn1_pressed,
    
    output [15:0] leds, // 八个灯的输出
    output [7:0] num,
    output [7:0] led, 
    output [7:0] led1
    
);
    wire cpu_clk;        // 由时钟生成器生成的 23MHz 时钟信号
    cpuclk u_clk (
        .clk_in1(clk),   
        .clk_out1(cpu_clk) 
    );
    
    //Controller中的端口

    wire blt_if;
    wire bltu_if;
    wire zero;
    wire [31:0] instruction;
    wire [31:0] ALUResult;
    wire [31:0] imm32;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire RegWrite;
    wire Branch;
    wire MemRead;
    wire MemorIOtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire [31:0] r_wdata;
    wire [1:0] ALUOp;
    wire IORead;
    wire IOWrite;
    wire [31:0] WriteData; 
    wire [31:0] Readdata;
    wire [31:0] addr_out;
    wire [4:0] ReadRegister1;  // rs1
    wire [4:0] ReadRegister2;  // rs2
    wire [4:0] WriteRegister;   // rd
    wire [31:0] pc_latch;
    wire jump;
    wire jalr_if;
    wire sure_btn1_pressed;
    
   button_is_pressed u_btn (
//        .clk(clk),  
         .clk(cpu_clk),      
         .btn_in(sure_btn1),     
         .btn_out(sure_btn1_pressed)   
     );
     
//     assign sure_btn1_pressed = 1'b1;
    reg sure_lt;
//    always @(posedge clk or negedge rst) begin
//        if (rst)
//            sure_lt <= 0;
//        else if (sure_btn1_pressed)
//            sure_lt <= ~sure_lt;
//    end
    always @(*) begin
        sure_lt = sure_btn1; //可以实现逻辑，不过和去抖没有关系了
    end
    
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    Instruction_fetch ufetch (
           .clk(cpu_clk),
//            .clk(clk),
            .rst(rst),
            .branch(Branch),
            .zero(zero),
            .blt_if(blt_if),
            .bltu_if(bltu_if),
            .jalr_if(jalr_if),
            .ReadData1(ReadData1),
            .imm32(imm32),
            .funct3(funct3),
            .inst(instruction),
            .pc_latch(pc_latch)
    );

//    wire Alu_resultHigh = ALUResult[31:10];

    Controller ucon (
            .inst(instruction),
            .Alu_resultHigh(ALUResult[31:8]),
            .funct7(funct7),
            .funct3(funct3),
            .ReadRegister1(ReadRegister1),
            .ReadRegister2(ReadRegister2),
            .WriteRegister(WriteRegister),
            .Branch(Branch),
            .MemRead(MemRead),
            //.MemtoReg(MemtoReg),
            .MemWrite(MemWrite),
            .ALUSrc(ALUSrc),
            .RegWrite(RegWrite),
            .ALUOp(ALUOp),
            .MemorIOtoReg(MemorIOtoReg),
            .IORead(IORead),
            .IOWrite(IOWrite),
            .jump(jump),
            .jalr_if(jalr_if)
   );    
//     wire [4:0] ReadRegister1 = instruction[19:15];  // rs1
//    wire [4:0] ReadRegister2 = instruction[24:20];  // rs2
//     wire [4:0] WriteRegister = instruction[11:7];   // rd 
//    assign ReadRegister1 = instruction[19:15];
//    assign ReadRegister2 = instruction[24:20];
//    assign WriteRegister = instruction[11:7];  
//wire [31:0] WriteData_internal;


     Registers ureg (
         .clk(cpu_clk),
//         .clk(clk),
         .rst(rst),
         .jump(jump),
         .pc(pc_latch),
         .RegWrite(RegWrite),
         .ReadRegister1(ReadRegister1),
         .ReadRegister2(ReadRegister2),
         .WriteRegister(WriteRegister),
         .ALUResult(ALUResult),
         .Readdata(WriteData),//修改前r_wdata  WriteData
         .MemtoReg(MemorIOtoReg),
         .ReadData1(ReadData1),
         .ReadData2(ReadData2)
     );  
    Imm_Gen uimm (
        .instruction(instruction), 
        .imm32(imm32)   //给到ALU          
    );
    ALU uALU (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),  //来自Imm_Gen
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUResult(ALUResult),
//        .jump(jump),
//        .pc(pc),
        .zero(zero),
        .blt_if(blt_if),
        .bltu_if(bltu_if)
    );
   Data_memory udatamem (
//        .clk(clk),
        .clk(cpu_clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(addr_out),   // 来自MemOrIO的结果
        //.Writedata(ReadData2), //rs2寄存器的值
        .Writedata(WriteData),//从MemOrIO接出来
        .Readdata(Readdata)  // 数据存储器的输出
   ); 

   MemOrIO uMemOrIO (
//        .clk1(clk),
        .clk1(cpu_clk),
        .rst(rst),
        .mRead(MemRead),
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .funct3(funct3),
        .addr_in(ALUResult),// from alu_result in ALU
        .addr_out(addr_out),// address to Data-Memory
        .m_rdata(Readdata),// data read from Data-Memory
        .io_rdata(switches),// data read from IO,16 bits
        .r_wdata(r_wdata),// data to Decoder(register file)
        .r_rdata(ReadData2), // data read from Decoder(register file)
        .write_data(WriteData), // data to memory or I/O（m_wdata, io_wdata）
        .LEDCtrl(),// LED Chip Select
        .SwitchCtrl(), // Switch Chip Select  
        .ledout(leds),
        //.sure_btn_pressed (sure_btn1_pressed)
        .sure_lt (sure_lt),
        .num(num),
        .led(led), 
        .led1(led1)
   );

endmodule
