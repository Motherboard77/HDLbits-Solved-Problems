

module top_module (
    input clk,
    input w, R, E, L,
    output reg Q
);

    wire frst_stage_mux_out,scnd_stage_mux_out;
    
    assign frst_stage_mux_out = E ? w : Q;
    assign scnd_stage_mux_out = L ? R : frst_stage_mux_out;
    
    always@(posedge clk)
        begin
            Q <= scnd_stage_mux_out;
        end
endmodule
