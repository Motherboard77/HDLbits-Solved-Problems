module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
); 
    reg [2:0] state;
    
    always@(posedge clk)
    begin
        if(reset)
            begin
                state <= 3'b000;
            end
        else
            case (state)
                3'b000 : state <= (x == 1'b1) ? 3'b001 : state;
                3'b001 : state <= (x == 1'b1) ? 3'b100 : state;
                3'b010 : state <= (x == 1'b1) ? 3'b001 : state;
                3'b011 : state <= (x == 1'b1) ? 3'b010 : 3'b001;
                3'b100 : state <= (x == 1'b1) ? state : 3'b011;
            endcase
    end

    assign z = ((state[0]&state[1] == 1'b1) | (state[2] == 1'b1)) ? 1'b1 : 1'b0;
endmodule