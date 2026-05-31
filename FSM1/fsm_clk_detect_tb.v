`timescale 1ns / 1ps

module fsm_clk_detect_tb;

    reg clk;
    reg reset;
    reg s;
    reg w;
    wire z;

    // Instantiate the module under test
    top_module uut (
        .clk(clk),
        .reset(reset),
        .s(s),
        .w(w),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        s = 0;
        w = 0;

        // Apply reset
        #10 reset = 0;

        // Test 1: Stay in state A while s=0
        $display("\n=== Test 1: Stay in State A (s=0) ===");
        #30 $display("Time: %0t, s=%b, w=%b, z=%b (Expected z=0)", $time, s, w, z);

        // Test 2: Transition to state B with s=1
        $display("\n=== Test 2: Transition to State B (s=1) ===");
        s = 1;
        w = 0;
        #10 $display("Time: %0t, s=%b, w=%b, z=%b", $time, s, w, z);

        // Test 3: First 3-cycle window - Check w values (1,1,0) = 2 ones -> z should be 1
        $display("\n=== Test 3: First Window - w=(1,1,0) - Should output z=1 ===");
        s = 0;  // Keep s=0 to stay in state B after first s=1
        w = 1;
        #10 $display("Cycle 1: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 2: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 0;
        #10 $display("Cycle 3: Time: %0t, w=%b, z=%b", $time, w, z);
        #10 $display("Output: Time: %0t, z=%b (Expected z=1)", $time, z);

        // Test 4: Second window - Check w values (0,1,1) = 2 ones -> z should be 1
        $display("\n=== Test 4: Second Window - w=(0,1,1) - Should output z=1 ===");
        w = 0;
        #10 $display("Cycle 1: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 2: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 3: Time: %0t, w=%b, z=%b", $time, w, z);
        #10 $display("Output: Time: %0t, z=%b (Expected z=1)", $time, z);

        // Test 5: Third window - Check w values (1,0,1) = 2 ones -> z should be 1
        $display("\n=== Test 5: Third Window - w=(1,0,1) - Should output z=1 ===");
        w = 1;
        #10 $display("Cycle 1: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 0;
        #10 $display("Cycle 2: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 3: Time: %0t, w=%b, z=%b", $time, w, z);
        #10 $display("Output: Time: %0t, z=%b (Expected z=1)", $time, z);

        // Test 6: Fourth window - Check w values (0,0,0) = 0 ones -> z should be 0
        $display("\n=== Test 6: Fourth Window - w=(0,0,0) - Should output z=0 ===");
        w = 0;
        #10 $display("Cycle 1: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 0;
        #10 $display("Cycle 2: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 0;
        #10 $display("Cycle 3: Time: %0t, w=%b, z=%b", $time, w, z);
        #10 $display("Output: Time: %0t, z=%b (Expected z=0)", $time, z);

        // Test 7: Fifth window - Check w values (1,1,1) = 3 ones -> z should be 0
        $display("\n=== Test 7: Fifth Window - w=(1,1,1) - Should output z=0 ===");
        w = 1;
        #10 $display("Cycle 1: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 2: Time: %0t, w=%b, z=%b", $time, w, z);

        w = 1;
        #10 $display("Cycle 3: Time: %0t, w=%b, z=%b", $time, w, z);
        #10 $display("Output: Time: %0t, z=%b (Expected z=0)", $time, z);

        // Test 8: Return to state A with s=0
        $display("\n=== Test 8: Return to State A ===");
        s = 0;
        w = 0;
        #30 $display("Time: %0t, s=%b, z=%b (Expected z=0)", $time, s, z);

        #10 $finish;
    end

    // Dump waveforms to VCD file
    initial begin
        $dumpfile("fsm_clk_detect.vcd");
        $dumpvars(0, fsm_clk_detect_tb);
    end

endmodule
