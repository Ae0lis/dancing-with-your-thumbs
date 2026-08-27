# Dancing With Your Thumbs

Dancing With Your Thumbs is a four-lane rhythm game implemented in SystemVerilog on a DE1-SoC FPGA. It was completed as a solo final project for the University of Washington's EE 271 course over two weeks in Spring 2026.

## Features

- Four independently generated note lanes on a 16x16 red/green LED matrix
- Seeded 10-bit LFSRs for pseudorandom note generation
- Good and perfect timing regions with color-coded hit feedback
- Four selectable game speeds: approximately 6, 12, 18, and 24 updates per second
- Miss penalties and a four-digit score that saturates from 0000 to 9999
- Synchronized push-button input and seven-segment score output

## Hardware and controls

The design targets the Terasic DE1-SoC board's Cyclone V FPGA (`5CSEMA5F31C6`) and its 16x16 bicolor LED matrix expansion board.

| Input | Function |
| --- | --- |
| `KEY[3:0]` | Rhythm-game lane buttons |
| `SW[8:7]` | Difficulty selection |
| `SW[9]` | System reset |

The four score digits are displayed on `HEX3` through `HEX0`.

## Architecture

Each lane is implemented as a chain of finite-state machines representing the rows of the LED matrix. A seeded LFSR determines when a new note enters an empty lane. The upper three rows implement the good/perfect/good scoring windows, while the remaining rows detect early presses and missed notes. Per-lane signed score changes are combined and accumulated by cascaded BCD counters.

The game logic generates 16x16 red and green framebuffers. A course-provided scanning driver converts those framebuffers into the GPIO signals used by the LED matrix.

The saved Quartus build successfully synthesized and fit on the target FPGA using 211 ALMs and 194 registers.

## Repository layout

- `Dancing With Your Thumbs/` - SystemVerilog source, testbenches, and Quartus project files
- `Dancing With Your Thumbs User Manual.pdf` - controls, gameplay rules, and hierarchical block diagrams
- `Dancing With Your Thumbs Market & Usability Analysis.pdf` - design iterations and usability decisions

Generated Quartus and ModelSim files are excluded from version control.

## Building and running

1. Open `Dancing With Your Thumbs/DE1_SoC.qpf` in Quartus Prime Lite 17.0.
2. Compile the `DE1_SoC` revision for the Cyclone V target.
3. Connect the 16x16 LED matrix to GPIO 1 and program the generated bitstream onto the DE1-SoC.
4. Toggle `SW[9]` to reset the system, select a difficulty with `SW[8:7]`, and play using `KEY[3:0]`.

The included `runlab.do` script can be used with ModelSim-Intel FPGA Edition to compile the RTL and run the integration testbench.

## Attribution

All game logic, scoring, input handling, testbenches, and display-generation RTL were written by Ben Robison. The following course-provided modules were integrated into the project:

- `clock_divider.sv`
- `LEDDriver.sv`

