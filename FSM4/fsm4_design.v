module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    input w,
    output z
);

    parameter state_no = 6;
    wire [state_no-1:0] state;
	//use a ONE-HOT Encoding for the state assignment
    //call a module to generate the next-state 
    
    //one_hot_nxt_state_GEN(clk,reset,w,state);     
    
    //one-hot encoding for NEXT-STATE
    one_hot_nxt_state_GEN #(.state_no(6)) u_nxt_state (.clk(clk),.reset(reset),.w(w),.one_hot_encoded(state));
    
    assign z = state[5] | state[4] ; 
    
endmodule


module one_hot_nxt_state_GEN #(parameter state_no = 6)(clk,reset,w,one_hot_encoded);
    input clk;
    input reset,w;
    output [state_no-1:0] one_hot_encoded;
    
    reg [state_no-1:0] state;
    localparam A = 6'd1, B = 6'd2, C = 6'd4, D = 6'd8, E = 6'd16, F = 6'd32;   //ONE-HOT state ENCODING
    
    always@(posedge clk)
        begin
            if(reset)
                begin
                    state <= A;    //000001
                end
            else
                begin
                    case(state)
                        A : state <= (w == 1'b1) ? (state << 1) :  state; 
                        B : state <= (w == 1'b1) ? (state << 1) : (state << 2);
                        C : state <= (w == 1'b1) ? (state << 2) : (state << 1);                
                        D : state <= (w == 1'b1) ? (state << 2) : (state >> 3);
                        E : state <= (w == 1'b1) ?  state : (state >> 1);
                        F : state <= (w == 1'b1) ? (state >> 3) : (state >> 2);
                    endcase
                end
        end
    
    assign one_hot_encoded = state;
endmodule