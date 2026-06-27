`timescale 1ns / 1ps

module FSM1_tb();

    reg clk;
    reg reset;
    reg s;
    reg w;
    wire z;
    
    // Instantiate the module
    top_module DUT (
        .clk(clk),
        .reset(reset),
        .s(s),
        .w(w),
        .z(z)
    );
    
    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    // Test scenarios
    initial begin
        // Test 1: Basic reset
        $display("\n===== Test 1: Basic Reset =====");
        reset = 1;
        s = 0;
        w = 0;
        #10;
        reset = 0;
        #10;
        $display("After reset - z = %b (expected: 0)", z);
        
        // Test 2: Stay in state 0, no transitions
        $display("\n===== Test 2: Stay in State 0 =====");
        s = 0;
        w = 0;
        repeat(5) @(posedge clk);
        $display("State 0, z = %b (expected: 0)", z);
        
        // Test 3: Transition to state 1 with no w pulses
        $display("\n===== Test 3: Transition to State 1, No W Pulses =====");
        s = 1;
        @(posedge clk);
        s = 0;
        w = 0;
        repeat(3) @(posedge clk);
        $display("After transition to state 1 (no w), z = %b (expected: 0)", z);
        
        // Test 4: Single w pulse (should not trigger z)
        $display("\n===== Test 4: Single W Pulse =====");
        s = 1;
        @(posedge clk);
        s = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        @(posedge clk);
        $display("After 1 w pulse, z = %b (expected: 0)", z);
        
        // Test 5: Two w pulses within the window (should trigger z)
        $display("\n===== Test 5: Two W Pulses Within Window =====");
        s = 1;
        @(posedge clk);
        s = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        @(posedge clk);
        $display("After 2 w pulses, z = %b (expected: 1)", z);
        
        // Test 6: Reset during state 1
        $display("\n===== Test 6: Reset During State 1 =====");
        s = 1;
        @(posedge clk);
        s = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);
        $display("After reset in state 1, z = %b (expected: 0)", z);
        
        // Test 7: Multiple w pulses (more than 2)
        $display("\n===== Test 7: Multiple W Pulses (More than 2) =====");
        s = 1;
        @(posedge clk);
        s = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        w = 1;
        @(posedge clk);
        w = 0;
        @(posedge clk);
        $display("After 3 w pulses, z = %b (expected: 0)", z);
        
        // Test 8: Edge case - w held high
        $display("\n===== Test 8: W Held High =====");
        reset = 1;
        @(posedge clk);
        reset = 0;
        s = 1;
        @(posedge clk);
        s = 0;
        w = 1;
        repeat(4) @(posedge clk);
        w = 0;
        @(posedge clk);
        $display("After w held high for 2 clocks, z = %b (expected: 1)", z);
        
        $display("\n===== Simulation Complete =====");
        $finish;
    end
    
    // Waveform dumping (optional)
    initial begin
        $dumpfile("FSM1_tb.vcd");
        $dumpvars(0, FSM1_tb);
    end
    
endmodule
