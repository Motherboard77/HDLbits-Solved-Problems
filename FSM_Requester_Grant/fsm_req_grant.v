module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 

    reg [1:0] state;
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    wire [3:1] req_dec;
    
    req_priority_schedule UUT(r,req_dec);
    
    always@(posedge clk)
        begin
            if(!resetn)    //ACTIVE-LOW
                begin
                    state <= A;
                end
            else
                begin
                    case(state)
                        A : begin
                            	if(req_dec == 3'b000)
                                state <= A;
                            	else if(req_dec[1] == 1'b1)
                                state <= B;
                            	else if(req_dec[2] == 1'b1)
                                state <= C;
                            	else if(req_dec[3] == 1'b1)
                                state <= D;
                            	else
                                state <= state;
                        	end
                        B : state <= (r[1] == 1'b1) ? B : A;
                        C : state <= (r[2] == 1'b1) ? C : A;
                        D : state <= (r[3] == 1'b1) ? D : A;
                    endcase
                end
        end
    
    assign g[1] = (state == B) ? 1'b1: 1'b0;
    assign g[2] = (state == C) ? 1'b1: 1'b0;
    assign g[3] = (state == D) ? 1'b1: 1'b0;
        
endmodule

							module req_priority_schedule(req,req_decode);     //request decoder
                                input [3:1] req;
                                output wire [3:1] req_decode;
                                
                                wire w = |req;        //1 bit 0/1 check    							   
                              	assign req_decode = (!w == 1'b1) ? 3'b000 : (~req + 1'b1) & req; 

                            endmodule
                            