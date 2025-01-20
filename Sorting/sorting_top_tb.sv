module sorting_top_tb;

    // Parameters
    parameter N = 8; // Width of data
    parameter L = 4; // Width of counters and address

    // Testbench signals
    reg clk, rst, Rd, WrInit, start;
    reg [L-1:0] RAddr;
    reg [N-1:0] DataIn;
    wire [N-1:0] DataOut;
    wire done;

    // Predefined values
    reg [N-1:0] predefined_values [7:0];

    // Clock generation
    always #5 clk = ~clk; // 10 ns clock period (100 MHz)

    // DUT instantiation
    sorting_top #(.N(N), .L(L)) sorting_top1 (
        .clk(clk),
        .rst(rst),
        .Rd(Rd),
        .WrInit(WrInit),
        .RAddr(RAddr),
        .DataIn(DataIn),
        .start(start),
        .DataOut(DataOut),
        .done(done)
    );

    // Testbench process
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        Rd = 0;
        WrInit = 0;
        start = 0;
        RAddr = 0;
        DataIn = 0;

        // Initialize the predefined array
        predefined_values[0] = 8'd45;
        predefined_values[1] = 8'd12;
        predefined_values[2] = 8'd78;
        predefined_values[3] = 8'd34;
        predefined_values[4] = 8'd56;
        predefined_values[5] = 8'd89;
        predefined_values[6] = 8'd23;
        predefined_values[7] = 8'd67;

        // Reset
        #20 rst = 0;

        // Load 8 values into memory
        WrInit = 1; // Enable write initialization
        for (integer i = 0; i < 8; i = i + 1) begin
            DataIn = predefined_values[i];
            RAddr = i;
            #10; // Wait for a clock cycle
        end
        WrInit = 0;

        // Start sorting
        start = 1;
        #10 start = 0;

        // Wait for sorting to complete
        wait(done);

        // Read sorted values
        Rd = 1; // Enable read
        RAddr = 0;
        for (integer i = 0; i < 8; i = i + 1) begin
            #10; // Wait for a clock cycle
            $display("Sorted value [%0d]: %0d", RAddr, DataOut);
            RAddr = i + 1;
        end
        Rd = 0;

        // End simulation
        $finish;
    end

endmodule
