module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
	reg [2:0] state, next_state;
    reg [3:0] count;
    reg [7:0] data_acc;
    reg flag;
    localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
 
    always@(posedge clk)
        begin
            if(reset)
                begin
                    state <= A;
                end
            else
                state <= next_state;
        end
    
    always@(*)      //state-based combinational assignment 
        begin
            case(state)
           		A : begin
                    next_state = !in ? B : A;
                	end
                B : begin
                    next_state = (count == 4'd8) ? C : B; 
                	end
                C : next_state = in ? A : E;					//check for the STOP-bit
                //D : next_state = A;								//done state
                E : next_state = in ? A : E;
            endcase
        end
   
    always@(posedge clk)     //state-based sequential assignement 
        begin
            case(state)
                A : begin 
                    	count <= 4'b0001;
                    	done <= 1'b0;
                    	data_acc <= 8'b0000_0000;
                	end
                B : begin
                    data_acc[count-1] <= in;
                    count <= count + 1'b1;
                	end
                //C,E : done <= in;                 
                C : begin
                    count <= 4'b0001;
                    done <= in;
                    out_byte <= data_acc;
                	end
                E : begin
                    	count <= 4'b0001;
                    //done <= in;
                	end
            endcase
        end


    
    //assign done = (state == D) ;
    // New: Datapath to latch input bits.

endmodule
