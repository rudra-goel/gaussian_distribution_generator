library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;


entity rom is
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
end entity rom;

architecture rtl of rom is 
    type romtype is array(0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

    impure function initRomFromFile return romType is
        file data_file : text open read_mode is INIT_FILE;
        variable data_fileLine : line;
        variable ROM_v : romType;
        
        begin
            for I in romType'range loop
                readline(data_file, data_fileLine);
                hread(data_fileLine, ROM_v(I));
            end loop;

            return ROM_v;
    end function;

    -- Call the function defined above
    signal rom_s : romType := initRomFromFile;

    attribute rom_style : string;
    attribute rom_style of rom_s : signal is "block";

    begin

        process (clk) begin
            if rising_edge(clk) then
                data_out <=  rom_s(to_integer(unsigned(addr)));
            end if;
        end process;

end architecture rtl;