// Testbench for mealy_overlapped.v
module tb;
    reg clk;
    reg aresetn;
    reg x;
    wire z;

    top_module uut (
        .clk(clk),
        .aresetn(aresetn),
        .x(x),
        .z(z)
    );

    // Clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // VCD dump
        $dumpfile("mealy_overlapped.vcd");
        $dumpvars(0, tb);

        // Initialize
        aresetn = 0;
        x = 0;

        // Hold reset for a couple cycles
        #12;
        aresetn = 1;
        #10;

        // Stimulus sequence exercising overlapping Mealy behavior
        // Format: #delay x = value;
        #10 x = 1;   // move A->B
        #10 x = 1;   // stay B
        #10 x = 0;   // move B->C
        #10 x = 1;   // in C with x=1 => z should assert (overlapping)
        #10 x = 0;   // move from C->A
        #10 x = 1;   // A->B
        #10 x = 0;   // B->C
        #10 x = 1;   // assert z again
        #20;

        $display("Simulation finished");
        $finish;
    end

    initial begin
        $monitor("%0t clk=%b reset=%b x=%b z=%b", $time, clk, aresetn, x, z);
    end
endmodule
