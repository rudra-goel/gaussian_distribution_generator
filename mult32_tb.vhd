library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity mult32_tb is
end entity mult32_tb;

architecture rtl of mult32_tb is

    signal in1 : std_logic_vector(31 downto 0);
    signal in2 : std_logic_vector(31 downto 0);
    signal dout: std_logic_vector(63 downto 0);

    signal clk : std_logic := '0';

    signal sim_counter  :   integer := 0;
    
    constant SIMULATION_LIMIT   :   integer := 10;

    constant clk_period :   time    := 5 ns;


    component s32_mult is
        port (
            clk  : in std_logic;
            in1 : in std_logic_vector(31 downto 0);
            in2 : in std_logic_vector(31 downto 0);
            dout: out std_logic_vector(63 downto 0)
        );
    end component;


begin

    DUT : s32_mult
        port map (
            clk  => clk,
            in1 => in1,
            in2 => in2,
            dout => dout
        );

    clk_gen : process begin
        clk <= '0';
        wait for clk_period;
        clk <= '1';
        wait for clk_period;
    end process clk_gen;

    stim_proc : process begin

        REPORT "******************************** Starting simulation for 32-bit multiplier testbench ********************************" severity note;
        report "" severity note;
        report "" severity note;
        report "" severity note;
        -- Initialize inputs
        in1 <= (others => '0');
        in2 <= (others => '0');
        
        -- Wait for a clock cycle
        wait for clk_period * 2;

        -- Apply test vectors

        -- 1 * 2 
        in1 <= x"00000001";  -- 1
        in2 <= x"00000002";  -- 2
        wait for clk_period * 2;
        assert dout /= x"0000000000000002" report "Test passed: 1 * 2 = 2" severity note;
        
        -- 3 * 4
        in1 <= x"00000003";  -- 3
        in2 <= x"00000004";  -- 4
        wait for clk_period * 2;
        assert dout /= x"000000000000000C" report "Test passed: 3 * 4 = 12" severity note;
        
        -- -1 * -1
        in1 <= x"FFFFFFFF";  -- -1
        in2 <= x"FFFFFFFF";  -- -1
        wait for clk_period * 2;
        assert dout /= x"0000000000000001" report "Test passed: -1 * -1 = 1" severity note;

        -- -12 * -31
        in1 <= x"FFFFFFF4";  -- -12
        in2 <= x"FFFFFFE1";  -- -31
        wait for clk_period * 2;
        assert dout /= x"0000000000000174" report "Test passed: -12 * -31 = 372" severity note;

        -- -33 * 3
        in1 <= x"FFFFFFD7";  -- -41
        in2 <= x"00000003";  -- 3
        wait for clk_period * 2;
        assert dout = x"FFFFFFFFFFFFFF9D" report "Test Failed: -33 * 3 = -99" severity note;

        -- Finish simulation

        assert false report "******************************** Simulation ended for 32-bit multiplier testbench ********************************" severity failure;
    end process stim_proc;

end architecture;