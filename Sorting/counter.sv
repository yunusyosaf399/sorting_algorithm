module counter #(parameter N = 2) ( // Parameter N defines the bit-width of the counter
    input wire clk,       // Clock signal
    input wire rst,       // Reset signal
    input wire ld,        // Load signal
    input wire en,        // Enable signal
    input wire [N-1:0] d, // Data input for loading
    output reg [N-1:0] q  // Counter output
);

    // Internal signal to hold the counter value
    reg [N-1:0] count;

    // Sequential logic: Triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            count <= 0; // Reset the counter to 0
        end else begin
            if (ld) begin
                count <= d; // Load the input value into the counter
            end else if (en) begin
                count <= count + 1; // Increment the counter when enabled
            end
        end
    end

	// output assignment 
	assign q = count;
endmodule
