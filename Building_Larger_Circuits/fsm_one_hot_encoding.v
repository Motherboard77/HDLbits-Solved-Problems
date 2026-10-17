

module top_module(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,    // 10-bit one-hot current state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
); 
    
//1,2,4,8,16,32,64,128,256,512
//(S, S1, S11, S110, B0, B1, B2, B3, Count, Wait) = (10'b0000000001, 10'b0000000010, 10'b0000000100, ... , 10'b1000000000)
    
    parameter S=1, S1=2, S11=4, S110=8, B0=16, B1=32, B2=64, B3=128, Count=256, Wait=512;

    assign B3_next = state[6];
    assign S_next = (state[1] & ~d) | (state[0] & ~d) | (state[3] & ~d) | (state[9] & ack);
    assign S1_next = (state[0] & d);
    assign Count_next = state[7] | (state[8] & ~done_counting) ;
    assign Wait_next = (state[8] & done_counting) | (state[9] & ~ack) ;  
    assign done = state[9];
    assign counting = state[8];    
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

endmodule
