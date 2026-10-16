module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output reg dfr
); 

    parameter A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000;   //using One-Hot encoding
    reg [3:0] state, next_state;
    reg [3:0] state_cap; 
    
    wire [4:0] signed_diff;   //hold the diff between state and state_cap
    
    assign signed_diff = state - state_cap ;  //state_cap is the current state
    
    always@(posedge clk)
        begin
            if(reset)
                state_cap <= A;
            else
            	state_cap <= state;		//1-cc delay btwn state_cap and state
        end
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                state <= A;
                end
            else
                state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                A : begin
                    	next_state = (s == 3'd1) ? B : A;
                	end
                B : begin
                    	next_state = (s == 3'd3) ? C : ((s == 3'd0) ? A : B);  
                	end
                C : begin 
                    	next_state = (s == 3'd7) ? D : ((s == 3'd1) ? B : C);     
                	end
                D : begin
                    	next_state = (s == 3'd3) ? C : D;
                	end
                default : next_state = A;
            endcase
        end

    //reg w;
    
    assign fr3 = (state == A);
    assign fr2 = (state == A) | (state == B);
    assign fr1 = (state == A) | (state == B) | (state == C);
    
   
  //  always@(*)
 //       begin
  //          if(reset)
   //             dfr <= 1'b1;
   //         else
   //       		dfr = ((signed_diff[4]) ? 1'b1 : (|signed_diff == 1'b1 ? 1'b0 : dfr)) ;
   //     end
      
    always @(posedge clk) begin
        if (reset) 
            begin
            dfr <= 1'b1; // Reset requires all 4 outputs asserted
        end 
        else 
            begin
            if (next_state < state) 
                begin
                dfr <= 1'b1; // Moving to a lower level (e.g., C to B -> 2 < 4)
            end 
                else if (next_state > state) 
                    begin
                dfr <= 1'b0; // Moving to a higher level (e.g., B to C -> 4 > 2)
            end
            // If next_state == state, dfr implicitly maintains its previous value safely
        end
    end
    
   // assign dfr = (next_state == (state >> 1'b1)) | (state == A) ; 
    
   // always@(posedge clk)
   //     begin
    	//dfr <= (state == A) | (state == B & s == 3'd0) | (state == C & s == 3'd1) | (state == D & s == 3'd3);
   //     dfr <= (state == A) | (state == B & sen_cap == 3'd0) | (state == C & sen_cap == 3'd1) | (state == D & sen_cap == 3'd3);
  //      end
    
endmodule
