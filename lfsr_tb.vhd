library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity lfsr_tb is
end entity lfsr_tb;

architecture tb_rtl of lfsr_tb is

component galois_LFSR is 
port (
    clk_p        :   in std_logic;
    rst_p        :   in std_logic;
    seed_p       :   in std_logic_vector(7 downto 0);
    lfsr_out_p   :   out std_logic_vector(7 downto 0)
);
end component galois_LFSR;

signal tb_clk		:	std_logic	:= '0';
signal tb_rst		:	std_logic	:= '0';
signal tb_seed      :   std_logic_vector(7 downto 0);
signal tb_lfsr_out  :   std_logic_vector(7 downto 0);

signal sim_counter  :   integer     :=  0;

file output_file    :   text;

constant clk_per	:	time := 5 ns;
constant SIMULATION_RUN_TIME    :   integer :=  500;

begin
    -- DUT instantiation
    DUT : galois_LFSR
    port map (
        clk_p       => tb_clk,
        rst_p       => tb_rst,
        seed_p      => tb_seed,
        lfsr_out_p  => tb_lfsr_out
    );

    clk_gen : process begin
        wait for clk_per;
        tb_clk  <=  not(tb_clk);
        wait for clk_per;
    end process clk_gen;

    stim_proc : process begin
        
        wait for clk_per * 5;
        tb_rst <= '1';
        tb_seed <=  "00011001";
        
        wait for clk_per * 5;

        tb_rst <= '0';

        wait;

    end process stim_proc;


    simulation_counter : process (tb_clk) begin
        if rising_edge(tb_clk) then
            sim_counter <=  sim_counter + 1;
        end if;
    end process simulation_counter;

    print_stats : process (tb_clk) begin
        if rising_edge(tb_clk) then
            report "Cycle: " & integer'image(sim_counter) & 
                   " | CLK: " & std_logic'image(tb_clk) &
                   " | RST: " & std_logic'image(tb_rst) &
                   " | SEED: " & to_string(tb_seed) &
                   " | LFSR_OUT: " & to_string(tb_lfsr_out);
        end if;
    end process print_stats;

    terminate_sim : process (sim_counter) begin

        if (sim_counter = SIMULATION_RUN_TIME) then
            assert false report "*************Simulation Ended*************" severity failure;
        end if;
    end process terminate_sim;

    file_writer : process
        variable line_var   :   line;
    begin
        file_open(output_file, "lfsr_outputs.txt", write_mode);
        
        -- Wait for simulation to start
        wait until rising_edge(tb_clk);
        
        -- Write data on each rising edge
        while sim_counter < SIMULATION_RUN_TIME loop
            wait until rising_edge(tb_clk);
            write(line_var, tb_lfsr_out, right, 8);
            writeline(output_file, line_var);
        end loop;
        
        file_close(output_file);
        wait; -- Stop the process
    end process file_writer;

end architecture tb_rtl;