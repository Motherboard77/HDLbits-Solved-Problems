`timescale 1ns/1ps
module fsm_one_hot_tb;
    reg [6:1] y;
    reg w;
    wire Y2, Y4;

    // instantiate DUT
    top_module uut (
        .y(y),
        .w(w),
        .Y2(Y2),
        .Y4(Y4)
    );

    integer k;

    initial begin
        $dumpfile("fsm_one_hot_tb.vcd");
        $dumpvars(0, fsm_one_hot_tb);
        $display("time y w Y2 Y4");
        $monitor("%0t %b %b  %b  %b", $time, y, w, Y2, Y4);

        // start values
        w = 0;
        y = 6'b000000;
        #5;

        // cycle through one-hot values on y and toggle w for each
        for (k = 0; k < 6; k = k + 1) begin
            y = (6'b000001 << k);
            w = 0; #10;
            w = 1; #10;
        end

        // some extra combinations
        y = 6'b111111; w = 0; #10;
        y = 6'b101010; w = 1; #10;

        $finish;
    end

endmodule
