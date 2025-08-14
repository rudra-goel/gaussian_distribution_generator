library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity s32_mult is
    port (
        clk  : in std_logic;
        in1 : in std_logic_vector(31 downto 0);
        in2 : in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(63 downto 0)
    );
end entity s32_mult;


architecture rtl of s32_mult is

    signal in1_s : signed(31 downto 0);
    signal in2_s : signed(31 downto 0);
    signal dout_s : signed(63 downto 0);
    signal dout_reg_s : signed(63 downto 0)     := (others => '0');

begin

    in1_s <= signed(in1);
    in2_s <= signed(in2);

    dout_s <= in1_s * in2_s;

    dout <= std_logic_vector(dout_s);

end architecture;