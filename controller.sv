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
   reg [4:0] state; // Current state (3 bits for up to 8 states)
 
   localparam S0 = 0,
              S1 = 1,
              S2 = 2,
              S3 = 3,
              S4 = 4,
              S5 = 5,
              S6 = 6,
              S7 = 7,
              S8 = 8,
              S9 = 9,
              S10 = 10;
              

   // Sequential block for state transitions and output assignments
   always @(posedge clk, posedge rst) begin
    if (rst) begin
        state <= S0;  
    end else begin   
   
        case (state)
            S0: begin
                if (start)
                    state <= S1;
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
                    state <= S7;
            end

            S4: begin
                state <= S5;
            end

            S5: begin
                state <= S6;
            end

            S6: begin
                state <= S7;
                
            end

            S7: begin
                if (zj)
                    if(zi) begin
                        state <= S10;
                    end
                    else begin
                        state <= S9;
                    end
                else
                    state <= S8;
            end
            
            S8: begin
                state <= S2;
            end
            
            S9: begin
                state <= S1;
            
            end
            S10: begin
                if(start)
                    state <= S0;
                else
                    state <= S10;
            end
            
            default: begin
                state <= S0;
            end
        endcase
    end
end

assign Li = (state == S0) ? 1'b1 : 1'b0;
assign Ei = (state == S0) || (state == S9) ? 1'b1: 1'b0;

assign Lj    = (state == S1) ? 1'b1 : 1'b0;
assign Ej    = (state == S1) || (state == S8) ? 1'b1 : 1'b0;

assign EA    = (state == S1) || (state == S6) ? 1'b1 : 1'b0;
assign EB    = (state == S2) ? 1'b1 : 1'b0;


assign Csel  = (state == S2) || (state == S5) ? 1'b1 : 1'b0;
assign Wr    = (state == S4) || (state == S5) ? 1'b1 : 1'b0;

assign Bout  = (state == S4) ? 1'b1 : 1'b0;
assign done  = (state == S10) ? 1'b1 : 1'b0;

endmodule