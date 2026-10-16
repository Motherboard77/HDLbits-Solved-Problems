module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    
    parameter LEFT = 3'b000, RIGHT = 3'b001, DIG_L = 3'b010, DIG_R = 3'b011, FALL_L = 3'b100, FALL_R = 3'b101, SPLAT = 3'b110;
    reg [2:0] state, next_state;
    
    reg [4:0] counter;
        
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
                LEFT : begin
                    		if(ground)   //there is ground !
                        	begin
                                //ext_state = bump_left ? RIGHT : (dig ? DIG_L : LEFT ) ;
                                next_state = dig ? DIG_L : (bump_left ? RIGHT : LEFT ) ;
                        	end
                    		else
                                next_state = FALL_L;
                	   end
                RIGHT : begin
                    		if(ground)   //there is ground !
                        	begin
                                //next_state = bump_right ? LEFT : (dig ? DIG_R : RIGHT ) ;
                                next_state = dig ? DIG_R : (bump_right ? LEFT : RIGHT ) ;
                        	end
                    		else
                                next_state = FALL_R;
                		end
                DIG_L : begin
                    		next_state = ~ground ? FALL_L : DIG_L;
                		end
                DIG_R : begin
                    		next_state = ~ground ? FALL_R : DIG_R;
                		end
                FALL_L : begin
                    		if(ground)
                                next_state = (counter >= 5'd20) ? SPLAT : LEFT;
                    		else
                            next_state = FALL_L;
                		 end
                FALL_R : begin
                    		if (ground)
                                next_state = (counter >= 5'd20) ? SPLAT : RIGHT;
                			else
                    		next_state = FALL_R;
                		 end
                SPLAT : begin
                    		next_state = SPLAT; 
                		end
            endcase
        end
    
    always@(posedge clk)
        begin
            if(areset)
                counter <= 5'b000_00;
            else
                begin
                    case(state)
                        FALL_L, FALL_R : begin
                            				if (counter < 5'd30)
                            				counter <= counter + 1'b1;
                        				 end
                        default : counter <= 5'b000_00;
                    endcase
                end
        end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L) | (state == FALL_R);
    assign digging = (state == DIG_L) | (state == DIG_R) ;
    
    
endmodule
