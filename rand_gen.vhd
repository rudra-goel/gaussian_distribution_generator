library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity random_number_generator is
    port (
        clk : in std_logic;
        rst : in std_logic;
        seed1_p : in std_logic_vector(15 downto 0);
        seed2_p : in std_logic_vector(15 downto 0);
        trig_select_p : in std_logic;
        rand_p  : out std_logic_vector(63 downto 0)
    );
end entity random_number_generator;

architecture rtl of random_number_generator is

    component fibonacci_LFSR is
        generic (
            WIDTH : integer := 8
        );
        port (
            clk_p        :   in std_logic;
            rst_p        :   in std_logic;
            seed_p       :   in std_logic_vector(WIDTH-1 downto 0);
            lfsr_out_p   :   out std_logic_vector(WIDTH-1 downto 0)
        );
    end component fibonacci_LFSR;

    component rom is
        generic (
            ADDR_WIDTH  :   integer := 16;
            DATA_WIDTH  :   integer := 32;
            INIT_FILE   :   string  := "data.mif"
        );
        port (
            clk     : in  std_logic;
            addr    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component rom;

    component s32_mult is
        port (
            clk  : in std_logic;
            in1 : in std_logic_vector(31 downto 0);
            in2 : in std_logic_vector(31 downto 0);
            dout: out std_logic_vector(63 downto 0)
        );
    end component s32_mult;

    signal u1_out_s     : std_logic_vector(15 downto 0);
    signal u1_out_reg_s : std_logic_vector(15 downto 0) := (others => '0');

    signal u2_out_s     : std_logic_vector(15 downto 0);
    signal u2_out_reg_s : std_logic_vector(15 downto 0) := (others => '0');

    signal alpha_out_s      : std_logic_vector(31 downto 0);
    signal alpha_out_reg_s  : std_logic_vector(31 downto 0)  := (others => '0');

    signal cos_out_s        : std_logic_vector(31 downto 0);
    signal cos_out_reg_s    : std_logic_vector(31 downto 0)  := (others => '0');

    signal sin_out_s        : std_logic_vector(31 downto 0);
    signal sin_out_reg_s    : std_logic_vector(31 downto 0)  := (others => '0');

    signal trig_s       : std_logic_vector(31 downto 0)  := (others => '0');

    signal product_s        : std_logic_vector(63 downto 0);
    signal product_reg_s    : std_logic_vector(63 downto 0) := (others => '0');

begin

    rand_p <= product_reg_s when rst = '0' else (others => '0');

    reg_proc : process (clk) begin
        if rising_edge(clk) then
            u1_out_reg_s <= u1_out_s;
            u2_out_reg_s <= u2_out_s;

            alpha_out_reg_s <= alpha_out_s;

            cos_out_reg_s <= cos_out_s;
            sin_out_reg_s <= sin_out_s;

            if (trig_select_p = '1') then
                trig_s <= cos_out_reg_s;
            else
                trig_s <= sin_out_reg_s;
            end if;

            product_reg_s <= product_s;

        end if;
    end process reg_proc;


    U1 : fibonacci_LFSR
    generic map (
        WIDTH => 16
    )
    port map (
        clk_p => clk,
        rst_p => rst,
        seed_p => seed1_p,
        lfsr_out_p => u1_out_s
    );

    U2 : fibonacci_LFSR
    generic map (
        WIDTH => 16
    )
    port map (
        clk_p => clk,
        rst_p => rst,
        seed_p => seed2_p,
        lfsr_out_p => u2_out_s
    );

    alpha : rom 
    generic map (
        INIT_FILE => "alpha_lut_16bit.mif"
    )
    port map (
        clk     => clk,
        addr    => u1_out_reg_s,
        data_out => alpha_out_s
    );

    cos_lut : rom
    generic map (
        INIT_FILE => "cos_lut_16bit.mif"
    )
    port map (
        clk     => clk,
        addr    => u2_out_reg_s,
        data_out => cos_out_s
    );

    sin_lut : rom
    generic map (
        INIT_FILE => "sin_lut_16bit.mif"
    )
    port map (
        clk     => clk,
        addr    => u2_out_reg_s,
        data_out => sin_out_s
    );

    mult32 : s32_mult
    port map (
        clk  => clk,
        in1  => alpha_out_reg_s,
        in2  => trig_s,
        dout => product_s
    );

end architecture;