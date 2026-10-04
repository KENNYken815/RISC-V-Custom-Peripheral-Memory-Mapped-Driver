module custom_accel #(
    parameter ADDR_WIDTH = 8
) (
    input  logic              clk,
    input  logic              rst_n,
    input  logic              cs,
    input  logic              we,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [31:0]       wdata,
    output logic [31:0]       rdata,
    output logic              ready,
    output logic              irq
);
    localparam STATUS_ADDR = 8'h04;
    localparam CTRL_ADDR   = 8'h08;
    localparam IN0_ADDR    = 8'h10;
    localparam IN1_ADDR    = 8'h14;
    localparam OUT_ADDR    = 8'h18;

    logic busy;
    logic done;
    logic [31:0] in0_reg, in1_reg, result_reg;
    logic [1:0]  latency;

    always_comb begin
        rdata = 32'h0;
        unique case (addr)
            STATUS_ADDR: rdata = {30'h0, done, busy};
            CTRL_ADDR:   rdata = 32'h0000_0001;
            IN0_ADDR:    rdata = in0_reg;
            IN1_ADDR:    rdata = in1_reg;
            OUT_ADDR:    rdata = result_reg;
            default:     rdata = 32'h0;
        endcase
    end

    assign ready = cs;
    assign irq = done;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy      <= 1'b0;
            done      <= 1'b0;
            in0_reg   <= 32'h0;
            in1_reg   <= 32'h0;
            result_reg<= 32'h0;
            latency   <= 2'd0;
        end else begin
            done <= 1'b0;
            if (cs && we) begin
                case (addr)
                    IN0_ADDR: in0_reg <= wdata;
                    IN1_ADDR: in1_reg <= wdata;
                    CTRL_ADDR: begin
                        if (wdata[0] && !busy) begin
                            busy <= 1'b1;
                            latency <= 2'd2;
                        end
                    end
                    default: ;
                endcase
            end
            if (busy) begin
                if (latency == 0) begin
                    result_reg <= in0_reg * in1_reg;
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    latency <= latency - 1'b1;
                end
            end
        end
    end
endmodule
