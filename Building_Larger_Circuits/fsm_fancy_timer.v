
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );

    parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110;
    reg [2:0] state, next_state;
    
    always@(posedge clk)
    begin
        if(reset)
            state <= A ;
        else
            state <= next_state;
    end
    
    reg [3:0] delay_logger; 
    reg [1:0] cnt; 
    reg [13:0] down_counter_logger; //log-in (delay_logger[3:0] + 1) * 1000 clock cycles.
    
    reg [9:0]  clk_divider_1000;
    //1101 pattern
    
    //STATE-E CONDITION
    always@(posedge clk)
      begin
          if(reset || (state != E && state != F))
              begin
              	cnt <= 2'b00;   
              	delay_logger <= 4'b00_00;
                clk_divider_1000 <= 10'd999;
              end
          else if(state == E)
              //logged into state-E
              begin
              	cnt <= cnt + 1'b1;
              	delay_logger <= {delay_logger[2:0],data}; 
              end 
          
          else if(state == F)  //decrement the data logger reg
              begin                 
                  if(clk_divider_1000 == 10'd0)			//1000-cc detected
                      begin
                          	if (delay_logger > 4'b0000) 
                          	begin
                    		delay_logger <= delay_logger - 1'b1; 
                		  	end
                          	clk_divider_1000 <= 10'd999; // Reset divider
                      end
                  else
                       clk_divider_1000 <= clk_divider_1000 - 1'b1;          
              end
      end
    
    //STATE-F condition
    always@(posedge clk)
        begin
            if(reset)
                down_counter_logger <= 14'b0000_0000_0000_00;
            else if(state == E && next_state == F)
                    begin
                        down_counter_logger <= (({delay_logger[2:0], data} + 1'b1) * 1000) - 1'b1;
                    end
            else if(state == F)
                	begin
                        if(down_counter_logger > 14'b0)
                        	down_counter_logger <= down_counter_logger - 1'b1;
                	end
        end
    
        
    always@(*)
        begin
            case(state)
                A : next_state = data ? B : A ;  //1-detect
                B : next_state = data ? C : A;   //11-detect
                C : next_state = data ? C : D;   //111-detect, stay at C, otherwise for a 110-detect goto D
                D : next_state = data ? E : A;   //1100-detect, goto A, 1101 goto E
                
                //1101-detected, log-in 4 bits
                E : next_state = (cnt == 2'b11) ? F : E; //stay in state-E till a 4-bit data is logged               
                F : next_state = (down_counter_logger == 14'b0) ? G : F ; //count-DOWN going on...               
                G : next_state = ack ? A : G ;               
                default : next_state = A ;          
            endcase
        end
    
                    assign counting = (state == F);
    				assign count = delay_logger;
    				assign done = (state == G);
endmodule
