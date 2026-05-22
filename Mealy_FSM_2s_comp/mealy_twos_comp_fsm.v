module top_module (
    input clk,
    input areset,
    input x,
    output wire z
); 
    
//moore updates state first, then in the next clock cycle, updates value OR perform operation WITHIN THAT particular state
//mealy updates do not wait for state update, output changes if input changes and current state, MAYBE AFTER that , 
//the state is updated
    
    reg state;
   
    always@(posedge clk or posedge areset)
        begin
            if(areset)
                begin
                    state <= 1'b0;
                end
            else
                //not in reset, update state based on x-value
                begin
                    case(state)
                        1'b1: state <= state;    //hold the state at "1" 
                        1'b0: state <= x;
                    endcase
                end
        end
  
    //assign z = z_state;
    assign z = ~state&x | state&(~x);	//op depend on CURRENT inp and state
    
endmodule