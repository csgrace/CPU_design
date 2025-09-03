`timescale 1ns/1ps
module Top_tb;
    reg clk;
    reg rst;
    reg sure_btn1;
    reg x0, x1, x2;
    reg sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7;
    reg scene1_btn, scene2_btn;

    wire scene1_lt, scene2_lt;
    wire lt0, lt1, lt2, lt3, lt4, lt5, lt6, lt7;
    wire light;
    wire sure_lt;

    TOP uut (
        .clk(clk),
        .rst(rst),
        .sure_btn1(sure_btn1),
        .x0(x0), .x1(x1), .x2(x2),
        .sw0(sw0), .sw1(sw1), .sw2(sw2), .sw3(sw3),
        .sw4(sw4), .sw5(sw5), .sw6(sw6), .sw7(sw7),
        .scene1_btn(scene1_btn),
        .scene2_btn(scene2_btn),
        .scene1_lt(scene1_lt),
        .scene2_lt(scene2_lt),
        .lt0(lt0), .lt1(lt1), .lt2(lt2), .lt3(lt3),
        .lt4(lt4), .lt5(lt5), .lt6(lt6), .lt7(lt7),
        .light(light),
        .sure_lt(sure_lt)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    initial begin
        $monitor("Time=%0t, rst=%b, scene1_btn=%b, scene1_btn_pressed=%b, scene1_lt=%b",
                 $time, rst, scene1_btn, uut.scene1_btn_pressed, scene1_lt);
    end
    // Test sequence
    initial begin
        rst = 1; 
        sure_btn1 = 0;
        x0 = 0; x1 = 0; x2 = 0;
        sw0 = 0; sw1 = 0; sw2 = 0; sw3 = 0;
        sw4 = 0; sw5 = 0; sw6 = 0; sw7 = 0;
        scene1_btn = 0;
        scene2_btn = 0;

        // Reset deassertion
        #20;
        rst = 0; 

        // Simulate scene1_btn press with sufficient duration
        #400;
        scene1_btn = 1;  // Button press
        #500;            // Hold for 100ns to simulate debounce
        scene1_btn = 0;  // Button release
        
        // Simulate scene2_btn press
        #400;                                 
        scene2_btn = 1; 
        #500;            // Hold for 100ns to simulate debounce
        scene2_btn = 0; 
        
        #400; 
        
        $finish;
    end

endmodule