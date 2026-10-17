

module top_module (
    input clk,
    input d,
    output q
);
    //use a 2-bt dual-reg
    
    reg [1:0] clk_edge_cap = 2'b00;
    
    always@(posedge clk)
        begin
            clk_edge_cap[0] <= d; 
        end
    
    always@(negedge clk)
        begin
            clk_edge_cap[1] <= d;
        end
    
 
    assign q = clk ? clk_edge_cap[0] : clk_edge_cap[1];
	//wire w;
    //assign w = clk & d | ~clk & d;
    

endmodule
