module regn #(parameter N = 16) (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [N-1:0] d,
    output reg [N-1:0] q
);

    always @(*) begin  // Combinational logic (not clocked)
        if (rst)
            q = 0;
        else if (en)
            q = d; // Updates immediately when en is high
    end

endmodule
