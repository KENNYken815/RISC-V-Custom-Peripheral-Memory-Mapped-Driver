CC ?= cc
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -O2
BUILD := build
.PHONY: all demo test rtl-test clean
all: demo test
$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/demo: software/src/main.c software/src/custom_accel.c software/include/custom_accel.h | $(BUILD)
	$(CC) $(CFLAGS) -DACCEL_SIM -Isoftware/include software/src/main.c software/src/custom_accel.c -o $@
$(BUILD)/test_driver: tests/test_driver.c software/src/custom_accel.c | $(BUILD)
	$(CC) $(CFLAGS) -DACCEL_SIM -Isoftware/include tests/test_driver.c software/src/custom_accel.c -o $@
demo: $(BUILD)/demo
	./$(BUILD)/demo
test: $(BUILD)/test_driver
	./$(BUILD)/test_driver
rtl-test:
	iverilog -g2012 -s tb_custom_accel -o $(BUILD)/rtl_tb rtl/custom_accel.sv rtl/mmio_slave.sv rtl/tb_custom_accel.sv && vvp $(BUILD)/rtl_tb
clean:
	rm -rf $(BUILD)
