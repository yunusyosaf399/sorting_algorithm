// Datapath Module: Performs comparison and swapping
module Datapath #(parameter DATA_WIDTH = 8) (
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] data1,
    input logic [DATA_WIDTH-1:0] data2,
    output logic [DATA_WIDTH-1:0] swap_data1,
    output logic [DATA_WIDTH-1:0] swap_data2,
    output logic swap
);
    always_comb begin
        if (data1 > data2) begin
            swap = 1;
            swap_data1 = data2;
            swap_data2 = data1;
        end else begin
            swap = 0;
            swap_data1 = data1;
            swap_data2 = data2;
        end
    end
endmodule