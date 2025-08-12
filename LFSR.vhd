library IEEE;
use IEEE.std_logic_1164.all;

entity fibonacci_LFSR is
generic (
    WIDTH : integer := 8
);
port (
    clk_p        :   in std_logic;
    rst_p        :   in std_logic;
    seed_p       :   in std_logic_vector(WIDTH-1 downto 0);
    lfsr_out_p   :   out std_logic_vector(WIDTH-1 downto 0)
);
end entity fibonacci_LFSR;

architecture rtl of fibonacci_LFSR is

signal lfsr_s       :   std_logic_vector(WIDTH-1 downto 0);
signal lfsr_reg_s   :   std_logic_vector(WIDTH-1 downto 0)    :=  (others => '0');
signal gen_bit_s    :   std_logic;

begin

seed_proc : process (lfsr_reg_s, rst_p) begin
    if (rst_p = '1') then
        lfsr_s <= seed_p;
        gen_bit_s <= '0';
    else
        lfsr_s <= lfsr_reg_s;
        gen_bit_s   <= lfsr_reg_s(31) xor (lfsr_reg_s(21) xor (lfsr_reg_s(2) xor (lfsr_reg_s(1) xor lfsr_reg_s(0))));
    end if;
end process seed_proc;


reg_proc : process (clk_p) begin 

    if rising_edge(clk_p) then
        lfsr_reg_s <= gen_bit_s & lfsr_s(WIDTH-1 downto 1);
    end if;

end process reg_proc;

lfsr_out_p <= lfsr_reg_s;

end architecture rtl;