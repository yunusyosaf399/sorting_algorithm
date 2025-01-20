module counter #(
    parameter N = 4 // Bit-width of the counter
)(
    input wire clk,
    input wire rst,
    input wire ld,        // Load signal
    input wire en,        // Enable signal
    input wire [N-1:0] d, // Load data
    output reg [N-1:0] q  // Counter value
);

   always @(posedge clk) begin
    if (rst) begin
        q <= 0; // Ensure counters are reset properly
    end else begin
        if (ld) begin
            q <= d; // Load the input value into the counter
        end else if (en) begin
            q <= q + 1; // Increment the counter when enabled
        end
    end
end
endmodule
