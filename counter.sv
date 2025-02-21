module counter #(parameter N = 4) (
    input wire clk,
    input wire rst,
    input wire ld,    // Load signal
    input wire en,    // Enable signal
    input wire [N-1:0] d, // Data input for loading
    output reg [N-1:0] q  // Counter output
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;
        else if (ld)
            q <= d;  // Load value when `ld` is high
        else if (en)
            q <= q + 1;  // Increment when `en` is high
    end
endmodule
