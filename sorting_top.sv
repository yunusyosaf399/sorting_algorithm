module sorting_top #(
    parameter N = 16,
    parameter L = 4
)(
    input wire clk,
    input wire rst,
    input wire Rd,
    input wire WrInit,
    input wire [L-1:0] RAddr,
    input wire [N-1:0] DataIn,
    input wire start,
    output wire [N-1:0] DataOut,
    output wire done
);

    wire Wr, Li, Ei, Lj, Ej, EA, EB, Csel, Bout;
    wire zi, zj, AgtB;
    
     controller ctrl (
           .clk(clk), .rst(rst), .start(start), .AgtB(AgtB), .zi(zi), .zj(zj),
           .Wr(Wr), .Li(Li), .Ei(Ei), .Lj(Lj), .Ej(Ej), .EA(EA), .EB(EB), .Bout(Bout), .Csel(Csel), .done(done)
       );

    datapath #(.N(N), .L(L)) dp (
        .clk(clk), .rst(rst), .start(start), .Rd(Rd), .WrInit(WrInit), .RAddr(RAddr), .DataIn(DataIn),
        .Wr(Wr), .Li(Li), .Ei(Ei), .Lj(Lj), .Ej(Ej), .EA(EA), .EB(EB), .Csel(Csel), .Bout(Bout),
        .DataOut(DataOut), .zi(zi), .zj(zj), .AgtB(AgtB)
    );
endmodule
