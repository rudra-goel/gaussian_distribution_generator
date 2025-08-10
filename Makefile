GHDL=ghdl
FLAGS="--std=08"
WORKDIR=compiled

all: $(WORKDIR)
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb.vhd
	@$(GHDL)	-a	$(FLAGS) --workdir=$(WORKDIR) LFSR.vhd
	@$(GHDL)	-e	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb
	@$(GHDL)	-r	$(FLAGS) --workdir=$(WORKDIR) lfsr_tb --wave=$(WORKDIR)/wave.ghw

$(WORKDIR):
	@mkdir -p $(WORKDIR)

clean:
	@rm -rf $(WORKDIR)

.PHONY: all clean
