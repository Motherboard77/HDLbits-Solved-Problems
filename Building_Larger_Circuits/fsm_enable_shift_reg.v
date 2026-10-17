module top_module (
    input clk,
    input reset,      // Synchronous reset
    output reg shift_ena);

    reg [4:0] tracker;
    
    always@(posedge clk)
    begin
        if(reset)
            //initialize the tracker with this val
            tracker <= 5'b00_001;
        else if(tracker[4])
            tracker <= tracker ; //hold this state
        else 
            tracker <= tracker << 1'b1; 
    end
    
           assign shift_ena = (tracker[4] == 1'b0);

    
endmodule
