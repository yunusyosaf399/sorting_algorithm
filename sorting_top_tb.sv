module sorting_top_tb;

    // Parameters
    parameter N = 16; // Width of data
    parameter L = 4; // Width of counters and address

    // Testbench signals
    reg clk;
    reg rst, Rd, WrInit, start;
    reg [L-1:0] RAddr;
    reg [N-1:0] DataIn;
    wire [N-1:0] DataOut;
    wire done;

    // Predefined values
    reg [N-1:0] predefined_values [L-1:0];

    // Clock generation
    initial begin
        clk = 1;                // Initialize clock
        forever #5 clk = ~clk;  // 10 ns clock period
    end

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

    // Initialize the predefined array
    initial begin
        predefined_values[0] = 8'd45;
        predefined_values[1] = 8'd12;
        predefined_values[2] = 8'd78;
        predefined_values[3] = 8'd34;
        predefined_values[4] = 8'd56;
        predefined_values[5] = 8'd89;
        predefined_values[6] = 8'd23;
        predefined_values[7] = 8'd67;
        predefined_values[8] = 8'd44;
        predefined_values[9] = 8'd67;
        predefined_values[10]= 8'd10;
        predefined_values[11]= 8'd2;
        predefined_values[12]= 8'd9;
        predefined_values[13]= 8'd90;
        predefined_values[14]= 8'd11;
        predefined_values[15]= 8'd66;
    end

    // Task to initialize RAM with predefined values
    task initialize_ram;
        input [N-1:0] data [0:15];
        integer i;
        begin
            for (i = 0; i < 16; i = i + 1) begin
                WrInit = 1'b1;
                RAddr = i;
                DataIn = data[i];
                @(posedge clk);
                WrInit = 0;  // Ensure write is deasserted
                @(posedge clk); // Wait an extra cycle for RAM update
            end
            DataIn = 0; 
        end
    endtask


    // Task to display RAM contents after sorting
    task display_ram_contents;
        integer i;
        begin
            $display("RAM contents:");
            for (i = 0; i < 8; i = i + 1) begin
                Rd = 1'b1;
                RAddr = i;
                @(posedge clk);
                $display("RAM[%0d] = %0d", i, DataOut);
            end
            #10
            Rd = 1'b0;
        end
    endtask

    // Testbench logic
    initial begin
        // Test data for sorting
        reg [N-1:0] test_data [0:15];
        test_data[0] = 8'd45;
        test_data[1] = 8'd12;
        test_data[2] = 8'd78;
        test_data[3] = 8'd34;
        test_data[4] = 8'd56;
        test_data[5] = 8'd89;
        test_data[6] = 8'd23;
        test_data[7] = 8'd67;
        test_data[8] = 8'd44;
        test_data[9] = 8'd101;
        test_data[10] = 8'd10;
        test_data[11] = 8'd2;
        test_data[12] = 8'd9;
        test_data[13] = 8'd90;
        test_data[14] = 8'd11;
        test_data[15] = 8'd66;
        

        // Initialize signals
        rst = 1;        // Assert reset
        WrInit = 0;     // Disable write initialization
        Rd = 0;         // Disable read
        start = 0;      // Don't start the sorting yet
        RAddr = 0;      // Address 0 initially
        DataIn = 0;     // No data input yet

        // Apply reset
        repeat (2) @(posedge clk);
        rst = 0; // Deassert reset

        // Initialize RAM with predefined values
        initialize_ram(test_data);

        RAddr = 0;
        #10

        // Display RAM contents before sorting
        $display("RAM contents before sorting:");
        display_ram_contents();

        // Start sorting operation
        @(negedge clk);
        start = 1; // Set start to 1

        // Wait for sorting to complete (done signal)
        RAddr = 0;
        wait(done);
        start = 0;
        $display("Sorting completed.");

        // Display RAM contents after sorting
        $display("RAM contents after sorting:");
        display_ram_contents();

        // End simulation
        $finish;
    end

endmodule
