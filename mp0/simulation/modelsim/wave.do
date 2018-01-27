onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp0_tb/clk
add wave -noupdate -radix hexadecimal /mp0_tb/dut/_datapath/pc/out
add wave -noupdate -radix hexadecimal /mp0_tb/mem_address
add wave -noupdate -radix hexadecimal /mp0_tb/mem_read
add wave -noupdate -radix hexadecimal /mp0_tb/mem_rdata
add wave -noupdate -radix hexadecimal /mp0_tb/mem_write
add wave -noupdate -radix hexadecimal /mp0_tb/mem_byte_enable
add wave -noupdate -radix hexadecimal /mp0_tb/mem_wdata
add wave -noupdate -radix hexadecimal /mp0_tb/mem_resp
add wave -noupdate -radix hexadecimal -childformat {{{/mp0_tb/dut/_datapath/_regfile/data[7]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[6]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[5]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[4]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[3]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[2]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[1]} -radix hexadecimal} {{/mp0_tb/dut/_datapath/_regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp0_tb/dut/_datapath/_regfile/data[7]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[6]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[5]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[4]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[3]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[2]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[1]} {-radix hexadecimal} {/mp0_tb/dut/_datapath/_regfile/data[0]} {-radix hexadecimal}} /mp0_tb/dut/_datapath/_regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1998195 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
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
WaveRestoreZoom {1997740 ps} {1999148 ps}
