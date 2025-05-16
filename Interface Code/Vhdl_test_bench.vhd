library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_wallace_tree_multiplier is
end tb_wallace_tree_multiplier;

architecture behavior of tb_wallace_tree_multiplier is

    -- Component declaration of the Unit Under Test (UUT)
    component wallace_tree_multiplier
        Port (
            A : in  STD_LOGIC_VECTOR(7 downto 0);
            B : in  STD_LOGIC_VECTOR(7 downto 0);
            P : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal A : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal B : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal P : STD_LOGIC_VECTOR(15 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: wallace_tree_multiplier port map (
        A => A,
        B => B,
        P => P
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: 5 * 3 = 15
        A <= "00000101";  -- 5
        B <= "00000011";  -- 3
        wait for 20 ns;

        -- Test 2: 12 * 7 = 84
        A <= "00001100";  -- 12
        B <= "00000111";  -- 7
        wait for 20 ns;

        -- Test 3: 255 * 255 = 65025
        A <= "11111111";
        B <= "11111111";
        wait for 20 ns;

        -- Test 4: 0 * 100 = 0
        A <= "00000000";
        B <= "01100100";  -- 100
        wait for 20 ns;

        -- Test 5: 128 * 2 = 256
        A <= "10000000";
        B <= "00000010";
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end behavior;
