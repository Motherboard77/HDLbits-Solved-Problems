

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] inp_cap;
    
    //capture inp
    always@(posedge clk)
        begin
            inp_cap <= in;
        end
    
    always@(posedge clk)
        begin
            if(reset) 
                begin
               		out <= 32'b0;     
                end
            else
                begin
                    out <= out | (~in & inp_cap) ; // 1->0 detect OR remains at OUT
                end
        end
    
endmodule
