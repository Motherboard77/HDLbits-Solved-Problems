
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Alip Majumdar
// 
// Create Date: 31.05.2026 14:36:43
// Design Name: 
// Module Name: reg_update_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Consider a finite state machine with inputs s and w. Assume that the FSM begins in a reset state called A, as depicted below. The FSM remains in state A as long as s = 0, and it moves to state B when s = 1. 
//Once in state B the FSM examines the value of the input w in the next three clock cycles. If w = 1 in exactly two of these clock cycles, then the FSM has to set an output z to 1 in the following clock cycle. 
//Otherwise z has to be 0. The FSM continues checking w for the next three clock cycles, and so on. 

//MODULE WORKING: 
//////////////////////////////////////////////////////////////////////////////////

module reg_update_test(clock,reset,w,out, clk_cnt_out, w_cnt_out);

input clock,reset;
input w;             // check w value 
output wire out;

//test signals
output wire [1:0] clk_cnt_out;
output wire [1:0] w_cnt_out;

reg [1:0] clk_cnt;
reg [1:0] w_cnt;
reg out_reg;
//TEST: 3-pulse counter 

assign clk_cnt_out = clk_cnt;
assign w_cnt_out = w_cnt;


always@(posedge clock)
begin
        if(reset)
        begin
            clk_cnt <= 2'b00;
            w_cnt   <= 2'b00; 
        end
        else
        begin
            if(clk_cnt < 2'b11) 
            begin
            if(w == 1'b1)               //check for w = 1
                    begin
                    w_cnt <= w_cnt + 1'b1;
                    end
            else
                    begin
                    w_cnt <= w_cnt;         //hold the data
                    end
            clk_cnt <= clk_cnt + 1'b1;
        end
        else
            begin                           //clk_cnt = 2'b11
                clk_cnt <= 2'b01;
                //resetting to 0 or 1 here, depends on the "w" value, at this clk-edge, if w is set to 1, 
                //there is no point "resetting it to 0" as this "new-value" needs a count-up, so in this particular case, we reset it to 1 and not 0
                w_cnt <= (w == 1'b1 ) ? 2'b01 : 2'b00; 
            end
    end
end

always @(posedge clock)
begin
    if(reset)
    begin
        out_reg <= 1'b0;
    end
    else
    begin
        out_reg <= (clk_cnt == 2'b11 ) ? ((w_cnt == 2'b10) ? 1'b1 : 1'b0) : 1'b0;
    end
end

assign out = out_reg;
endmodule
