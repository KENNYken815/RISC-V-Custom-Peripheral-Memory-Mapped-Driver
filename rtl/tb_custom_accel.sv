module tb_custom_accel;
    logic clk=0, rst_n=0, valid=0, write=0;
    logic [31:0] addr=0,wdata=0,rdata; logic ready,irq;
    always #5 clk = ~clk;

    mmio_slave dut(
        .clk,.rst_n,.bus_valid(valid),.bus_write(write),
        .bus_addr(addr),.bus_wdata(wdata),.bus_rdata(rdata),
        .bus_ready(ready),.irq(irq)
    );

    task automatic wr(input [31:0] a,input [31:0] d);
        begin @(negedge clk);valid=1;write=1;addr=a;wdata=d;@(negedge clk);valid=0;write=0;end
    endtask
    task automatic rd(input [31:0] a,output [31:0] d);
        begin @(negedge clk);valid=1;write=0;addr=a;@(posedge clk);d=rdata;@(negedge clk);valid=0;end
    endtask

    logic [31:0] out;
    initial begin
        repeat(2) @(posedge clk); rst_n=1;
        wr(32'h40010010, 7);
        wr(32'h40010014, 9);
        wr(32'h40010008, 1);
        repeat(6) @(posedge clk);
        rd(32'h40010018,out);
        if(out !== 63) $fatal(1,"Expected 63, got %0d",out);
        $display("PASS: custom accelerator returned %0d",out);
        $finish;
    end
endmodule
