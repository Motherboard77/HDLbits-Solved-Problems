module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    //walking state is only updated when I HAVE THE HIGH GROUND
    parameter LEFT = 2'b00, RIGHT = 2'b01, FALL_LEFT = 2'b10, FALL_RIGHT = 2'b11 ;
    reg [1:0] state,next_state;
    
    always@(posedge clk or posedge areset)
        begin
            if(areset)
                state <= LEFT;
            else
                state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                LEFT :  begin
                    		if(ground)
                                begin
                                    next_state = bump_left ? RIGHT : LEFT;
                                end
                    		else
                                	next_state = FALL_LEFT;
                	    end
                RIGHT : begin
                    		if(ground)
                                begin
                                    next_state = bump_right ? LEFT : RIGHT;
                                end
                    		else
                                	next_state = FALL_RIGHT;
                	    end
                FALL_LEFT : begin
                    			next_state = ground ? LEFT : FALL_LEFT;
                			end
                FALL_RIGHT : begin
                    			next_state = ground ? RIGHT : FALL_RIGHT; 
                			 end
                default : next_state = LEFT;
            endcase
        end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) | (state == FALL_RIGHT);
    
endmodule
