module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 

    reg [1:0] state;
    localparam A = 2'b00, B = 2'b01, C = 2'b10;
    
    always@(posedge clk or negedge aresetn)
        begin
            if(!aresetn)
                begin
                    state <= A;
                end
            else
                begin
                    case(state)
                        A : state <= x ? B : A; 
                        B : state <= x ? B : C;
                        C : state <= x ? B : A;
                    endcase
                end
        end
    
    assign z = (state == C) & (x == 1'b1) ; 
    
endmodule
