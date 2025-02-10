module controller(  
    input wire clk,         // Clock signal
    input wire rst,         // Reset signal (active high)
    input wire start,       // Signal to initiate transition from S0 to S1
    
    // Control signals
    input wire AgtB,        // Signal for S3 to S4 transition condition
    input wire zi,          // (i == K-2)
    input wire zj,          // (j == K-1)  
    
    output reg Wr,         // Write signal
    output reg Li,         // Load counter i
    output reg Ei,         // Enable counter i
    output reg Lj,         // Load counter j
    output reg Ej,         // Enable counter j
    output reg EA,         // Enable register A
    output reg EB,         // Enable register B
    output reg Bout,       // Select signal to select between A & B
    output reg Csel,       // Select signal to select between i & j
    output reg done        // Execution done
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
           done  <= 0;
           Wr    <= 0;
           Li    <= 0;
           Ei    <= 0;
           Lj    <= 0;
           Ej    <= 0;
           EA    <= 0;
           EB    <= 0;
           Bout  <= 0;
           Csel  <= 0;
       end else begin
           // Default values to prevent latches
           done  <= 0;
           Wr    <= 0;
           Li    <= 0;
           Ei    <= 0;
           Lj    <= 0;
           Ej    <= 0;
           EA    <= 0;
           EB    <= 0;
           Bout  <= 0;
           Csel  <= 0;
   
   
         if(start == 1'b1) begin
           case (state)
             S0: begin
                 // Initialize `i` to 0
                 Li <= 1;
                 Ei <= 1; // Start counter `i`
                 state <= S1;
             end
         
             S1: begin
                 // Load `A` with `Mi`
                 EA   <= 1;
                 Csel <= 0; // Select `i`
                 Lj   <= 1;
                 Ej   <= 1; // Start counter `j`
                 state <= S2;
             end
         
             S2: begin
                 // Load `B` with `Mj`
                 EB   <= 1;
                 Csel <= 1; // Select `j`
                 state <= S3;
             end
         
             S3: begin
                 if (AgtB) 
                     state <= S4;  // If `A > B`, perform swap
                 else 
                     state <= S6;  // Otherwise, increment `j`
             end
         
             S4: begin
                 // Write `B` to `Mi`
                 Wr   <= 1;
                 Csel <= 0; // Select `i`
                 Bout <= 1; // Select `B`
                 state <= S5;
             end
         
             S5: begin
                 // Write `A` to `Mj`
                 Wr   <= 1;
                 Csel <= 1; // Select `j`
                 Bout <= 0; // Select `A`
                 state <= S6;
             end
         
             S6: begin
                 // Increment `j` or `i`
                 if (zj) begin
                     if (zi) begin
                         state <= S7; // End condition
                     end else begin
                         Ei    <= 1;  // Increment `i`
                         state <= S1; // Restart loop with new `i`
                     end
                 end else begin
                     Ej    <= 1; // Increment `j`
                     state <= S2; // Continue with `j`
                 end
             end
         
             S7: begin
                 done <= 1; // Sorting complete
             end
         
             default: begin
                 state <= S0;
             end
         endcase

       end
   end
   
   end



endmodule
