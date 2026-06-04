`timescale 1ns/1ps

module motor_control_tb();
    
    reg clk;
    reg resetn;
    reg x;
    reg y;
    wire f;
    wire g;
    
    // Instantiate the module under test
    top_module uut (
        .clk(clk),
        .resetn(resetn),
        .x(x),
        .y(y),
        .f(f),
        .g(g)
    );
    
    // Clock generation: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        $dumpfile("motor_control.vcd");
        $dumpvars(0, motor_control_tb);
        
        // Initialize
        resetn = 0;
        x = 0;
        y = 0;
        
        #20;  // Hold reset for 2 clocks
        
        // Release reset (active-low)
        resetn = 1;
        #10;
        
        // Test Case 1: Apply sequence with pattern 101
        // State machine waits for 101 pattern in x input
        $display("\n=== Test Case 1: Input sequence for 101 pattern ===");
        
        // Clock 1: x = 1
        x = 1'b1;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b", $time, x, f, g);
        
        // Clock 2: x = 0
        x = 1'b0;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b", $time, x, f, g);
        
        // Clock 3: x = 1 (this completes the 101 pattern)
        x = 1'b1;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b (Pattern 101 detected)", $time, x, f, g);
        
        // Clock 4: y = 0 (continue, no reset)
        y = 1'b0;
        x = 1'b0;
        #10;
        $display("Time: %t, x=%b, y=%b, f=%b, g=%b", $time, x, y, f, g);
        
        #10;
        $display("Time: %t, x=%b, y=%b, f=%b, g=%b", $time, x, y, f, g);
        
        // Test Case 2: Reset during operation
        $display("\n=== Test Case 2: Reset during operation ===");
        resetn = 0;
        #10;
        $display("Time: %t, resetn=%b, f=%b, g=%b (Reset asserted)", $time, resetn, f, g);
        
        resetn = 1;
        #10;
        $display("Time: %t, resetn=%b, f=%b, g=%b (Reset released)", $time, resetn, f, g);
        
        // Test Case 3: New sequence after reset
        $display("\n=== Test Case 3: New sequence with y=1 ===");
        
        x = 1'b1;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b", $time, x, f, g);
        
        x = 1'b0;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b", $time, x, f, g);
        
        x = 1'b1;
        #10;
        $display("Time: %t, x=%b, f=%b, g=%b (Pattern 101 detected)", $time, x, f, g);
        
        // Now y = 1
        y = 1'b1;
        x = 1'b0;
        #10;
        $display("Time: %t, x=%b, y=%b, f=%b, g=%b", $time, x, y, f, g);
        
        #10;
        $display("Time: %t, x=%b, y=%b, f=%b, g=%b", $time, x, y, f, g);
        
        // Reset to go back to initial state
        resetn = 0;
        #10;
        $display("Time: %t, Reset asserted, f=%b, g=%b", $time, f, g);
        
        resetn = 1;
        #20;
        
        $display("\n=== Simulation Complete ===\n");
        $finish;
    end
    
endmodule
