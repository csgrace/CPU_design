
module MemOrIO(clk1,rst,mRead, mWrite, ioRead, ioWrite, funct3, addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl,ledout,sure_lt,num,led,led1);
input clk1,rst;
input mRead; // read memory, from Controller
input mWrite; // write memory, from Controller
input ioRead; // read IO, from Controller
input ioWrite; // write IO, from Controller
input [2:0] funct3;

input[31:0] addr_in; // from alu_result in ALU
output [31:0] addr_out; // address to Data-Memory

input[31:0] m_rdata; // data read from Data-Memory
input wire [15:0] io_rdata; // data read from IO,16 bits
output [31:0] r_wdata; // data to Decoder(register file)

input [31:0] r_rdata; // data read from Decoder(register file)
output reg [31:0] write_data; // data to memory or I/O（m_wdata, io_wdata）
output LEDCtrl; // LED Chip Select
output SwitchCtrl; // Switch Chip Select
output [15:0] ledout;
input sure_lt; 

output [7:0] num;
output [7:0] led;
output [7:0] led1;

assign addr_out = addr_in;

// While the data is from io, it should be the lower 16bit of r_wdata.
/*assign r_wdata = mRead ? m_rdata : 
                 (ioRead && sure_btn_pressed) ? {16'h0000, io_rdata} : 
                 32'h00000000;*/
assign r_wdata = ioRead ? {16'h0000, io_rdata} :
                 mRead ? m_rdata :
                 32'h00000000;
//判断当前访问地址是内存还是I/O设备。
//将数据从内存或I/O设备传递到寄存器文件。
//根据控制信号，将写入数据传递到内存或I/O设备。

// Chip select signal of Led and Switch are all active high;
//assign LEDCtrl = (addr_in == 32'hFFFFFC60  || addr_in == 32'hFFFFFC62); // 0XFFFFFC60，0XFFFFFC62
//assign SwitchCtrl = (addr_in == 32'hFFFFFC70 || addr_in == 32'hFFFFFC72); // 0XFFFFFC70，0XFFFFFC72

assign LEDCtrl = (addr_in == 32'hFFFFFC60 || addr_in == 32'hFFFFFC64 || addr_in == 32'hFFFFFC68);
assign SwitchCtrl = ((addr_in == 32'hFFFFFC70 || addr_in == 32'hFFFFFC74 || addr_in == 32'hFFFFFC78 || addr_in == 32'hFFFFFC7C || addr_in == 32'hFFFFFC80) && ((mWrite==0)&&(ioWrite==0))) ;

wire [31:0] write_data_io;

wire switch_read = ioRead && sure_lt;

   ioread uIoread (
    .reset(rst),                   // 复位信号（此处假设默认无复位）
    .ior(switch_read),                   // 读I/O信号
    .switchctrl(SwitchCtrl),        // 拨码开关片选信号
    .ioread_data_switch(io_rdata), // 拨码开关数据
    .addr_in(addr_in),
    .funct3(funct3),
    .sure_lt(sure_lt),
    .ioread_data(write_data_io)          // 输出的I/O读取数据
);

always @* begin
    if (mWrite || ioWrite)
        write_data = r_rdata;
    else if(SwitchCtrl)
        write_data = write_data_io;
    else
        write_data = m_rdata;  //32'heeeeeee
end


wire led_write = ioWrite && sure_lt;
wire [31:0] ledwdata_sext;
wire sext_on;

leds uLeds (
    .ledrst(rst),                 
    .led_clk(clk1),               
    .ledwrite(led_write),             // 写LED信号
    .ledcs(LEDCtrl),                // LED片选信号
    .ledaddr(addr_in[3:0]),         // LED地址（低2位） //感觉这个模块里面没有用到这个端口
    .ledwdata(write_data),    // 写入LED的数据（低16位）
    .ledout(ledout),     // LED输出状态
    .ledwdata_sext(ledwdata_sext),
    .sext_on(sext_on)         
//    .num(num),
//    .led(led),
//    .led1(led1)
);

//reg [31:0] display_data;
//always @(posedge clk1 or posedge rst) begin
//    if(rst) begin
//        display_data <= 32'h0;
//    end else if(led_write) begin
//        display_data <= write_data;
//    end
//end

//reg [31:0] display_data;
//always @(*) begin
//        display_data <= 32'h0123456;
//end

reg show_enable;
reg sure_lt_last;
always @(posedge clk1 or posedge rst) begin
    if (rst) begin
        show_enable <= 1'b0;
        sure_lt_last <= 1'b0;
    end else begin
        sure_lt_last <= sure_lt;
        if (~sure_lt_last && sure_lt)
            show_enable <= 1'b1;
    end
end

wire [7:0] num_show;
wire how = ({io_rdata[7:5],io_rdata[0]}==4'b0101 || {io_rdata[7:5],io_rdata[0]}==4'b0111) ? 1'b1:1'b0;

show ur(
    .clk(clk1),
    .rst_n(rst),
    .know(show_enable),
//    .inst(32'h01234566),
    .inst(ledwdata_sext),
    .how(how),
    .num(num_show),
    .led(led),
    .led1(led1)
);

assign num = (sext_on) ? num_show:8'b0;

endmodule