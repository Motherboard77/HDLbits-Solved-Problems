module top_module (
    input clk,
    input reset,
    output reg [9:0] q);

    always@(posedge clk)
        begin
            if(reset | q == 10'd999)
                q <= 10'b0000_0000_00;
            else
                q <= q + 1'b1;
        end
    
endmodule
