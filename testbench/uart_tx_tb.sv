
module uart_tx_tb;

    logic clk;
    logic reset;
    logic tx_start;
    logic [7:0] tx_data;
    logic tx;
    logic busy;

    uart_tx #(
        .CLKS_PER_BIT(10)
    ) dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .busy(busy)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #20;
        reset = 0;

        #20;
        tx_data = 8'h41;
        tx_start = 1;

        #10;
        tx_start = 0;

        wait(busy == 0);

        #20;
        $display("UART TX TEST COMPLETED");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | TX=%b | BUSY=%b",
                 $time, tx, busy);
    end

endmodule
