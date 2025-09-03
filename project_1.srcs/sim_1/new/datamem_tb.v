module datamem_tb();
reg clk;
reg MemRead;
reg MemWrite;
reg [31:0] Address;
reg [31:0] Writedata;
wire [31:0] Readdata;

Data_memory ur(
.clk(clk),
.MemRead(MemRead), 
.MemWrite(MemWrite), 
.Address(Address), 
.Writedata(Writedata),
.Readdata(Readdata));

initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end

initial begin
MemWrite=1'b0;
MemRead=1'b1;
#75 MemWrite=1'b1;
end

initial begin
Writedata=32'h0;
#75 repeat(10) #12 Writedata=Writedata+16;
end

initial begin
Address=32'b0;
repeat(20) #12 Address=Address+4;
#20 $finish;
end

endmodule