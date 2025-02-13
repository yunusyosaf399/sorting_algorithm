module controller(  
    input wire clk,         // Clock signal
    input wire rst,         // Reset signal (active high)
    input wire start,       // Signal to initiate transition from S0 to S1
    
    // Control signals
    input wire AgtB,        // Signal for S3 to S4 transition condition
    input wire zi,          // (i == K-2)
    input wire zj,          // (j == K-1)  
    
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

   // Sequential block for state transitions and output assignments
 always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= S0;  
    end else begin   
   
        case (state)
            S0: begin
            if (start) begin
                state <= S1;
            end
            else 
                state <= S0;
            end

            S1: begin
                state <= S2;
            end

            S2: begin
                state <= S3;
            end

            S3: begin
                if (AgtB)
                    state <= S4;
                else
                    if (zj) 
                        if (zi)
                            state <= S7;  
                        else 
                            state <= S1;
                    else 
                        state <= S2;  
            end

            S4: begin
                state <= S5;
            end

            S5: begin
                state <= S6;
            end

            S6: begin
                if (zj) 
                    if (zi) 
                        state <= S7; // End condition
                    else 
                        state <= S1; // Restart loop with new `i`
                else 
                    state <= S2; // Continue with `j`
                
            end

            S7: begin
                if (start)
                    state <= S0;
                else 
                    state <= S7;
            end

            default: begin
                state <= S0;
            end
        endcase
    end
end

assign Li = (state == S0) ? 1'b1 : 1'b0;
assign Ei = (state == S0) || (state == S3 && (zj == 1) && (zi == 0)) ? 1'b1 : 1'b0;

assign EA    = (state == S1) || (state == S6) ? 1'b1 : 1'b0;
assign Lj    = (state == S1) ? 1'b1 : 1'b0;
assign Ej    = (state == S1) || (state == S3 && (zj == 0)) ? 1'b1 : 1'b0;

assign Csel  = (state == S2) || (state == S5) ? 1'b1 : 1'b0;
assign EB    = (state == S2) ? 1'b1 : 1'b0;

assign Wr    = (state == S4) || (state == S5) ? 1'b1 : 1'b0;
assign Bout  = (state == S4) ? 1'b1 : 1'b0;
assign done  = (state == S7) ? 1'b1 : 1'b0;

endmodule
