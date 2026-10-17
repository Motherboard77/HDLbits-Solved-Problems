

module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);

    wire mux_sel;
    assign mux_sel = L ? r_in : q_in;
    
    always@(posedge clk)
        begin
            Q <= mux_sel;
        end
    
endmodule
