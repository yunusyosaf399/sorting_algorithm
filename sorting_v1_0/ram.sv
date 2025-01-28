module RAM #(
    parameter addr_width = 2,  // Address width (2 bits, 4 locations)
    parameter data_width = 8   // Data width (8 bits per location)
)(
    input wire clk,                     // Clock signal
    input wire rst,                     // Reset signal
    input wire we,                      // Write enable signal
    input wire [addr_width-1:0] addr,   // Address input
    input wire [data_width-1:0] din,    // Data input
    output wire [data_width-1:0] dout   // Data output
);

    // RAM memory array declaration
    reg [data_width-1:0] ram_memory [0:(2**addr_width)-1];

    // Internal register to hold the current address
    reg [addr_width-1:0] addr_reg;

    // Index for reset logic
    integer i;

    // Synchronous write and reset process
    always @(posedge clk) begin
        if (rst) begin
            // Initialize all RAM locations to 0
            for (i = 0; i < (2**addr_width); i = i + 1) begin
                ram_memory[i] <= 0;
            end
        end else if (we) begin
            ram_memory[addr] <= din; // Write data to the specified address
        end
        addr_reg <= addr;            // Update the internal address register
    end

    // Continuous assignment: Output the data from the current address
    assign dout = ram_memory[addr_reg];

endmodule
