module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);

///Moore-Machine FSM
    reg [2:0] state;   
    localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5; 
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    state <= A;
                end
            else
                begin
                    case(state)
                        A : state <= (w==1'b1) ? A : B;
                        B : state <= (w==1'b1) ? D : C;
                        C : state <= (w==1'b1) ? D : E;
                        D : state <= (w==1'b1) ? A : F;
                        E : state <= (w==1'b1) ? D : E;
                        F : state <= (w==1'b1) ? D : C;
                        default: state <= A;
                    endcase
                end
        end
    
    //OUTPUT DEPENDENT ONLY ON CURRENT STATE
    assign z = state[2] ; //output is 1 ONLY on states E and F, E -> 100, F-> 101
    
endmodule
