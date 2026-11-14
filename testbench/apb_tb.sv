
module apb_tb;

    logic PCLK, PRESETn;
    logic PSEL, PENABLE, PWRITE;
    logic [7:0] PADDR, PWDATA;
    logic [7:0] PRDATA;
    logic PREADY;

    apb_slave dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    task apb_write(input logic [7:0] addr,
                   input logic [7:0] data);
        begin
            @(negedge PCLK);
            PSEL = 1;
            PENABLE = 0;
            PWRITE = 1;
            PADDR = addr;
            PWDATA = data;

            @(negedge PCLK);
            PENABLE = 1;

            @(negedge PCLK);
            PSEL = 0;
            PENABLE = 0;
        end
    endtask

    task apb_read(input logic [7:0] addr);
        begin
            @(negedge PCLK);
            PSEL = 1;
            PENABLE = 0;
            PWRITE = 0;
            PADDR = addr;

            @(negedge PCLK);
            PENABLE = 1;

            @(negedge PCLK);
            $display("Address = %h, Read Data = %h",
                     addr, PRDATA);

            PSEL = 0;
            PENABLE = 0;
        end
    endtask

    initial begin
        PRESETn = 0;
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 0;
        PWDATA = 0;

        #12;
        PRESETn = 1;

        apb_write(8'h00, 8'h55);
        apb_write(8'h01, 8'hAA);

        apb_read(8'h00);
        apb_read(8'h01);

        #10;
        $finish;
    end

endmodule
