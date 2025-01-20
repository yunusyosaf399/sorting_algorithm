// Controller Module: Controls the sorting process
module Controller (
    input logic clk,
    input logic reset,
    input logic [3:0] i_count,
    input logic [3:0] j_count,
    input logic swap,
    output logic i_enable,
    output logic j_enable,
    output logic ram_we,
    output logic done
);
    parameter N = 8; // Array size

    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        COMPARE,
        SWAP
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        i_enable = 0;
        j_enable = 0;
        ram_we = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (!reset)
                    next_state = LOAD;
            end

            LOAD: begin
                i_enable = 1;
                if (i_count < N-1)
                    next_state = COMPARE;
                else
                    done = 1;
            end

            COMPARE: begin
                j_enable = 1;
                if (swap)
                    next_state = SWAP;
                else if (j_count < N-i_count-1)
                    next_state = COMPARE;
                else
                    next_state = LOAD;
            end

            SWAP: begin
                ram_we = 1;
                next_state = COMPARE;
            end
        endcase
    end
endmodule