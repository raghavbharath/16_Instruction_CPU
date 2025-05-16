library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wallace_tree_multiplier is
    Port (
        A   : in  STD_LOGIC_VECTOR(7 downto 0);
        B   : in  STD_LOGIC_VECTOR(7 downto 0);
        P   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end wallace_tree_multiplier;

architecture Behavioral of wallace_tree_multiplier is

    type partial_array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal PP : partial_array;

    signal S1, C1 : STD_LOGIC_VECTOR(15 downto 0);
    signal S2, C2 : STD_LOGIC_VECTOR(15 downto 0);
    signal S3, C3 : STD_LOGIC_VECTOR(15 downto 0);

    function ShiftLeft(input: STD_LOGIC_VECTOR; amount: integer) return STD_LOGIC_VECTOR is
        variable result : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    begin
        for i in 0 to input'length - 1 loop
            if i + amount < 16 then
                result(i + amount) := input(i);
            end if;
        end loop;
        return result;
    end;

begin
    -- Generate Partial Products
    gen_pp: for i in 0 to 7 generate
        PP(i) <= ShiftLeft((others => '0') & (A and (B(i) & B(i) & B(i) & B(i) & B(i) & B(i) & B(i) & B(i))), i);
    end generate;

    -- Wallace Tree Layer 1
    S1 <= PP(0) xor PP(1) xor PP(2);
    C1 <= (PP(0) and PP(1)) or (PP(1) and PP(2)) or (PP(0) and PP(2));

    -- Wallace Tree Layer 2
    S2 <= S1 xor PP(3) xor PP(4);
    C2 <= (S1 and PP(3)) or (PP(3) and PP(4)) or (S1 and PP(4));

    -- Wallace Tree Layer 3
    S3 <= S2 xor PP(5) xor PP(6);
    C3 <= (S2 and PP(5)) or (PP(5) and PP(6)) or (S2 and PP(6));

    -- Final Addition (S3 + PP(7) + Carry Chain)
    process(S3, C1, C2, C3, PP)
        variable temp_result : STD_LOGIC_VECTOR(15 downto 0);
    begin
        temp_result := S3 + PP(7) + C1 + C2 + C3;
        P <= temp_result;
    end process;

end Behavioral;
