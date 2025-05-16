library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration
entity Test_demo is
    Port (
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        Y : out STD_LOGIC
    );
end Test_demo;

-- Architecture
architecture Behavioral of Test_demo is
begin
    Y <= A and B;
end Behavioral;
