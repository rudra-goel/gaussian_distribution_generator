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

# 32-bit multiplier testbench target
mult32: $(WORKDIR)
	@echo "Running 32-bit multiplier testbench..."
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) mult32.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) mult32_tb.vhd
	@$(GHDL)	-e	$(FLAGS) --workdir=$(WORKDIR) mult32_tb
	@$(GHDL)	-r	$(FLAGS) --workdir=$(WORKDIR) mult32_tb --wave=$(WORKDIR)/mult32_wave.ghw

# Random number generator testbench target
rand_gen: $(WORKDIR)
	@echo "Running random number generator testbench..."
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) LFSR.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) rom.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) mult32.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) rand_gen.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) rand_gen_tb.vhd
	@$(GHDL)	-e	$(FLAGS) --workdir=$(WORKDIR) rand_gen_tb
	@$(GHDL)	-r	$(FLAGS) --workdir=$(WORKDIR) rand_gen_tb --wave=$(WORKDIR)/rand_gen_wave.ghw

# Target to run all testbenches
test-all: lfsr rom mult32 rand_gen
	@echo "All testbenches completed."

$(WORKDIR):
	@mkdir -p $(WORKDIR)

clean:
	@rm -rf $(WORKDIR)

help:
	@echo "Available targets:"
	@echo "  lfsr     - Run LFSR testbench"
	@echo "  rom      - Run ROM testbench"
	@echo "  mult32   - Run 32-bit multiplier testbench"
	@echo "  rand_gen - Run random number generator testbench"
	@echo "  test-all - Run all testbenches"
	@echo "  clean    - Remove compiled files"
	@echo "  help     - Show this help message"

.PHONY: all lfsr rom mult32 rand_gen test-all clean help
