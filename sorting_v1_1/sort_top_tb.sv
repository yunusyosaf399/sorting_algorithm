module sort_top_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    // Inputs
    logic clk;
    logic reset;
    logic [DATA_WIDTH-1:0] unsorted_array [(1<<ADDR_WIDTH)-1:0];

    // Outputs
    logic [DATA_WIDTH-1:0] sorted_array [(1<<ADDR_WIDTH)-1:0];

    // Instantiate the DUT (Device Under Test)
    sort_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .unsorted_array(unsorted_array),
        .sorted_array(sorted_array)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    // Stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        unsorted_array[0] = 8'd5;
        unsorted_array[1] = 8'd3;
        unsorted_array[2] = 8'd8;
        unsorted_array[3] = 8'd6;
        unsorted_array[4] = 8'd2;
        unsorted_array[5] = 8'd4;
        unsorted_array[6] = 8'd7;
        unsorted_array[7] = 8'd1;

        // Reset DUT
        reset = 1;
        #10;
        reset = 0;
        
        // Wait for sorting to complete
        #1000; // You may need to adjust this for the specific simulation time

        // Check sorted array
        $display("Sorted Array: ");
        for (int i = 0; i < (1<<ADDR_WIDTH); i++) begin
            $display("sorted_array[%0d] = %0d", i, sorted_array[i]);
        end

        // Finish simulation
        $finish;
    end

    // Optional: Monitor the internal signals (if needed)
    initial begin
        $monitor("clk = %b, reset = %b, sorted_array[0] = %d", clk, reset, sorted_array[0]);
    end
endmodule
