

module top_module (
    input clk,
    input x,
    output z
); 
    
   /* wire [2:0] w_out;
    
    d_ff D_FF1(.clk(clk), .d(x^w_out[0]), .q(w_out[0]));
    d_ff D_FF2(.clk(clk), .d(x&w_out[1]), .q(w_out[1]));
    d_ff D_FF3(.clk(clk), .d(x|w_out[2]), .q(w_out[2]));
    
    assign z = ~(|w_out); 
endmodule

module d_ff(input clk, input d, output reg q);
    always@(posedge clk)
        begin
            q <= d;
        end */
    
    
    reg [2:0] w_out;
    
    always@(posedge clk)
        begin
            w_out[0] <= x ^ w_out[0];
            w_out[1] <= x & ~w_out[1];
            w_out[2] <= x | ~w_out[2];
        end
    
    assign z = ~(|w_out);
    
endmodule
