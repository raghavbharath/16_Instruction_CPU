library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    Port (
        clk     : in  std_logic;
        addr    : in  std_logic_vector(7 downto 0);
        data_in : in  std_logic_vector(7 downto 0);
        writeEn : in  std_logic;
        readEn  : in  std_logic;
        data_out: out std_logic_vector(7 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is
    type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (
        16#10# => x"00",  -- LDAC low byte
        16#11# => x"11",  -- LDAC high byte
        16#12# => x"02",  -- STAC low byte
        16#13# => x"11",  -- STAC high byte
        16#14# => x"14",  -- JUMP low
        16#15# => x"00",  -- JUMP high
        16#16# => x"16",  -- JMPZ low
        16#17# => x"00",  -- JMPZ high
        16#18# => x"18",  -- JPNZ low
        16#19# => x"00",  -- JPNZ high
        others => x"00"
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if writeEn = '1' then
                RAM(to_integer(unsigned(addr))) <= data_in;
            end if;
        end if;
    end process;

    data_out <= RAM(to_integer(unsigned(addr))) when readEn = '1' else (others => 'Z');
end Behavioral;
