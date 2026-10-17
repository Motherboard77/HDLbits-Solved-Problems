

module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    /* always@(posedge clk)
        begin
            if(!resetn)
                begin
                    q <= 16'b0;
                end
            else
                begin
                    q[7:0] <= byteena[0] == 1'b1 ? d[7:0] : q[7:0] ;
                    q[15:8] <= byteena[1] == 1'b1 ? d[15:8] : q[15:8] ;
                end
        end */
    
    //Optimized code
    always@(posedge clk)
        begin
            if(!resetn)
                begin
                    q <= 16'b0;
                end
            else
                begin
                    if(byteena[0]) q[7:0] <= d[7:0];
                    if(byteena[1]) q[15:8] <= d[15:8];
                end
        end
    
endmodule
