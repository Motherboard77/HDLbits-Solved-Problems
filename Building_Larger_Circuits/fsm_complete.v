
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );

    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110, H = 3'b111;
    reg [2:0] state, next_state;
    
    always@(posedge clk)
    begin
        if(reset)
            state <= A;
        else
            state <= next_state;
    end
       
    reg [1:0] cc_count;
   
    always@(posedge clk)
        begin
            if(state == E)  //increment the counter 
                cc_count <= cc_count + 1'b1;
            else
                cc_count <= 1'b0;
        end
    
    always@(*)
    begin
        case(state)
            A : next_state = data ? B : A;    //1 detected
            B : next_state = data ? C : A;	  //11 detected
            C : next_state = data ? C : D;	  //111 -> stay in C, if 110 goto D
            D : next_state = data ? E : A;	  //1100 -> totally breaks! goto A, else 1101 goto E
            
            //1101 detected, stay here for 4-cc
            E : next_state = (cc_count == 2'b11) ? F : E ; //stay in this state for 4 clock cycles
            F : next_state = done_counting ? G : F ; //asserts its counting output , wait for input done_counting 
            G : next_state = ack ? A : G ; //waits for ack, assert done in this state
        endcase
    end
  
    assign shift_ena = (state == E);   
    assign counting = (state == F);
    assign done = (state == G);
                
endmodule
