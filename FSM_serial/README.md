# UART Frame Detector (serial_uart)

This directory contains a simple UART-style frame detector implemented in Verilog.

## Module Interface

`top_module` inputs:
- `clk` : clock input
- `in` : serial data input
- `reset` : synchronous reset input

Output:
- `done` : asserted when a valid frame end (stop bit) is detected

## Behavior

The RTL monitors the serial input for a low start bit (`in = 0`). Once a start bit is detected, it counts 8 bit periods. After the 8-bit payload period, it checks the stop bit. If the stop bit is high (`in = 1`), the module transitions back to idle and asserts `done`.

If the stop bit is low, the design remains in an error/recovery state until the line returns high.

## Simulation

A testbench is provided in `serial_uart_tb.v`.

To simulate using Icarus Verilog:

```bash
cd FSM_serial
iverilog -o serial_uart_tb serial_uart.v serial_uart_tb.v
vvp serial_uart_tb
```

This will produce a waveform file named `serial_uart.vcd`. You can view it with GTKWave:

```bash
gtwave serial_uart.vcd
```

## Notes

- The testbench drives a valid frame followed by an invalid frame to demonstrate normal and error behavior.
- The module uses a synchronous reset and a simple finite-state machine to detect the start bit, count payload cycles, and validate the stop bit.
