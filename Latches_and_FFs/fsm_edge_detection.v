

module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] ff_out;
    
    //for edge detector , use 2-phase method: 1) delay phase to hold the previous input vector for comparison
    always@(posedge clk)
        begin
			ff_out <= in;
          end
    
    //2) detection phase , compare the prev input vector with current input 
    always@(posedge clk)
        begin
    		pedge <= in & ~ff_out;   //0 -> 1 detector
        end
endmodule
