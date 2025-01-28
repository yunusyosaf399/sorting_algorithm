module controller (
    input wire clk,         // Clock signal
    input wire rst,         // Reset signal (active high)
    input wire start,       // Signal to initiate transition from S0 to S1
    
    // Control signals
    input wire AgtB,        // Signal for S3 to S4 transition condition
    input wire zi,          // (i == K-2)
    input wire zj,          // (j == K-1)
    
    // Control signals
    output wire Wr,         // Write signal
    output wire Li,         // Load counter i
    output wire Ei,         // Enable counter i
    output wire Lj,         // Load counter j
    output wire Ej,         // Enable counter j
    output wire EA,         // Enable register A
    output wire EB,         // Enable register B
    output wire Bout,       // Select signal to select between A & B
    output wire Csel,       // Select signal to select between i & j
    output wire done        // Execution done
);

    // State register and parameters for states
    reg [2:0] state; // Current state (3 bits for up to 8 states)

    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100,
               S5 = 3'b101,
               S6 = 3'b110,
               S7 = 3'b111;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0; // Reset to initial state
        end else begin
            case (state)
                S0: if (start) state <= S1; else state = S0;    // S0 to S1 on 'start'
                S1: state <= S2;                                // S1 to S2 unconditionally
                S2: state <= S3;                                // S2 to S3 unconditionally
                S3: if (AgtB) state <= S4;                      // S3 to S4 if AgtB == 1
                    else 
                        if (zj) 
                            if (zi)
                                state <= S7;
                            else 
                                state <= S1;
                        else
                            state <= S2;
                S4: state <= S5;                                // S4 to S5 unconditionally
                S5: state <= S6;                                // S5 to S6 unconditionally
                S6: if (zj) 
                        if (zi) 
                            state <= S7; 
                        else 
                            state <= S1;
                    else 
                        state <= S2;
                S7: if (start) state <= S0; else state <= S7;   // S7 back to S0 (optional loop)
                default: state <= S0;                           // Default state
            endcase
        end
    end
    
    // Control signal assignments
    assign Wr = ((state == S4) || (state == S5)) ? 1'b1 : 1'b0;
    assign Li = (state == S0);
    assign Ei = (state == S0) || ((state == S6) && zj && !zi);

    assign Lj = (state == S1) ? 1'b1 : 1'b0;
    assign Ej = (state == S1) || ((state == S6) && !zj);

    assign EA = (state == S1) || (state == S6);
    assign EB = (state == S2);

    assign Bout = (state == S4);
    assign Csel = (state == S2) || (state == S5);

    assign done = (state == S7);

endmodule
