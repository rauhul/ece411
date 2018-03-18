onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate -radix hexadecimal /mp3_tb/dut/_cpu/_stage_IF/pc/out
add wave -noupdate -radix hexadecimal -childformat {{{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[7]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[6]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[5]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[4]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[3]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[2]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[1]} -radix hexadecimal} {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[7]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[6]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[5]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[4]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[3]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[2]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[1]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cpu/_stage_ID/_regfile/data[0]} {-color Gold -height 15 -radix hexadecimal}} /mp3_tb/dut/_cpu/_stage_ID/_regfile/data
add wave -noupdate /mp3_tb/dut/_cpu/_stage_IF/pc_mux_sel
add wave -noupdate /mp3_tb/dut/_cpu/_stage_MEM/cc/out
add wave -noupdate /mp3_tb/dut/_cpu/_stage_MEM/_mem_access_controller/state
add wave -noupdate /mp3_tb/dut/_cpu/_stage_MEM/_mem_access_controller/next_state
add wave -noupdate /mp3_tb/dut/_cpu/_stage_MEM/_mem_access_controller/opcode
add wave -noupdate -radix hexadecimal /mp3_tb/dut/_cpu/_stage_MEM/data_memory_addr_mux/f
add wave -noupdate /mp3_tb/memory/state
add wave -noupdate /mp3_tb/memory/resp
add wave -noupdate /mp3_tb/physical_memory_wishbone/CLK
add wave -noupdate /mp3_tb/physical_memory_wishbone/DAT_M
add wave -noupdate /mp3_tb/physical_memory_wishbone/DAT_S
add wave -noupdate /mp3_tb/physical_memory_wishbone/ACK
add wave -noupdate /mp3_tb/physical_memory_wishbone/CYC
add wave -noupdate /mp3_tb/physical_memory_wishbone/STB
add wave -noupdate /mp3_tb/physical_memory_wishbone/RTY
add wave -noupdate /mp3_tb/physical_memory_wishbone/WE
add wave -noupdate /mp3_tb/physical_memory_wishbone/ADR
add wave -noupdate /mp3_tb/physical_memory_wishbone/SEL
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/CLK
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/DAT_M
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/DAT_S
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/ACK
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/CYC
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/STB
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/RTY
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/WE
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/ADR
add wave -noupdate /mp3_tb/dut/instruction_memory_wishbone/SEL
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/CLK
add wave -noupdate -radix hexadecimal /mp3_tb/dut/data_memory_wishbone/DAT_M
add wave -noupdate -radix hexadecimal /mp3_tb/dut/data_memory_wishbone/DAT_S
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/ACK
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/CYC
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/STB
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/RTY
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/WE
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/ADR
add wave -noupdate /mp3_tb/dut/data_memory_wishbone/SEL
add wave -noupdate /mp3_tb/dut/_cache/i_cache/_cache_l1_controller/state
add wave -noupdate -color Gold -radix hexadecimal -childformat {{{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[7]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[6]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[5]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[4]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[3]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[2]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[1]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[7]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[6]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[5]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[4]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[3]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[2]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[1]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data[0]} {-color Gold -height 15 -radix hexadecimal}} /mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_0/_data
add wave -noupdate -color Gold -radix hexadecimal -childformat {{{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[7]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[6]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[5]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[4]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[3]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[2]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[1]} -radix hexadecimal} {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[7]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[6]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[5]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[4]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[3]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[2]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[1]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data[0]} {-color Gold -height 15 -radix hexadecimal}} /mp3_tb/dut/_cache/i_cache/_cache_l1_datapath/cache_way_1/_data
add wave -noupdate /mp3_tb/dut/_cache/d_cache/_cache_l1_controller/state
add wave -noupdate -color {Cornflower Blue} -radix hexadecimal -childformat {{{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[7]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[6]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[5]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[4]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[3]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[2]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[1]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[7]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[6]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[5]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[4]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[3]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[2]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[1]} {-color {Cornflower Blue} -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data[0]} {-color {Cornflower Blue} -height 15 -radix hexadecimal}} /mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_0/_data
add wave -noupdate -color Gold -radix hexadecimal -childformat {{{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[7]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[6]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[5]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[4]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[3]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[2]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[1]} -radix hexadecimal} {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[7]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[6]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[5]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[4]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[3]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[2]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[1]} {-color Gold -height 15 -radix hexadecimal} {/mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data[0]} {-color Gold -height 15 -radix hexadecimal}} /mp3_tb/dut/_cache/d_cache/_cache_l1_datapath/cache_way_1/_data
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/clk
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_IF_request_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_MEM_request_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/barrier_IF_ID_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/barrier_ID_EX_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/barrier_EX_MEM_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/barrier_MEM_WB_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_IF_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_ID_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_EX_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_MEM_stall
add wave -noupdate -color Magenta /mp3_tb/dut/_cpu/_stall_controller/stage_WB_stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {335000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 478
configure wave -valuecolwidth 257
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
WaveRestoreZoom {0 ps} {1050 ns}
