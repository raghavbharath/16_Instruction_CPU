library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_ROM is
    Port (
        addr     : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end Instruction_ROM;

architecture Behavioral of Instruction_ROM is
    type rom_type is array (0 to 255) of std_logic_vector(7 downto 0);
    signal ROM : rom_type := (
        0  => x"0C",  -- LDAC (load AC from 1100H)
        1  => x"01",  -- AND
        2  => x"02",  -- OR
        3  => x"03",  -- XOR
        4  => x"04",  -- NOT
        5  => x"05",  -- NAND
        6  => x"06",  -- ADD
        7  => x"08",  -- SUB
        8  => x"07",  -- MULT
        9  => x"0D",  -- MOVR
        10 => x"0E",  -- MVAC
        11 => x"0F",  -- STAC
        12 => x"09",  -- JUMP to 0014
        13 => x"0A",  -- JMPZ
        14 => x"0B",  -- JPNZ
        15 => x"00",  -- NOP
        others => x"00"
    );
begin
    data_out <= ROM(to_integer(unsigned(addr)));
end Behavioral;
