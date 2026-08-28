# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./DE1_SoC.sv"
vlog "./clock_divider.sv"
vlog "./User_Input.sv"
vlog "./LFSR10.sv"
vlog "./seg7.sv"
vlog "./Stupid_Comparator.sv"
vlog "./LED_control.sv"
vlog "./LEDDriver.sv"
vlog "./Perfect_Lights.sv"
vlog "./Miss_Lights.sv"
vlog "./Good_Lights.sv"
vlog "./First_Lights.sv"
vlog "./Light_Column.sv"
vlog "./delay.sv"
vlog "./Score_Counter_Display.sv"
vlog "./Score_Update.sv"
vlog "./counter_10.sv"
vlog "./clk_counter.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work LED_control_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do LED_control_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
