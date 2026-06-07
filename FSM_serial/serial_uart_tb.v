`timescale 1ns/1ps

module serial_uart_tb;
    reg clk;
    reg in;
    reg reset;
    wire done;

    // Instantiate the design under test
    top_module uut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .done(done)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("serial_uart.vcd");
        $dumpvars(0, serial_uart_tb);

        reset = 1;
        in = 1;               // UART idle state is high
        #20;

        reset = 0;
        #20;

        // Send a valid UART frame: start bit, 8 data bits, stop bit
        // Data bits are transmitted LSB-first.
        in = 0;               // start bit
        #10;
        in = 1;               // bit 0
        #10;
        in = 0;               // bit 1
        #10;
        in = 1;               // bit 2
        #10;
        in = 0;               // bit 3
        #10;
        in = 1;               // bit 4
        #10;
        in = 0;               // bit 5
        #10;
        in = 1;               // bit 6
        #10;
        in = 0;               // bit 7
        #10;
        in = 1;               // stop bit
        #50;

        // Send an invalid frame with a bad stop bit
        in = 0;               // start bit
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 1;
        #10;
        in = 0;               // bad stop bit
        #50;

        // Return to idle and finish simulation
        in = 1;
        #40;

        $display("Simulation complete.");
        $finish;
    end

    initial begin
        $monitor("%0t ns: reset=%b in=%b done=%b", $time, reset, in, done);
    end

endmodule
