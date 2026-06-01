`timescale 1ns/1ps
module tb;
    reg clk = 0;
    reg reset;
    reg x;
    wire z;

    // DUT
    top_module uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Expected state tracked in the testbench
    reg [2:0] exp_state = 3'b000;
    reg [2:0] next_state;
    reg expected_z;

    task tick(input bit xin);
    begin
        x = xin;
        // calculate next expected state from current exp_state and xin
        case (exp_state)
            3'b000: next_state = (xin == 1'b1) ? 3'b001 : exp_state;
            3'b001: next_state = (xin == 1'b1) ? 3'b100 : exp_state;
            3'b010: next_state = (xin == 1'b1) ? 3'b001 : exp_state;
            3'b011: next_state = (xin == 1'b1) ? 3'b010 : 3'b001;
            3'b100: next_state = (xin == 1'b1) ? exp_state : 3'b011;
            default: next_state = 3'b000;
        endcase

        @(posedge clk);
        #1; // let signals settle
        exp_state = next_state;
        expected_z = ((exp_state[0] & exp_state[1]) == 1'b1) | (exp_state[2] == 1'b1);

        if (z !== expected_z) begin
            $display("%0t: MISMATCH x=%b exp_state=%b dut_z=%b expected_z=%b", $time, x, exp_state, z, expected_z);
        end else begin
            $display("%0t: OK       x=%b exp_state=%b dut_z=%b", $time, x, exp_state, z);
        end
    end
    endtask

    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, tb);

        // initialize
        reset = 1'b1;
        x = 1'b0;
        exp_state = 3'b000;

        // apply reset for one clock edge
        @(posedge clk);
        #1;
        $display("%0t: after reset exp_state=%b z=%b", $time, exp_state, z);
        reset = 1'b0;

        // Sequence to exercise FSM
        // From 000 -> 001 -> 100 -> 011 -> 010 -> 001
        tick(1); // go to 001
        tick(1); // go to 100
        tick(0); // go to 011
        tick(1); // go to 010
        tick(1); // go to 001
        // repeat a few patterns
        tick(0);
        tick(1);
        tick(0);

        $display("Test complete");
        #10;
        $finish;
    end
endmodule
