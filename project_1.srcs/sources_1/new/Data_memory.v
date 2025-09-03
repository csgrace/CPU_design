
module Data_memory(
   input wire clk,
   input wire MemRead, 
   input wire MemWrite, 
   input wire [31:0] Address, 
   input wire [31:0] Writedata,
   output wire [31:0] Readdata 
);

RAM udram(.clka(~clk),.wea(MemWrite),.addra(Address[13:0]),.dina(Writedata),.douta(Readdata));
//clk «∑Ò»°∑¥
endmodule
