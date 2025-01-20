module datapath #( 
    parameter N = 8, // Width of data
    parameter L = 4  // Width of counters and address
) (
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire Rd,            // Read signal
    input wire WrInit,        // Write initialization signal
    input wire [L-1:0] RAddr, // Read address
    input wire [N-1:0] DataIn,// Data input

    // Control signals
    input wire Wr,            // Write signal for RAM
    input wire Li,            // Load signal for counter i
    input wire Ei,            // Enable signal for counter i
    input wire Lj,            // Load signal for counter j
    input wire Ej,            // Enable signal for counter j
    input wire EA, EB,        // Enable signals for register A & B
    input wire Csel,          // Selects b/w counter i & j
    input wire Bout,          // Select b/w register A & B output
    input wire start,         // Starts execution

    output wire [N-1:0] DataOut, // Data output
    // Status signals (flags)
    output wire zi, 
    output wire zj,
    output wire AgtB
);

    // Local parameter for counter limits
    localparam K = 16;

    // Internal signals
    wire [L-1:0] cntr_i, cntr_j, mux1_out, mux2_out, Addr;
    wire [N-1:0] regA_out, regB_out, mux3_out, mux4_out, ABmux, Din, Mij;
    wire We;

    // Counter i
    counter #(.N(L)) counter_inst1 (.clk(clk), .rst(rst), .ld(Li), .en(Ei), .d({L{1'b0}}), .q(cntr_i));
    assign zi = (cntr_i == K-2);

    // Counter j
    counter #(.N(L)) counter_inst2 (.clk(clk), .rst(rst), .ld(Lj), .en(Ej), .d(cntr_i + 1), .q(cntr_j));
    assign zj = (cntr_j == K-1);

    // MUX Logic
    assign mux1_out = (Csel == 1'b0) ? cntr_i : cntr_j;
    assign mux2_out = (start == 1'b0) ? RAddr : mux1_out;
    assign mux3_out = (start == 1'b0) ? DataIn : ABmux;
    assign mux4_out = (Bout == 1'b0) ? regA_out : regB_out;

    assign Addr = mux2_out;
    assign Din = mux3_out;
    assign ABmux = mux4_out;

    // RAM (Read/Write)
    assign We = WrInit | Wr;
    RAM #(.addr_width(L), .data_width(N)) RAM_inst (.CLK(clk), .WE(We), .ADDR(Addr), .DIN(Din), .DOUT(Mij));

    // Registers A & B
    regn #(.N(N)) reg_A (.clk(clk), .rst(rst), .en(EA), .d(Mij), .q(regA_out));
    regn #(.N(N)) reg_B (.clk(clk), .rst(rst), .en(EB), .d(Mij), .q(regB_out));

    // Comparator
    assign AgtB = (regA_out > regB_out);

    // Final output
    assign DataOut = (Rd) ? Mij : {N{1'bz}};

endmodule
