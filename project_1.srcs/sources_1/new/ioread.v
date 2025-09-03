`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (
    input			reset,				// reset, active high 复位信号 (高电平有效)
	input			ior,				// from Controller, 1 means read from input device(从控制器来的I/O读)
    input			switchctrl,			// means the switch is selected as input device (从memorio经过地址高端线获得的拨码开关模块片选)
    input	[15:0]	ioread_data_switch,	// the data from switch(从外设来的读数据，此处来自拨码开关)
    input   [31:0]  addr_in, 
    input [2:0] funct3,
    input sure_lt,
    output	reg [31:0]	ioread_data 		// the data to memorio (将外设来的数据送给memorio)
);

    //reg [15:0] ioread_data;
    
    always @* begin
        if (reset)
            ioread_data = 32'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                if(addr_in[4:0]==5'b10000) begin
                    if(funct3==3'b100 || funct3==3'b010)
                        ioread_data = {24'h0, ioread_data_switch[15:8]}; // 高8位
                    else 
                        ioread_data = {{24{ioread_data_switch[15]}}, ioread_data_switch[15:8]}; 
                end else if(addr_in[4:0]==5'b10100)               
                    ioread_data = {29'b0, ioread_data_switch[7:5]}; // 第11~9位
                else if(addr_in[4:0]==5'b11000)
                    ioread_data = {31'b0, ioread_data_switch[0]};
                else if(addr_in[4:0]==5'b11100)
                    ioread_data = {31'b0, sure_lt};  
                else if(addr_in[4:0]==5'b00000)
                    ioread_data = {31'b0, ioread_data_switch[1]};  
                else
                    ioread_data = 32'h0;
            else
				ioread_data = 32'h0;
        end
    end
	
endmodule
