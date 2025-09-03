module button_is_pressed(
    input clk,        
    input btn_in,     
    output reg btn_out  
);
    //Ïû¶¶
    reg btn_state_prev;       
    parameter p=1000_000;
    reg button_state;
    reg button_state_last;
    reg[29:0] cnt;
    always @(posedge clk) begin
        if(btn_in==1) begin
            if(cnt==p-1) begin
                button_state<=1; 
                cnt<=0;
            end
            else cnt<=cnt+1;
        end
        else begin
            cnt<=0;
            button_state<=0;
        end
        if(button_state==1&&button_state_last==0) begin
            btn_out<=1;
        end
        else btn_out<=0;
        
        button_state_last<=button_state;
   end
endmodule



/*module button_is_pressed(input btn,clk,rst,output reg pressed);//tell u whther it is pressed
parameter period =1000000;//1000000
reg stable;
reg stable_d;
reg[1:0] sig;
reg[31:0] cnt;


always @(posedge clk,negedge rst) begin
  if(~rst)
    pressed<=0;
  else
  pressed<=(stable&~stable_d);
end
// assign pressed=stable&~stable_d;

always @(posedge clk,negedge rst) begin
  if(~rst)
    sig<=2'b00;
  else
    sig[0]<=btn;
    sig[1]<=sig[0];
end

always @(posedge clk,negedge rst) begin
  if(~rst)begin
    cnt<=0;
    stable<=1'b0;
  end
  else begin
    if(stable!=sig[1]) begin
      cnt<=cnt+1;
      if(cnt>=period)begin
        stable<=sig[1];
        cnt<=0;
      end
    end
    else begin
      cnt<=0;
    end
  end
end

always @(posedge clk,negedge rst) begin
  if(~rst)
    stable_d<=2'b0;
  else
    stable_d<=stable;
end
endmodule*/
