module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    
    reg input_one_flag;
    reg z_cap_reg;
    
    always@(posedge clk or posedge areset)
        begin
            if(areset)
                begin
                	//inp_cap <= 1'b0;
                	input_one_flag <= 1'b0;    //detect first 1
                	z_cap_reg <= 1'b0;   
                end
            else
                begin
                    //system not in reset
                     if(input_one_flag)
                     	begin
                     	z_cap_reg <= ~x;
                     	end
                     else
                        begin
                            if(x == 1'b1)   
                     		begin
                        	input_one_flag <= 1'b1;   //set the flag
                        	z_cap_reg <= x;   //bypass the x ,i.e 1
                            end
                        end
                end
        end
   
    always@(*)
        begin
             z <= z_cap_reg;
        end
    
endmodule