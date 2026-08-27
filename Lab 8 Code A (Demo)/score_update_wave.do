onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group In /score_update_testbench/scoreC1
add wave -noupdate -expand -group In /score_update_testbench/scoreC2
add wave -noupdate -expand -group In /score_update_testbench/scoreC3
add wave -noupdate -expand -group In /score_update_testbench/scoreC4
add wave -noupdate -expand -group Internal /score_update_testbench/dut/paddedC1
add wave -noupdate -expand -group Internal /score_update_testbench/dut/paddedC2
add wave -noupdate -expand -group Internal /score_update_testbench/dut/paddedC3
add wave -noupdate -expand -group Internal /score_update_testbench/dut/paddedC4
add wave -noupdate -expand -group out /score_update_testbench/totalScore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {70 ps}
