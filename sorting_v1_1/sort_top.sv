// Top Module: Integrates all components
module sort_top #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4) (
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] unsorted_array [(1<<ADDR_WIDTH)-1],
    output logic [DATA_WIDTH-1:0] sorted_array [(1<<ADDR_WIDTH)-1]
);
    logic [ADDR_WIDTH-1:0] i_count, j_count;
    logic [DATA_WIDTH-1:0] data1, data2, swap_data1, swap_data2;
    logic swap, ram_we;

    RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram (
        .clk(clk),
        .addr(j_count),
        .data_in(swap ? swap_data1 : data1),
        .we(ram_we),
        .data_out(data1)
    );

    Counter #(.WIDTH(ADDR_WIDTH)) i_counter (
        .clk(clk),
        .reset(reset),
        .enable(i_enable),
        .count(i_count)
    );

    Counter #(.WIDTH(ADDR_WIDTH)) j_counter (
        .clk(clk),
        .reset(reset),
        .enable(j_enable),
        .count(j_count)
    );

    Datapath #(.DATA_WIDTH(DATA_WIDTH)) datapath (
        .clk(clk),
        .reset(reset),
        .data1(data1),
        .data2(data2),
        .swap_data1(swap_data1),
        .swap_data2(swap_data2),
        .swap(swap)
    );

    Controller controller (
        .clk(clk),
        .reset(reset),
        .i_count(i_count),
        .j_count(j_count),
        .swap(swap),
        .i_enable(i_enable),
        .j_enable(j_enable),
        .ram_we(ram_we),
        .done(done)
    );

    always_ff @(posedge clk) begin
        if (done) begin
            for (int i = 0; i < (1<<ADDR_WIDTH); i++)
                sorted_array[i] <= ram.mem[i];
        end
    end
endmodule
