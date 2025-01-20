module sorting_top #( 
    parameter N = 8, // Width of data
    parameter L = 4  // Width of counters and address
)(
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire Rd,            // Read signal
    input wire WrInit,        // Write initialization signal
    input wire [L-1:0] RAddr, // Read address
    input wire [N-1:0] DataIn,// Data input
    input wire start,         // Start execution signal

    output wire [N-1:0] DataOut, // Data output
    output wire done             // Sorting complete signal
);

    // Internal signals for control and datapath connections
    wire Wr, Li, Ei, Lj, Ej, EA, EB, Csel, Bout;
    wire zi, zj, AgtB;

    // Datapath Instance
    datapath #(.N(N), .L(L)) datapath_inst (
        .clk(clk),
        .rst(rst),
        .Rd(Rd),
        .WrInit(WrInit),
        .RAddr(RAddr),
        .DataIn(DataIn),
        .Wr(Wr),
        .Li(Li),
        .Ei(Ei),
        .Lj(Lj),
        .Ej(Ej),
        .EA(EA),
        .EB(EB),
        .Csel(Csel),
        .Bout(Bout),
        .start(start),
        .DataOut(DataOut),
        .zi(zi),
        .zj(zj),
        .AgtB(AgtB)
    );

    // Controller Instance
    controller controller_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .zi(zi),
        .zj(zj),
        .AgtB(AgtB),
        .Wr(Wr),
        .Li(Li),
        .Ei(Ei),
        .Lj(Lj),
        .Ej(Ej),
        .EA(EA),
        .EB(EB),
        .Csel(Csel),
        .Bout(Bout),
        .done(done)
    );

endmodule
