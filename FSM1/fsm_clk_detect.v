
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

    //2 states
    reg state_mon,z_reg;
    reg [1:0] w_cnt;
    reg [1:0] clk_cnt;
    
    always@(posedge clk)
        begin
            if(reset)   //system reset
                begin
                   state_mon <= 1'b0;
                end
            else
                begin
                    case(s)
                        1'b0: state_mon <= state_mon ; //hold the current state      
						1'b1: state_mon <= 1'b1;
                    endcase
                end
        end
 
 //monitor state and perform required operation
    always@(posedge clk)
    begin
        if(reset)   
                begin
                    clk_cnt <= 2'b00;
                    w_cnt <= 2'b00;
                    z_reg <= 1'b0;
                end
        else
        		begin
        			case(state_mon)
            			1'b0:   begin
                					z_reg <= 1'b0;   //maintain at 0
            	   				end
            			1'b1:  begin
                	  				//monitor clk count
                            if(clk_cnt < 2'b10)
                    				begin
                            		clk_cnt <= clk_cnt + 1'b1;
                                    w_cnt <= (w==1'b1) ? w_cnt + 1'b1 : w_cnt;
                                    z_reg <= 1'b0;
                    				end
                	  				else
                    				begin
                            		clk_cnt <= 2'b00;
                                    w_cnt <= 2'b00;
                                        z_reg <= (w_cnt + w == 2'b10 ) ? 1'b1 : 1'b0;
                        			end
                   			   end
        			endcase
                end
    end
        assign z = z_reg;
endmodule