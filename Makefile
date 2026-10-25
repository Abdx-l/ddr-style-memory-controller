test:
	mkdir -p build
	iverilog -g2012 -s tb -o build/sim rtl/ddr_controller.sv tb/memory_model.sv tb/tb.sv
	vvp build/sim
