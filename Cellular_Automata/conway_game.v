module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q ); 
 
    //Row indexes: 0,16,32 ..
    //for 0th Row , 16 elements (0 to 15)
    //R0 (index r) ||   q[r+15 : r]  r : 0 to 240 with 16 increment (0->16->32...)
    //Column : index from 0 to 15 || c (0->1->2->3....->15)
    //  q[r+c] r(0->16->32...) c(0->1->2->...15) 
    
    integer r, c;
    //reg [3:0] row_neg_indx;
    //reg [3:0] col_neg_indx;
    
    integer up_r, down_r, left_c, right_c;
    
    reg [3:0] sum_cap;
    
    always@(posedge clk)
    begin
        if(load)
            begin
            	q <= data;
            	sum_cap <= 3'b000;
            	//row_neg_indx <= 4'b00_00;
            end
        else
            begin
                //figure out the neighbours
                //compute the indexes
                for(r = 0; r<=240; r = r + 16)    //row offsets at 0->16->...
                    begin
                        for(c=0; c<=15; c = c + 1)
                            begin
                                //compute the neigbour-cell summation
                                //row_neg_indx = (r == 0) ? 4'b1111 : r-16;
                                //col_neg_indx = (c == 0) ? 4'b1111 : c-1;
                                
                                up_r    = (r == 0)   ? 240 : r - 16;
                                down_r  = (r == 240) ? 0   : r + 16;
                                left_c  = (c == 0)   ? 15  : c - 1;
                                right_c = (c == 15)  ? 0   : c + 1;
                                
                                sum_cap = q[up_r+left_c]+q[up_r+c]+q[up_r+right_c]+q[r+left_c]+q[r+right_c]+q[down_r+left_c]+q[down_r+c]+q[down_r+right_c];
                                case(sum_cap)
                                    3'b000,3'b001 : q[r+c] <= 1'b0;
                                    3'b010 : q[r+c] <= q[r+c];
                                    3'b011 : q[r+c] <= 1'b1;
                                    3'b100 : q[r+c] <= 1'b0;
                                    default: q[r+c] <= 1'b0;
                                endcase
                            end
                    end
            end
    end
    
endmodule
