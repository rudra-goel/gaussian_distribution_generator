library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity rom_tb is
end entity rom_tb;


architecture rtl of rom_tb is

    constant ADDR_WIDTH_c  : integer := 11;
    constant DATA_WIDTH  : integer := 32;

    signal tb_clk       : std_logic := '0';
    signal tb_addr      : std_logic_vector(ADDR_WIDTH_c-1 downto 0) := (others => '0');

    signal tb_data_out_cos  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal tb_data_out_sin  : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal sim_counter  :   integer     :=  0;

    constant SIMULATION_RUN_TIME    :   integer :=  5000;
    constant tb_clk_period   : time := 5 ns;

    component rom
        generic (
            ADDR_WIDTH  : integer   := 16;
            DATA_WIDTH  : integer   := 32;
            INIT_FILE   : string    := "init.mif"
        );
        port (
            clk       : in  std_logic;
            addr      : in  std_logic_vector(ADDR_WIDTH_c-1 downto 0);
            data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

begin

    clk_gen : process begin
        wait for tb_clk_period;
        tb_clk <= not tb_clk;
        wait for tb_clk_period;
        tb_clk <= not tb_clk;
    end process clk_gen;

    stim_proc : process (tb_clk) begin
        if rising_edge(tb_clk) then
            tb_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(tb_addr)) + 1, ADDR_WIDTH_c));
        end if;

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
                   " | ADDR: " & to_string(tb_addr) &
                   " | DATA_OUT_COS: " & to_string(tb_data_out_cos) &
                   " | DATA_OUT_SIN: " & to_string(tb_data_out_sin);
        end if;
    end process print_stats;

    terminate_sim : process (sim_counter) begin

        if (sim_counter = SIMULATION_RUN_TIME) then
            assert false report "*************Simulation Ended*************" severity failure;
        end if;
    end process terminate_sim;

        

    cos_rom: rom
        generic map (
            ADDR_WIDTH  => ADDR_WIDTH_c,
            INIT_FILE   => "cosine_lut_16bit.mif"
        )
        port map (
            clk       => tb_clk,
            addr      => tb_addr,
            data_out  => tb_data_out_cos
        );

    sin_rom: rom
        generic map (
            ADDR_WIDTH  => ADDR_WIDTH_c,
            INIT_FILE   => "sine_lut_16bit.mif"
        )
        port map (
            clk       => tb_clk,
            addr      => tb_addr,
            data_out  => tb_data_out_sin
        );

end rtl;