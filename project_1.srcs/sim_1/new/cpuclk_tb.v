
module cpuclk_tb( );
    reg clkin;
    wire clkout;
    cpuclk clk1(.clk_in1(clkin),.clk_out1(clkout));
    
    initial
        clkin = 1'b0;
    always
        #5 clkin = ~clkin;
        
endmodule
