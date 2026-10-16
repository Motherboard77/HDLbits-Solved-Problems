module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg done); 

    
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    reg [1:0] state, next_state;
    
    always@(posedge clk)
        begin
            if(reset)
                state <= S0;
            else 
                state <= next_state;
        end
    
    //NEXT-STATE Combinational logic
    always@(*)
        begin
            case(state)
                S0 : next_state = in[3] ? S1 : S0;
                S1 : next_state = S2;   //no condition
                S2 : next_state = S0;
                default : next_state = S0;
            endcase
        end
    // State transition logic (combinational)

    always@(posedge clk)
        begin
            if(reset)
                done <= 1'b0;
            else
            	done <= (state == S2);
        end
    
    // State flip-flops (sequential)
 
    // Output logic

endmodule
