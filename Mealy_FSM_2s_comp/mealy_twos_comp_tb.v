module tb;
    reg clk;
    reg areset;
    reg x;
    wire z;

    top_module uut (
        .clk(clk),
        .areset(areset),
        .x(x),
        .z(z)
    );

    initial begin
        $dumpfile("mealy.vcd");
        $dumpvars(0, tb);

        clk = 0;
        areset = 1;
        x = 0;
        #7 areset = 0;

        #10 x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;

        #20 $finish;
    end

    always #5 clk = ~clk;
endmodule
