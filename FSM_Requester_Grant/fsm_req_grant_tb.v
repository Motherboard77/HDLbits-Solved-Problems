`timescale 1ns / 1ps

module fsm_req_grant_tb;

    reg clk;
    reg resetn;
    reg [3:1] r;
    wire [3:1] g;

    // Instantiate the module under test
    top_module uut (
        .clk(clk),
        .resetn(resetn),
        .r(r),
        .g(g)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        resetn = 0;
        r = 3'b000;

        // Apply reset
        #12 resetn = 1;
        #10;

        $display("\nTime    resetn  r   g");
        $display("------------------------");

        // Test 1: no request -> stay in state A, all grants zero
        r = 3'b000;
        #10 $display("%4t    %b      %b   %b", $time, resetn, r, g);

        // Test 2: request from line 1 => should go to state B and grant g[1]
        r = 3'b001;
        #10 $display("%4t    %b      %b   %b  (expected g=001)", $time, resetn, r, g);

        // Keep request active on line 1 and ensure state stays in B
        r = 3'b001;
        #10 $display("%4t    %b      %b   %b  (stay in B)", $time, resetn, r, g);

        // Test 3: remove request -> return to state A
        r = 3'b000;
        #10 $display("%4t    %b      %b   %b  (return to A)", $time, resetn, r, g);

        // Test 4: request from line 2 => should go to state C and grant g[2]
        r = 3'b010;
        #10 $display("%4t    %b      %b   %b  (expected g=010)", $time, resetn, r, g);

        // Test 5: request from line 3 => should go to state D and grant g[3]
        r = 3'b100;
        #10 $display("%4t    %b      %b   %b  (expected g=100)", $time, resetn, r, g);

        // Test 6: multiple requests, line 1 has highest priority => grant g[1]
        r = 3'b111;
        #10 $display("%4t    %b      %b   %b  (expected g=001 due priority to r[1])", $time, resetn, r, g);

        // Test 7: request line 1 cleared while in state B -> should return to A on next cycle
        r = 3'b000;
        #10 $display("%4t    %b      %b   %b  (expected g=000)", $time, resetn, r, g);

        // Final check: request line 2 again after reset state A
        r = 3'b010;
        #10 $display("%4t    %b      %b   %b  (expected g=010)", $time, resetn, r, g);

        #10 $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("fsm_req_grant.vcd");
        $dumpvars(0, fsm_req_grant_tb);
    end

endmodule
