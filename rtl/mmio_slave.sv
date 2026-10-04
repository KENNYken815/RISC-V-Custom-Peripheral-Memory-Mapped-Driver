module mmio_slave (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        bus_valid,
    input  logic        bus_write,
    input  logic [31:0] bus_addr,
    input  logic [31:0] bus_wdata,
    output logic [31:0] bus_rdata,
    output logic        bus_ready,
    output logic        irq
);
    logic cs;
    logic [31:0] local_addr;
    logic [31:0] accel_rdata;
    logic accel_ready;

    assign cs = bus_valid && (bus_addr[31:12] == 20'h40010);
    assign local_addr = bus_addr[11:0];

    custom_accel u_accel (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .we(bus_write),
        .addr(local_addr[7:0]),
        .wdata(bus_wdata),
        .rdata(accel_rdata),
        .ready(accel_ready),
        .irq(irq)
    );

    always_comb begin
        bus_rdata = accel_rdata;
        bus_ready = bus_valid && accel_ready;
    end
endmodule
