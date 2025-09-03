`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input ledrst,		// reset, active high (��λ�ź�,�ߵ�ƽ��Ч)
    input led_clk,	// clk for led (ʱ���ź�)
    input ledwrite,	// led write enable, active high (д�ź�,�ߵ�ƽ��Ч)
    input ledcs,		// 1 means the leds are selected as output (��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�)
    input [3:0] ledaddr,	// 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input [31:0] ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output reg [15:0] ledout,		// the data writen to the leds  of the board
    output reg [31:0] ledwdata_sext,
    output reg sext_on
);
  
    //reg [23:0] ledout;
    
    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout <= 16'h000000;
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else if (ledcs && ledwrite) begin
			if (ledaddr == 4'b0000) begin
				ledout={ledwdata[7:0], 8'b0};
				ledwdata_sext = 32'b0;
				sext_on = 0;
			end else if (ledaddr == 4'b0100 || ledaddr == 4'b1000) begin
			    sext_on = 1;
				ledwdata_sext = ledwdata;
				ledout = 16'b0;
			end else begin
			    sext_on<=sext_on;
				ledout <= ledout;
				ledwdata_sext <= ledwdata_sext;
		    end
        end else begin
            sext_on<=sext_on;
            ledout <= ledout;
            ledwdata_sext <= ledwdata_sext;
        end
    end

endmodule
