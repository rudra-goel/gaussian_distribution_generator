GHDL=ghdl
FLAGS="--std=08"
WORKDIR=compiled

# Default target runs LFSR testbench
all: lfsr

# LFSR testbench target
lfsr: $(WORKDIR)
	@echo "Running LFSR testbench..."
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) LFSR.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb.vhd
	@$(GHDL)	-e	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb
	@$(GHDL)	-r	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb --wave=$(WORKDIR)/lfsr_wave.ghw

# ROM testbench target
rom: $(WORKDIR)
	@echo "Running ROM testbench..."
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) rom.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) rom_tb.vhd
	@$(GHDL)	-e	$(FLAGS) --workdir=$(WORKDIR) rom_tb
	@$(GHDL)	-r	$(FLAGS) --workdir=$(WORKDIR) rom_tb --wave=$(WORKDIR)/rom_wave.ghw

# Target to run all testbenches
test-all: lfsr rom
	@echo "All testbenches completed."

$(WORKDIR):
	@mkdir -p $(WORKDIR)

clean:
	@rm -rf $(WORKDIR)

help:
	@echo "Available targets:"
	@echo "  lfsr     - Run LFSR testbench"
	@echo "  rom      - Run ROM testbench"
	@echo "  test-all - Run all testbenches"
	@echo "  clean    - Remove compiled files"
	@echo "  help     - Show this help message"

.PHONY: all lfsr rom test-all clean help
