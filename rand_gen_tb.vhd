library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library std;
use STD.textio.all;

entity rand_gen_tb is
end entity rand_gen_tb;

architecture tb_rtl of rand_gen_tb is

component random_number_generator is
    port (
        clk : in std_logic;
        rst : in std_logic;
        seed1_p : in std_logic_vector(15 downto 0);
        seed2_p : in std_logic_vector(15 downto 0);
        trig_select_p : in std_logic;
        rand_p  : out std_logic_vector(63 downto 0)
    );
end component random_number_generator;

constant clk_per	:	time := 5 ns;
constant SIMULATION_RUN_TIME    :   integer :=  50000;

constant lfsr_width :   integer     :=  16;

signal tb_clk		:	std_logic	:= '0';
signal tb_rst		:	std_logic	:= '0';
signal tb_seed1      :   std_logic_vector(lfsr_width-1 downto 0);
signal tb_seed2      :   std_logic_vector(lfsr_width-1 downto 0);
signal rand_out  :   std_logic_vector(63 downto 0);

signal sim_counter : integer := 0;

file output_file    :   text;


begin
    -- DUT instantiation

    DUT : random_number_generator
    port map (
        clk => tb_clk,
        rst => tb_rst,
        seed1_p => tb_seed1,
        seed2_p => tb_seed2,
        trig_select_p => '0',
        rand_p => rand_out
    );

    clk_gen : process begin
        tb_clk  <=  '0';
        wait for clk_per;
        tb_clk  <=  '1';
        wait for clk_per;
    end process clk_gen;

    stim_proc : process begin
        REPORT "****************** STARTING Testbench for Random Number Generator ********************************" severity note;
        report "" severity note;
        report "" severity note;
        report "" severity note;
        
        tb_rst <= '1';
        tb_seed1 <= x"DEAD";
        tb_seed2 <= x"BEEF";
        
        wait for clk_per * 4;
        
        tb_rst <= '0';
        wait for clk_per * SIMULATION_RUN_TIME;

        report "" severity note;
        report "" severity note;
        report "" severity note;
        REPORT "****************** ENDING Testbench for Random Number Generator ********************************" severity failure;
    end process stim_proc;

    print_stats : process (tb_clk) begin
        if rising_edge(tb_clk) then
            report "Cycle: " & integer'image(sim_counter) & 
                   " | CLK: " & std_logic'image(tb_clk) &
                   " | DATA_OUT_COS: " & to_string(rand_out);
        end if;
    end process print_stats;

    sim_proc : process begin
        wait until rising_edge(tb_clk);
        sim_counter <= sim_counter + 1;
    end process sim_proc;

    file_writer : process
        variable line_var   :   line;
    begin
        file_open(output_file, "random_number_outputs.txt", write_mode);
        
        -- Wait for simulation to start
        wait until rising_edge(tb_clk);
        
        -- Write data on each rising edge
        while true loop
            wait until rising_edge(tb_clk);
            write(line_var, rand_out, right, 63);
            writeline(output_file, line_var);
        end loop;
        
        file_close(output_file);
        wait; -- Stop the process
    end process file_writer;

end architecture tb_rtl;