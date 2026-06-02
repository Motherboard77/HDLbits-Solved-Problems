`timescale 1ns/1ps
module fsm3_tb;
    reg clk;
    reg reset;
    reg w;
    wire z;

    // instantiate DUT
    top_module uut (
        .clk(clk),
        .reset(reset),
        .w(w),
        .z(z)
    );

    initial begin
        $dumpfile("fsm3_tb.vcd");
        $dumpvars(0, fsm3_tb);
        $display("time clk reset w state z");
        $monitor("%0t %b %b %b %03b %b", $time, clk, reset, w, uut.state, z);

        // init
        clk = 0; reset = 1; w = 0;
        #10;
        reset = 0;
        #10;

        // exercise transitions
        // from A: w=0 -> B
        w = 0; #10;
        // B: w=1 -> D
        w = 1; #10;
        // D: w=0 -> F
        w = 0; #10;
        // F: w=1 -> D
        w = 1; #10;
        // D: w=1 -> A
        w = 1; #10;
        // A: w=0 -> B
        w = 0; #10;
        // B: w=0 -> C
        w = 0; #10;
        // C: w=0 -> E
        w = 0; #10;
        // E: w=1 -> D
        w = 1; #10;
        // D: w=0 -> F
        w = 0; #10;

        #20;
        $finish;
    end

    // 10ns clock period
    always #5 clk = ~clk;

endmodule
