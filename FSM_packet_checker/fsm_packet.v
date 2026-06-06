module top_module(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [3:0] one_cnt;

    always @(posedge clk) 
        begin

        
            if (reset) 
                begin
            	one_cnt <= 4'd0;
            	disc <= 1'b0;
            	flag <= 1'b0;
            	err  <= 1'b0;
        		end
        		else begin

            	// default pulse outputs
            	disc <= 1'b0;
            	flag <= 1'b0;

            	if (err) begin
                // Stay in error until a zero arrives

                	if (!in) begin
                    err <= 1'b0;
                    one_cnt <= 4'd0;
                	end
            	end
            	else begin

                if (in) begin

                    // count consecutive 1's
                    one_cnt <= one_cnt + 1'b1;

                    // entering error state
                    if (one_cnt == 4'd6)
                        err <= 1'b1;

                end
                else begin

                    // terminating zero received

                    case (one_cnt)

                        4'd5: disc <= 1'b1;   // 0111110

                        4'd6: flag <= 1'b1;   // 01111110

                        default: ;

                    endcase

                    one_cnt <= 4'd0;
                end
            end
        end
    end

endmodule