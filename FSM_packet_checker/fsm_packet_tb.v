`timescale 1ns / 1ps

module fsm_packet_tb;
    reg clk;
    reg reset;
    reg in;
    wire disc;
    wire flag;
    wire err;

    top_module uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .disc(disc),
        .flag(flag),
        .err(err)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task send_bit(input bit_value);
    begin
        in <= bit_value;
        @(posedge clk);
        #1;
    end
    endtask

    task send_sequence(input [31:0] bits, input integer length);
        integer i;
    begin
        for (i = 0; i < length; i = i + 1) begin
            send_bit(bits[i]);
        end
    end
    endtask

    initial begin
        $display("[INFO] Starting FSM packet checker testbench");
        reset = 1;
        in = 0;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        // Test 0111110 produces disc
        send_sequence(7'b0111110, 7);
        if (disc !== 1'b1 || flag !== 1'b0) begin
            $display("[FAIL] Expected disc=1 flag=0 for 0111110, got disc=%b flag=%b err=%b", disc, flag, err);
            $fatal;
        end else begin
            $display("[PASS] 0111110 detected as discard packet");
        end

        // Clear packet boundary with a 0 idle cycle
        send_bit(1'b0);

        // Test 01111110 produces flag
        send_sequence(8'b01111110, 8);
        if (flag !== 1'b1 || disc !== 1'b0) begin
            $display("[FAIL] Expected flag=1 disc=0 for 01111110, got disc=%b flag=%b err=%b", disc, flag, err);
            $fatal;
        end else begin
            $display("[PASS] 01111110 detected as flag packet");
        end

        // Clear packet boundary with a 0 idle cycle
        send_bit(1'b0);

        // Test error recovery: 011111111 then 0 should set err until the subsequent zero clears it
        send_sequence(8'b11111110, 8);
        if (err !== 1'b1) begin
            $display("[FAIL] Expected err=1 after 011111111, got err=%b", err);
            $fatal;
        end else begin
            $display("[PASS] Error state entered after too many ones");
        end

        send_bit(1'b0);
        if (err !== 1'b0) begin
            $display("[FAIL] Expected err to clear on zero after error, got err=%b", err);
            $fatal;
        end else begin
            $display("[PASS] Error state cleared on terminating zero");
        end

        // Additional random checks for no false output
        send_sequence(6'b000000, 6);
        if (disc !== 1'b0 || flag !== 1'b0) begin
            $display("[FAIL] Expected no output for six zeros, got disc=%b flag=%b err=%b", disc, flag, err);
            $fatal;
        end else begin
            $display("[PASS] No false packet detected for long zero run");
        end

        $display("[INFO] All tests passed");
        $finish;
    end

endmodule
