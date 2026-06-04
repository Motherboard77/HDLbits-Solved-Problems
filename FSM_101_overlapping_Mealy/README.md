FSM_101_overlapping_Mealy
=========================

Contents
- mealy_overlapped.v : Mealy FSM top module
- mealy_overlapped_tb.v : Testbench for simulation

Running the testbench

1. Install Icarus Verilog (if not already installed):

   sudo apt update && sudo apt install -y iverilog vvp

2. From this folder run:

   iverilog -o tb.out mealy_overlapped.v mealy_overlapped_tb.v
   vvp tb.out

3. A waveform file `mealy_overlapped.vcd` will be produced. Open it with `gtkwave`:

   gtkwave mealy_overlapped.vcd

What the testbench does
- Toggles a 10 ns clock
- Releases reset after a short delay
- Applies a sequence of `x` inputs to demonstrate the overlapping Mealy output `z`
