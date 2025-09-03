set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN R17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property IOSTANDARD LVCMOS33 [get_ports sure_btn1]
set_property PACKAGE_PIN R15 [get_ports sure_btn1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sure_btn1_IBUF]

#set_property IOSTANDARD LVCMOS33 [get_ports sure_lt]
#set_property PACKAGE_PIN L1 [get_ports sure_lt]

set_property PACKAGE_PIN T5 [get_ports {switches[0]}]
set_property PACKAGE_PIN T3 [get_ports {switches[1]}]
set_property PACKAGE_PIN R3 [get_ports {switches[2]}]
set_property PACKAGE_PIN V4 [get_ports {switches[3]}]
set_property PACKAGE_PIN V5 [get_ports {switches[4]}]
set_property PACKAGE_PIN V2 [get_ports {switches[5]}]
set_property PACKAGE_PIN U2 [get_ports {switches[6]}]
set_property PACKAGE_PIN U3 [get_ports {switches[7]}]

set_property PACKAGE_PIN R1 [get_ports {switches[8]}]
set_property PACKAGE_PIN N4 [get_ports {switches[9]}]
set_property PACKAGE_PIN M4 [get_ports {switches[10]}]
set_property PACKAGE_PIN R2 [get_ports {switches[11]}]
set_property PACKAGE_PIN P2 [get_ports {switches[12]}]
set_property PACKAGE_PIN P3 [get_ports {switches[13]}]
set_property PACKAGE_PIN P4 [get_ports {switches[14]}]
set_property PACKAGE_PIN P5 [get_ports {switches[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports {switches[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports leds[*]]

set_property PACKAGE_PIN F6 [get_ports leds[15]]
set_property PACKAGE_PIN G4 [get_ports leds[14]]
set_property PACKAGE_PIN G3 [get_ports leds[13]]
set_property PACKAGE_PIN J4 [get_ports leds[12]]
set_property PACKAGE_PIN H4 [get_ports leds[11]]
set_property PACKAGE_PIN J3 [get_ports leds[10]]
set_property PACKAGE_PIN J2 [get_ports leds[9]]
set_property PACKAGE_PIN K2 [get_ports leds[8]]

set_property PACKAGE_PIN K1 [get_ports leds[7]]
set_property PACKAGE_PIN H6 [get_ports leds[6]]
set_property PACKAGE_PIN H5 [get_ports leds[5]]
set_property PACKAGE_PIN J5 [get_ports leds[4]]
set_property PACKAGE_PIN K6 [get_ports leds[3]]
set_property PACKAGE_PIN L1 [get_ports leds[2]]
set_property PACKAGE_PIN M1 [get_ports leds[1]]
set_property PACKAGE_PIN K3 [get_ports leds[0]]

# HYN

set_property PACKAGE_PIN B4 [get_ports {led[0]}]
set_property PACKAGE_PIN A4 [get_ports {led[1]}]
set_property PACKAGE_PIN A3 [get_ports {led[2]}]
set_property PACKAGE_PIN B1 [get_ports {led[3]}]
set_property PACKAGE_PIN A1 [get_ports {led[4]}]
set_property PACKAGE_PIN B3 [get_ports {led[5]}]
set_property PACKAGE_PIN B2 [get_ports {led[6]}]
set_property PACKAGE_PIN D5 [get_ports {led[7]}]  

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

set_property PACKAGE_PIN D4 [get_ports {led1[0]}]
set_property PACKAGE_PIN E3 [get_ports {led1[1]}]
set_property PACKAGE_PIN D3 [get_ports {led1[2]}]
set_property PACKAGE_PIN F4 [get_ports {led1[3]}]
set_property PACKAGE_PIN F3 [get_ports {led1[4]}]
set_property PACKAGE_PIN E2 [get_ports {led1[5]}]
set_property PACKAGE_PIN D2 [get_ports {led1[6]}]
set_property PACKAGE_PIN H2 [get_ports {led1[7]}]  

set_property IOSTANDARD LVCMOS33 [get_ports {led1[*]}]

## 数码管位选 DIG[7:0]
set_property PACKAGE_PIN G2 [get_ports {num[0]}]
set_property PACKAGE_PIN C2 [get_ports {num[1]}]
set_property PACKAGE_PIN C1 [get_ports {num[2]}]
set_property PACKAGE_PIN H1 [get_ports {num[3]}]
set_property PACKAGE_PIN G1 [get_ports {num[4]}]
set_property PACKAGE_PIN F1 [get_ports {num[5]}]
set_property PACKAGE_PIN E1 [get_ports {num[6]}]
set_property PACKAGE_PIN G6 [get_ports {num[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {num[*]}]


