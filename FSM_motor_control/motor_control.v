module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
    ); 

    reg flag_g_val;
    reg [2:0] state;    //FSM states
    reg [2:0] inp_cap;
    reg [1:0] y_check;
    reg [2:0] clk_cnt;
    
    localparam A = 3'b000, B = 3'b001, C = 3'b010, D= 3'b011, E = 3'b100, E1 = 3'b101, E0 = 3'b110;
    
    always@(posedge clk)
        begin
            if(!resetn)      //ACTIVE-LOW reset
                begin
                    state <= A;
                    //g <= 1'b0;
                    inp_cap <= 3'b000;
                    y_check <= 2'b00;
                    clk_cnt <= 3'b001;
                end
            else
                begin
                    case(state)
                        A :  state <= (resetn == 1'b1) ? B : A;
                        B :	 state <= C;							//stay here for 1-cc
                        C : begin
                            	if(clk_cnt < 3'b100)                    // 1->2->3   
                                begin
                                    clk_cnt <= clk_cnt + 1'b1;
                                    //implement a shift-REG
                                    inp_cap[2] <= inp_cap[1];
                                    inp_cap[1] <= inp_cap[0];
                                    inp_cap[0] <= x;
                                    	if(flag_g_val)   //101 detected
                                            begin
                                            clk_cnt <= 3'b001;
                                        	state <= D;
                                            
                                            end
                                    	else
                                        state <= C;
                                end
                            	else
                                begin
                                    //clk has maxed-out to 3'b100
                                    clk_cnt <= 3'b001;
                                    inp_cap[2] <= inp_cap[1];
                                    inp_cap[1] <= inp_cap[0];
                                    inp_cap[0] <= x;
                                    	if(flag_g_val)   //101 detected
                                        begin
											clk_cnt <= 3'b001;
                                            state <= D;
                                        end
                                    	else
                                        state <= C;
                                end
                        	end
                        D : state <= y ? E1 : E;			//hold g=1 here
                        E : state <= y ? E1 : E0;			//hold g=1 here
                                
                        E1 : begin
                            	if(!resetn)
                                begin
                                //flag_g_val <= 1'b0;
                                //y_check <= 2'b00;    
                                state <= A;
                                end
                            	else
                                state <= E1;
                           	 end
                        E0 : begin
                            	if(!resetn)
                                begin
                                //flag_g_val <= 1'b0;
                                //y_check <= 2'b00;    
                                state <= A;
                                end
                            	else
                                state <= E0;
                           	end

                    endcase
                end
        end
    						always@(*)
                                begin
                                    flag_g_val = (state == C) ? ({inp_cap[1:0], x} == 3'b101 ? 1'b1 : 1'b0) : 1'b0;
                                    //flag_g_val = (state == C) ? ((!(|(inp_cap^3'b101)) == 1'b1) ? 1'b1 : 1'b0) : 1'b0;   //101 match detector
                                end
                            
    assign f = (state == B) ? 1'b1 : 1'b0;                       
    assign g =  (state == D) | (state == E) | (state == E1) ;
endmodule
