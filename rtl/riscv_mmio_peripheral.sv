module riscv_mmio_peripheral (
    input logic clk, input logic rst_n,
    input logic mem_valid, input logic mem_write,
    input logic [31:0] mem_addr, input logic [31:0] mem_wdata,
    output logic [31:0] mem_rdata, output logic mem_ready,
    output logic interrupt
);
    mmio_slave u_mmio (
        .clk(clk), .rst_n(rst_n),
        .bus_valid(mem_valid), .bus_write(mem_write),
        .bus_addr(mem_addr), .bus_wdata(mem_wdata),
        .bus_rdata(mem_rdata), .bus_ready(mem_ready),
        .irq(interrupt)
    );
endmodule
