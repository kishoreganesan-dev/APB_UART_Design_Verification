
module uart_tx #(
    parameter CLKS_PER_BIT = 10
)(
    input  logic       clk,
    input  logic       reset,
    input  logic       tx_start,
    input  logic [7:0] tx_data,

    output logic       tx,
    output logic       busy
);

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;

    logic [7:0] data_reg;
    logic [2:0] bit_index;
    integer clk_count;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            data_reg  <= 8'b0;
            bit_index <= 0;
            clk_count <= 0;
        end

        else begin

            case (state)

                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (tx_start) begin
                        data_reg  <= tx_data;
                        state     <= START;
                        busy      <= 1'b1;
                        clk_count <= 0;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        bit_index <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];

                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;

                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP;
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= IDLE;
                        busy <= 1'b0;
                    end
                end

            endcase
        end
    end

endmodule
