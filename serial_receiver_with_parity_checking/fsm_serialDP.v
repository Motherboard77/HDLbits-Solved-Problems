module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);

    // 1. Instantiation of the Parity module
    // Clear the parity block when we are in IDLE or when we hit the validation state
    wire odd;
    parity UUT (.clk(clk), .reset(reset || (state == IDLE) || (state == STOP)), .in(in), .odd(odd));

    // 2. States definition
    reg [2:0] state, next_state;
    reg [3:0] count;
    reg [7:0] temp_data;

    localparam IDLE  = 3'b000, // Wait for Start Bit (0)
               DATA  = 3'b001, // Receive 8 Data bits
               PARITY = 3'b010, // Catch the 9th bit (the parity bit)
               STOP  = 3'b011, // Verify stop bit and asset done
               ERROR = 3'b100; // Framing Error recovery state

    // 3. Sequential State Transition
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    // 4. Next State Combinational Logic
    always @(*) begin
        case (state)
            IDLE:   next_state = !in ? DATA : IDLE;
            // Loop for exactly 8 data bits (count 0 to 7)
            DATA:   next_state = (count == 4'd7) ? PARITY : DATA;
            // Always transition to the STOP bit check cycle after the parity bit
            PARITY: next_state = STOP;
            // If Stop bit is high, look ahead: next cycle could be another packet start (0) or Idle (1)
            STOP:   next_state = in ? (!in ? DATA : IDLE) : ERROR;
            // Wait in error mode until serial line rises back to idle high
            ERROR:  next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    // 5. Datapath, Bit Counters, and Data Latching
    always @(posedge clk) begin
        if (reset) begin
            count     <= 4'd0;
            temp_data <= 8'd0;
            out_byte  <= 8'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    done <= 1'b0;
                end
                
                DATA: begin
                    temp_data[count] <= in; // Shift bits cleanly into temporary register
                    count <= count + 1'b1;
                end
                
                PARITY: begin
                    count <= 4'd0; // Reset counter for the next transmission cycle
                    done <= 1'b0;
                end
                
                STOP: begin
                    // If the stop bit is valid AND the parity module returns odd==1 (valid check)
                    if (in && odd) begin
                        out_byte <= temp_data; // Securely present the payload to the external output
                        done <= 1'b1;
                    end
                end
                
                ERROR: begin
                    count <= 4'd0;
					done <= 1'b0;
                end
            endcase
        end
    end

    // 6. Fix for 'done': Continuous Assignment 
    // This removes the 1-cycle latency, forcing 'done' high immediately in the STOP state
    // only if the framing stop bit is 1 and 'odd' parity passes validation.
   // assign done = (state == STOP && in && odd);

endmodule

