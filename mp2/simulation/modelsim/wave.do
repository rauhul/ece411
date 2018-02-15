onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/dut/_cpu_control/opcode
add wave -noupdate -label clk -radix hexadecimal /mp2_tb/clk
add wave -noupdate -label pc_out -radix hexadecimal /mp2_tb/dut/_cpu_datapath/pc/out
add wave -noupdate -label mem_address -radix hexadecimal /mp2_tb/mem_address
add wave -noupdate -label mem_read -radix hexadecimal /mp2_tb/mem_read
add wave -noupdate -label mem_rdata -radix hexadecimal /mp2_tb/mem_rdata
add wave -noupdate -label mem_write -radix hexadecimal /mp2_tb/mem_write
add wave -noupdate -label mem_byte_enable -radix hexadecimal /mp2_tb/mem_byte_enable
add wave -noupdate -label mem_wdata -radix hexadecimal /mp2_tb/mem_wdata
add wave -noupdate -label R0 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[0]}
add wave -noupdate -label R1 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[1]}
add wave -noupdate -label R2 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[2]}
add wave -noupdate -label R3 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[3]}
add wave -noupdate -label R4 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[4]}
add wave -noupdate -label R5 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[5]}
add wave -noupdate -label R6 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[6]}
add wave -noupdate -label R7 -radix hexadecimal {/mp2_tb/dut/_cpu_datapath/_regfile/data[7]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {420539 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4200 ns}
