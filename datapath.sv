module datapath #( 
    parameter N = 16, // Width of data
    parameter L = 4  // Width of counters and address
) (
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire start,         // Start signal
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

    output wire [N-1:0] DataOut, // Data output
    // Status signals (flags)
    output wire zi, 
    output wire zj,
    output wire AgtB
);

    // Local parameter for counter limits
    localparam K = 16;

    // Internal signals
    wire [L-1:0] cntr_i, cntr_j, mux1_out, mux2_out, addr;
    wire [N-1:0] regA_out, regB_out, mux3_out, mux4_out, ABmux, din, Mij;
    wire we;

    // Counter i
      counter #(.N(L)) counter_inst1 (
      .clk(clk), 
      .rst(rst), 
      .ld(Li), 
      .en(Ei), 
      .d({L{1'b0}}), 
      .q(cntr_i)
      );
      
      counter #(.N(L)) counter_inst2 (
        .clk(clk),
        .rst(rst),
        .ld(Lj),        // Load only when Lj is high
        .en(Ej),        // Enable to increment
        .d(cntr_i + 1), // Load j with i + 1
        .q(cntr_j)
    );

    assign zi = (cntr_i == K-2);  // i should stop at K-2
    assign zj = (cntr_j == K-1);  // j should stop at K-1

    // MUX Logic 
    assign mux1_out = (Csel == 1'b0) ? cntr_i : cntr_j; // Counter_i and Counter_j based on Csel
    assign mux2_out = (start) ? mux1_out : RAddr;       // ram address will be selected based on start signal
    assign mux3_out = (start == 1'b0) ? DataIn : ABmux;  // mux3 output selected based on start signal that input to ram 
    assign mux4_out = (Bout == 1'b0) ? regA_out : regB_out;  // Mux4 select regA and regB value based on Bout value

    
    assign addr = mux2_out;   // ram address

    assign din = mux3_out;    // ram input data from mux3_out
    assign ABmux = mux4_out;  // ABMux is output of mux4_out

    // RAM (Read/Write)
    assign we = WrInit | Wr;
    RAM #(.addr_width(L), .data_width(N)) RAM_inst (.clk(clk), .rst(rst), .we(we), .addr(addr), .din(din), .dout(Mij));

    // loading ram output to Registers A & B 
    regn #(.N(N)) reg_A (.clk(clk), .rst(rst), .en(EA), .d(Mij), .q(regA_out));
    regn #(.N(N)) reg_B (.clk(clk), .rst(rst), .en(EB), .d(Mij), .q(regB_out));

    // Comparator
    assign AgtB = (regA_out > regB_out);

    // Final output
    assign DataOut = (Rd) ? Mij : {N{1'bz}};

endmodule
