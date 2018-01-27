## Generated SDC file "mp1.out.sdc"

## Copyright (C) 1991-2014 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.4 Build 182 03/12/2014 SJ Full Version"

## DATE    "Mon Jan 22 17:17:04 2018"

##
## DEVICE  "EP3SE50F780C2"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {clk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_rdata[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_resp}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_address[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_byte_enable[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_byte_enable[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_read}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_wdata[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {mem_write}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

