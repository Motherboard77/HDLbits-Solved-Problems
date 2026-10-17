

module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] ff_out;
    
    //capture-phase
    always@(posedge clk)
        begin
    		ff_out <= in;         
        end
    
    //detect-phase
    always@(posedge clk)
        begin
            anyedge <= (in & ~ff_out) | (~in & ff_out) ;  //either a (0->1 detect) or (1->0 detect) 
        end
    
endmodule
