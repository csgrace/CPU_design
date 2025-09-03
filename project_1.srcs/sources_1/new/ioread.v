`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (
    input			reset,				// reset, active high ��λ�ź� (�ߵ�ƽ��Ч)
	input			ior,				// from Controller, 1 means read from input device(�ӿ���������I/O��)
    input			switchctrl,			// means the switch is selected as input device (��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ)
    input	[15:0]	ioread_data_switch,	// the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
    input   [31:0]  addr_in, 
    input [2:0] funct3,
    input sure_lt,
    output	reg [31:0]	ioread_data 		// the data to memorio (���������������͸�memorio)
);

    //reg [15:0] ioread_data;
    
    always @* begin
        if (reset)
            ioread_data = 32'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                if(addr_in[4:0]==5'b10000) begin
                    if(funct3==3'b100 || funct3==3'b010)
                        ioread_data = {24'h0, ioread_data_switch[15:8]}; // ��8λ
                    else 
                        ioread_data = {{24{ioread_data_switch[15]}}, ioread_data_switch[15:8]}; 
                end else if(addr_in[4:0]==5'b10100)               
                    ioread_data = {29'b0, ioread_data_switch[7:5]}; // ��11~9λ
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
