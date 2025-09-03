module TOP(
    input wire clk,rst,
    input wire sure_btn1,
    input wire x0,x1,x2,
    input wire sw0,sw1,sw2,sw3,sw4,sw5,sw6,sw7,
    input wire scene1_btn,scene2_btn,
    output reg scene1_lt = 0,scene2_lt = 0,
    output reg lt0,lt1,lt2,lt3,lt4,lt5,lt6,lt7,
    output reg light,
    output reg sure_lt
);
    wire sure_btn1_pressed;
    wire scene1_btn_pressed;
    wire scene2_btn_pressed;

    always @(posedge clk or negedge rst) begin
    if (rst)
        scene1_lt <= 0;
    else if (scene1_btn_pressed)
        scene1_lt <= ~scene1_lt;
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst)
            scene2_lt <= 0;
        else if (scene2_btn_pressed)
            scene2_lt <= ~scene2_lt;
    end

    
//    always @(*) begin
//            lt0 = sw0;
//            lt1 = sw1;
//            lt2 = sw2;
//            lt3 = sw3;
//            lt4 = sw4;
//            lt5 = sw5;
//            lt6 = sw6;
//            lt7 = sw7;
//            sure_lt = sure_btn1;        
//    end
    
    always @(*) begin
        {lt7, lt6, lt5, lt4, lt3, lt2, lt1, lt0} = 16'h07;
    end
    
//    button_is_pressed b1(.btn(sure_btn1),.clk(clk),.rst(rst),.pressed(sure_btn1_pressed));
//    button_is_pressed b2(.btn(scene1_btn),.clk(clk),.rst(rst),.pressed(scene1_btn_pressed));
//    button_is_pressed b3(.btn(scene2_btn),.clk(clk),.rst(rst),.pressed(scene2_btn_pressed));
    
     button_is_pressed b1(.clk(clk),.btn_in(sure_btn1),.btn_out(sure_btn1_pressed));
     button_is_pressed b2(.clk(clk),.btn_in(scene1_btn),.btn_out(scene1_btn_pressed));
     button_is_pressed b3(.clk(clk),.btn_in(scene2_btn),.btn_out(scene2_btn_pressed));
       
    /*Main umain (
        .clk(clk),
        .rst(rst)
    );*/
endmodule
