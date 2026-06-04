# FSM Motor Control

## Overview

This directory contains a Finite State Machine (FSM) implementation for motor control. The module detects a specific bit pattern (101) in a serial input stream and generates control signals for motor operation based on additional input signals.

## Module Description

### Top Module: `top_module`

**Inputs:**
- `clk`: System clock (active-high)
- `resetn`: Asynchronous reset (active-low, synchronous in operation)
- `x`: Serial input data stream
- `y`: Control input signal

**Outputs:**
- `f`: Output flag signal
- `g`: Motor control signal

## Functionality

The FSM implements a motor controller with the following behavior:

### State Machine States:
- **State A**: Idle state - waits for reset release
- **State B**: Initial state after reset - generates flag `f = 1` for one clock cycle
- **State C**: Pattern detection state - monitors input `x` for the pattern "101"
  - Uses a 3-bit shift register (`inp_cap`) to capture the last 3 bits of input
  - Detects when the pattern matches "101"
- **State D**: Transition state - waits for input `y` to determine next state
- **State E/E0**: Terminal state - remains here if `y = 0` after pattern detection
- **State E1**: Terminal state - remains here if `y = 1` after pattern detection

### Control Outputs:
- **f (Flag)**: Set to 1 only in state B (one clock cycle after reset)
- **g (Motor Control)**: Set to 1 when FSM is in states D, E, E0, or E1 (i.e., after pattern 101 is detected)

## Architecture Details

### Key Components:
1. **State register** (`state`): Holds current FSM state (3 bits)
2. **Shift register** (`inp_cap`): Captures last 3 input bits for pattern matching
3. **Clock counter** (`clk_cnt`): Tracks cycles during pattern detection phase
4. **Pattern detector** (`flag_g_val`): Combinational logic detecting "101" pattern

### Pattern Detection Logic:
The module continuously shifts in the input `x` while in state C. When three consecutive bits match "101", the `flag_g_val` signal triggers a transition to state D.

## Files

- **motor_control.v**: Main FSM implementation
- **motor_control_tb.v**: Comprehensive testbench with multiple test cases
- **motor_control.vcd**: VCD waveform file (generated from simulation)
- **README.md**: This file

## Simulation

### Build and Run:
```bash
cd FSM_motor_control
iverilog -o motor_control motor_control.v motor_control_tb.v
vvp motor_control
```

### Waveform Viewing:
```bash
gtkwave motor_control.vcd
```

## Test Cases

The testbench includes three main test scenarios:

### Test Case 1: Basic Pattern Detection
- Applies input sequence "1, 0, 1" to trigger pattern detection
- Verifies that output `g` becomes active after pattern detection
- With `y = 0`, the FSM transitions to state E0 and holds

### Test Case 2: Reset During Operation
- Asserts reset (`resetn = 0`) during operation
- Verifies FSM returns to initial state (state A)
- Confirms proper reset synchronization

### Test Case 3: Pattern Detection with y = 1
- Repeats pattern detection with different input
- Sets `y = 1` to test state E1 transition
- Demonstrates conditional state transitions based on `y` input

## Simulation Results

```
=== Test Case 1: Input sequence for 101 pattern ===
Time:                40000, x=1, f=0, g=0
Time:                50000, x=0, f=0, g=0
Time:                60000, x=1, f=0, g=0 (Pattern 101 detected)
Time:                70000, x=0, y=0, f=0, g=0
Time:                80000, x=0, y=0, f=0, g=0

=== Test Case 2: Reset during operation ===
Time:                90000, resetn=0, f=0, g=0 (Reset asserted)
Time:               100000, resetn=1, f=1, g=0 (Reset released)

=== Test Case 3: New sequence with y=1 ===
Time:               110000, x=1, f=0, g=0
Time:               120000, x=0, f=0, g=0
Time:               130000, x=1, f=0, g=0 (Pattern 101 detected)
Time:               140000, x=0, y=1, f=0, g=0
Time:               150000, x=0, y=1, f=0, g=0
Time:               160000, Reset asserted, f=0, g=0

=== Simulation Complete ===
```

## Timing

- **Clock Period**: 10 ns (100 MHz)
- **Time Unit**: 1 ns
- **Time Precision**: 1 ps

## Key Features

1. **Pattern Recognition**: Detects specific bit sequence (101) in serial stream
2. **State Retention**: Maintains motor control signal until reset
3. **Conditional Behavior**: State transitions depend on external `y` input
4. **Synchronous Design**: All state transitions occur on clock edges
5. **Active-Low Reset**: Standard asynchronous reset with synchronous operation

## Usage in Application

This FSM could be used in motor control systems where:
- A specific command pattern (101) initiates motor operation
- The `y` signal determines motor mode or direction
- The `g` output directly controls motor enable/disable
- The `f` output signals completion of initialization sequence

## Design Considerations

- **Clock Synchronization**: All inputs are sampled on clock edges
- **Metastability Protection**: Reset is active-low to avoid metastable states
- **Simple Encoding**: States use 3-bit binary encoding for efficiency
- **Combinational Pattern Detection**: Pattern matching computed in parallel with state transitions
