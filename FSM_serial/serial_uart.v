module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 

    reg [2:0] state, next_state;
    reg [3:0] count;
    reg flag;
    localparam A = 3'b000, B = 3'b001, C = 3'b010, E = 3'b100;
 
    always@(posedge clk)
        begin
            if(reset)
                begin
                    state <= A;
                end
            else
                state <= next_state;
        end
    
    always@(*)      												//state-based combinational assignment 
        begin
            case(state)
           		A : begin
                    next_state = !in ? B : A;
                	end
                B : next_state = (count == 4'd8) ? C : B;               
                C : next_state = in ? A : E;						//check for the STOP-bit
                E : next_state = in ? A : E;
            endcase
        end
   
    always@(posedge clk)     //state-based sequential assignement 
        begin
            case(state)
                A : begin 
                    	count <= 4'b0001;
                    	done <= 1'b0;
                	end
                B : count <= count + 1'b1;               
                C : begin
                    count <= 4'b0001;
                    done <= in;
                	end
                E : begin
                    	count <= 4'b0001;
                	end
            endcase
        end
    
endmodule
