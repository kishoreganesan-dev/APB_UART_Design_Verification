
module apb_slave (
    input  logic       PCLK,
    input  logic       PRESETn,
    input  logic       PSEL,
    input  logic       PENABLE,
    input  logic       PWRITE,
    input  logic [7:0] PADDR,
    input  logic [7:0] PWDATA,

    output logic [7:0] PRDATA,
    output logic       PREADY
);

    logic [7:0] reg0;
    logic [7:0] reg1;

    assign PREADY = 1'b1;

    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg0 <= 8'h00;
            reg1 <= 8'h00;
        end
        else if (PSEL && PENABLE && PWRITE) begin
            case (PADDR)
                8'h00: reg0 <= PWDATA;
                8'h01: reg1 <= PWDATA;
                default: ;
            endcase
        end
    end

    always_comb begin
        case (PADDR)
            8'h00:   PRDATA = reg0;
            8'h01:   PRDATA = reg1;
            default: PRDATA = 8'h00;
        endcase
    end

endmodule