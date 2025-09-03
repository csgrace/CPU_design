`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module cpu_tb();
reg clk, rst;
reg sure_btn1; 
reg [7:0] switches,leds; 
wire sure_lt;
Main umain(.clk(clk),.rst(rst),.sure_btn1(sure_btn1),.switches(switches),.leds(leds),.sure_lt(sure_lt));
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial begin
    rst = 1'b0;
    #20 rst = 1'b1;
    #180 
    $finish;
end
endmodule
