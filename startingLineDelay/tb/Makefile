# `make all` OR `make verilate` -> `make build` -> `make sim` -> `make waves`

TOP_MODULE=top
RTL_PATH=../.

.PHONY: all
all: clean verilate build sim waves

.PHONY: verilate
verilate: .stamp.verilate

.PHONY: build
build: obj_dir/Vtop

.PHONY: sim
sim: waveform.vcd

.PHONY: waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd

waveform.vcd: ./obj_dir/V$(TOP_MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(TOP_MODULE) +verilator+rand+reset+2

./obj_dir/V$(TOP_MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(TOP_MODULE).mk V$(TOP_MODULE)

.stamp.verilate: $(RTL_PATH)/$(TOP_MODULE).sv tb_$(TOP_MODULE).cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc -I../. $(RTL_PATH)/$(TOP_MODULE).sv --exe tb_$(TOP_MODULE).cpp
	@touch .stamp.verilate

.PHONY: lint
lint: $(RTL_PATH)/$(TOP_MODULE).sv
	verilator --lint-only -I../rtl/ $(RTL_PATH)/$(TOP_MODULE).sv

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd
