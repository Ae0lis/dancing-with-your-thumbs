onerror {resume}
quietly virtual function -install /DE1_SoC_testbench -env /DE1_SoC_testbench { &{/DE1_SoC_testbench/SW[8], /DE1_SoC_testbench/SW[7], /DE1_SoC_testbench/SW[6], /DE1_SoC_testbench/SW[5], /DE1_SoC_testbench/SW[4], /DE1_SoC_testbench/SW[3], /DE1_SoC_testbench/SW[2], /DE1_SoC_testbench/SW[1], /DE1_SoC_testbench/SW[0] }} Difficulty
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Basic /DE1_SoC_testbench/CLOCK_50
add wave -noupdate -expand -group Basic {/DE1_SoC_testbench/SW[9]}
add wave -noupdate -expand -group Out /DE1_SoC_testbench/HEX0
add wave -noupdate -expand -group Out /DE1_SoC_testbench/HEX1
add wave -noupdate -expand -group Out /DE1_SoC_testbench/LEDR
add wave -noupdate -expand -group Player {/DE1_SoC_testbench/KEY[0]}
add wave -noupdate -expand -group Difficulty /DE1_SoC_testbench/Difficulty
add wave -noupdate -group Bobotcheck /DE1_SoC_testbench/dut/bobotcheck/A
add wave -noupdate -group Bobotcheck /DE1_SoC_testbench/dut/bobotcheck/B
add wave -noupdate -group Bobotcheck /DE1_SoC_testbench/dut/bobotcheck/bincheck
add wave -noupdate -group Bobotcheck /DE1_SoC_testbench/dut/bobotcheck/out
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
configure wave -timelineunits ps
update
WaveRestoreZoom {170 ps} {1170 ps}
