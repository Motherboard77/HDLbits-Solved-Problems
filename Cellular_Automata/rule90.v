module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q ); 

    reg [1:0] bound_cap;
    
    always@(posedge clk)
        begin
            if(load)
                begin
                bound_cap <= 2'b00;
                q <= data;   //load the data into q
                end
            else
                q <= (q>>1) ^ (q<<1);
        end
endmodule
