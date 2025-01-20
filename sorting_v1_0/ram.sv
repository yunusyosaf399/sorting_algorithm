module RAM #(
    parameter addr_width = 2,  // Address width (2 bits, 4 locations)
    parameter data_width = 8  // Data width (8 bits per location)
)(
    input wire [addr_width-1:0] ADDR,   // Address input
    input wire [data_width-1:0] DIN,    // Data input
    input wire WE,                      // Write enable signal
    input wire CLK,                     // Clock signal
    output wire [data_width-1:0] DOUT   // Data output
);

    // RAM memory array declaration
    reg [data_width-1:0] ram_memory [0:(2**addr_width)-1];

    // Internal register to hold the current address
    reg [addr_width-1:0] addr_reg;

    // Synchronous write process
    always @(posedge CLK) begin
        if (WE) begin
            ram_memory[ADDR] <= DIN; // Write data to the specified address
        end
        addr_reg <= ADDR;            // Update the internal address register
    end

    // Continuous assignment: Output the data from the current address
    assign DOUT = ram_memory[addr_reg];

endmodule
