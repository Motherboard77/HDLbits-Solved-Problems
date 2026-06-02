`timescale 1ns/1ps

module fsm4_tb;
    reg clk;
    reg reset;
    reg w;
    wire z;

    // Device under test
    top_module dut (
        .clk(clk),
        .reset(reset),
        .w(w),
        .z(z)
    );

    reg [5:0] expected_state;
    reg [8:0] w_sequence;
    integer i;
    reg error_found;

    initial begin
        $dumpfile("fsm4_tb.vcd");
        $dumpvars(0, fsm4_tb);

        clk = 0;
        reset = 1;
        w = 0;
        expected_state = 6'b000001; // A
        error_found = 0;
        w_sequence = 9'b011100100; // actions after reset

        #12;
        reset = 0;

        for (i = 0; i < 9; i = i + 1) begin
            w = w_sequence[8 - i];
            #10;
            expected_state = next_state(expected_state, w);
            if (z !== (expected_state[5] | expected_state[4])) begin
                $display("ERROR: cycle=%0d w=%b exp_state=%b exp_z=%b got_z=%b", i, w, expected_state, (expected_state[5] | expected_state[4]), z);
                error_found = 1;
            end else begin
                $display("cycle=%0d w=%b exp_state=%b z=%b", i, w, expected_state, z);
            end
        end

        if (!error_found) begin
            $display("TEST PASSED: FSM transitions and output z match expected behavior.");
        end
        $finish;
    end

    always #5 clk = ~clk;

    function [5:0] next_state;
        input [5:0] current;
        input w_in;
        begin
            case (current)
                6'b000001: next_state = (w_in == 1'b1) ? 6'b000010 : 6'b000001; // A -> B or A
                6'b000010: next_state = (w_in == 1'b1) ? 6'b000100 : 6'b001000; // B -> C or D
                6'b000100: next_state = (w_in == 1'b1) ? 6'b010000 : 6'b000010; // C -> E or B
                6'b001000: next_state = (w_in == 1'b1) ? 6'b100000 : 6'b000001; // D -> F or A
                6'b010000: next_state = (w_in == 1'b1) ? 6'b010000 : 6'b001000; // E -> E or D
                6'b100000: next_state = (w_in == 1'b1) ? 6'b000100 : 6'b001000; // F -> C or D
                default: next_state = 6'b000001;
            endcase
        end
    endfunction

endmodule
