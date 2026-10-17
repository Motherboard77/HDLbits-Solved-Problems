module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output wire start_shifting);

    reg [2:0] state, next_state; 
    parameter RST = 3'b000, A = 3'b001, B = 3'b010, C = 3'b011, D = 3'b100;
    
    always@(*)
    begin
        case(state)
            RST : next_state = data ? A : RST;
            
            A :   next_state = data ? B : RST;
            
            B :	  next_state = ~data ? C : B;
            
            C :	  next_state = data ? D : RST;
            
            D :	  next_state = reset ? RST : D;
            default : next_state = RST;
        endcase
    end
    
    always@(posedge clk)
    begin
        if(reset)
            state <= RST;
        else
            state <= next_state;
    end
    
    assign start_shifting = (state == D) ;
    
endmodule
