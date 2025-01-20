// Counter Module: Generates address or loop indices
module Counter #(parameter WIDTH = 4) (
    input logic clk,
    input logic reset,
    input logic enable,
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else if (enable)
            count <= count + 1;
    end
endmodule