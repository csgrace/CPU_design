`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module show(
input wire clk, 
input wire rst_n, 
input wire know, 
input wire [31:0] inst, 
input wire how,
output reg [7:0] num, 
output reg [7:0] led, 
output reg [7:0] led1
);
reg [2:0] scan_cnt=0;
reg [3:0] hex_digits [7:0];
reg [15:0] clk_div = 0;
reg slow_clk = 0;

reg [3:0] tens = 4'b0;
reg [3:0] ones = 4'b0;
integer i;
reg [3:0] ten_digits [7:0];

wire [31:0] inst_abs = {24'b0, inst[7:0]}; 

always @(*) begin
for(i=0; i<10; i=i+1)begin
    if(inst_abs >= 10*i && inst_abs < 10*(i+1))begin
        tens <= i;
    end
end
end

always @(*) begin
ones = inst_abs - (10*tens);
end

always @(*) begin
    ten_digits[7] = inst[31:28];
    ten_digits[6] = 4'b0;
    ten_digits[5] = 4'b0;
    ten_digits[4] = 4'b0;
    ten_digits[3] = 4'b0;
    ten_digits[2] = 4'b0;
    ten_digits[1] = tens;
    ten_digits[0] = ones;
end

always @(posedge clk or negedge rst_n) begin
//always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        clk_div <= 0;
        slow_clk <= 0;
    end else begin
        //if (clk_div >= 50000) begin  // 100MHz / 50000 = 2kHz
        if (clk_div >= 11499) begin  // 23MHz / 11500 / 2 = 2kHz
            clk_div <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            clk_div <= clk_div + 1;
        end
    end
end


always @(posedge slow_clk or negedge rst_n) begin
//always @(posedge slow_clk or posedge rst_n) begin
    if (rst_n) begin
        scan_cnt <= 0;
    end else begin
        scan_cnt <= scan_cnt + 1;
        if (scan_cnt > 7) scan_cnt <= 0;
    end
end

always @(*) begin
if(rst_n || ~know)begin
//if(rst_n)begin
led=8'b0;
led1=8'b0;
num=8'b0;
end else begin
//if(know) begin
if(how==1'b0)begin
led = hex_to_seg(hex_digits[scan_cnt]);
led1 = hex_to_seg(hex_digits[scan_cnt]);
num = (8'b10000000 >> scan_cnt);
end else begin
led = hex_to_seg(ten_digits[scan_cnt]);
led1 = hex_to_seg(ten_digits[scan_cnt]);
num = (8'b10000000 >> scan_cnt);
end
//end
end
end

    
always @(*) begin
    hex_digits[7] = inst[31:28];
    hex_digits[6] = inst[27:24];
    hex_digits[5] = inst[23:20];
    hex_digits[4] = inst[19:16];
    hex_digits[3] = inst[15:12];
    hex_digits[2] = inst[11:8];
    hex_digits[1] = inst[7:4];
    hex_digits[0] = inst[3:0];
end

function [7:0] hex_to_seg(input [3:0] hex);
    case(hex)
        4'h0: hex_to_seg = 8'b00111111;
        4'h1: hex_to_seg = 8'b00000110;
        4'h2: hex_to_seg = 8'b01011011;
        4'h3: hex_to_seg = 8'b01001111;
        4'h4: hex_to_seg = 8'b01100110;
        4'h5: hex_to_seg = 8'b01101101;
        4'h6: hex_to_seg = 8'b01111101;
        4'h7: hex_to_seg = 8'b00000111;
        4'h8: hex_to_seg = 8'b01111111;
        4'h9: hex_to_seg = 8'b01101111;
        4'hA: hex_to_seg = 8'b01110111;
        4'hB: hex_to_seg = 8'b01111100;
        4'hC: hex_to_seg = 8'b00111001;
        4'hD: hex_to_seg = 8'b01011110;
        4'hE: hex_to_seg = 8'b01111001;
        4'hF: hex_to_seg = 8'b01110001;
        default: hex_to_seg = 8'b11111111;
    endcase
endfunction

endmodule