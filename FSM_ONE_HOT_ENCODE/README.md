# FSM One-Hot Encode

This folder contains a solved HDLBits problem for a one-hot encoded finite state machine.

## Problem Statement

The problem statement is shown in the image below:

![FSM One-Hot Encode problem statement](FSM_One_Hot_Encode.png)

## One-Hot State Encoding

For this one-hot FSM, the next-state vector is represented by `Y[6:1]`, where each bit corresponds to a unique state:

- `Y[1]` corresponds to state A: `000001`
- `Y[2]` corresponds to state B: `000010`
- `Y[3]` corresponds to state C: `000100`
- `Y[4]` corresponds to state D: `001000`
- `Y[5]` corresponds to state E: `010000`
- `Y[6]` corresponds to state F: `100000`

Important NOTE:

For a one-hot FSM, state position is encoded by a single high bit. For example, state B is represented by bit 2, so `Y2` is the next-state bit for state B. Similarly, state D is represented by bit 4, so `Y4` is the next-state bit for state D.

## Files

- `fsm_one_hot_test.v` - DUT module implementing the FSM outputs.
- `fsm_one_hot_tb.v` - Testbench for the DUT.
- `FSM_One_Hot_Encode.png` - Problem statement image.

## Simulation

Compile and run with:

```bash
iverilog -o tb.vvp fsm_one_hot_test.v fsm_one_hot_tb.v
vvp tb.vvp
```

The waveform is dumped to `fsm_one_hot_tb.vcd`.
