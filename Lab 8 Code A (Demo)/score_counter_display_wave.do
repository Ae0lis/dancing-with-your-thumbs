onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Basic /score_counter_display_testbench/clk
add wave -noupdate -expand -group Basic /score_counter_display_testbench/reset
add wave -noupdate -expand -group Basic /score_counter_display_testbench/ddr_clk
add wave -noupdate -expand -group Input /score_counter_display_testbench/score
add wave -noupdate -expand -group Out /score_counter_display_testbench/HEX3
add wave -noupdate -expand -group Out /score_counter_display_testbench/HEX2
add wave -noupdate -expand -group Out /score_counter_display_testbench/HEX1
add wave -noupdate -expand -group Out /score_counter_display_testbench/HEX0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {3900340 ps} {3912972 ps}
