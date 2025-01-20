module regn #(parameter N = 16) ( // Parameter N defines the bit-width of the register
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal
	input wire en,
    input wire [N-1:0] d,         // Data input
    output reg [N-1:0] q          // Output
);

    // Sequential logic: Triggered on the reset or the rising edge of the clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset the output to 0
        end else if (en) begin
            q <= d; // Load the input value into the register
        end
    end

endmodule
