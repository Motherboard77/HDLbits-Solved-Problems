module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);

    reg [2:0] Y;

    //state toggler
     
  /*  always@(posedge clk)
    begin
        case({y,x})
            4'b0000 : Y <= 3'b000;
			4'b0001 : Y <= 3'b001;
            4'b0010 : Y <= 3'b001;
			4'b0011 : Y <= 3'b100;
            4'b0100 : Y <= 3'b010;
            4'b0101 : Y <= 3'b001;
            4'b0110 : Y <= 3'b001;
            4'b0111 : Y <= 3'b010;
            4'b1000 : Y <= 3'b011;
			4'b1001 : Y <= 3'b100;
            default : Y <= 3'b001;
        endcase
    end   */
      
    assign Y0 = y[2]&(~y[1])&(~y[0])&(~x) | (~y[2]& ~y[0] & x) | ~y[2]&y[0]& ~x ;
    //assign Y0 = Y[0];
    assign z = ( (y[0]&y[1]) | y[2]); 
endmodule
