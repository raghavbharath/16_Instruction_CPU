library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_ALU_Control_tb is
end CPU_ALU_Control_tb;

architecture behavior of CPU_ALU_Control_tb is

    -- Component under test
    component CPU_ALU_Control
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            IR    : in  std_logic_vector(7 downto 0);
            R     : in  std_logic_vector(7 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    signal IR    : std_logic_vector(7 downto 0) := (others => '0');
    signal R     : std_logic_vector(7 downto 0) := "00001111";  -- Example data

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate CPU
    uut: CPU_ALU_Control
        port map (
            clk   => clk,
            reset => reset,
            IR    => IR,
            R     => R
        );

    -- Clock process
    clk_process : process
    begin
        while now < 400 ns loop  -- Enough time for 38+ cycles
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        wait for 20 ns;
        reset <= '0';

        -- FETCH1–FETCH3
        IR <= "00000000"; wait for clk_period;
        IR <= "00000000"; wait for clk_period;
        IR <= "00000000"; wait for clk_period;

        -- Execute all 16 instructions (IR changes once per instruction)
        IR <= "00000000"; wait for clk_period;  -- INOP
        IR <= "00000001"; wait for clk_period;  -- IAND
        IR <= "00000010"; wait for clk_period;  -- IOR
        IR <= "00000011"; wait for clk_period;  -- IXOR
        IR <= "00000100"; wait for clk_period;  -- INOT
        IR <= "00000101"; wait for clk_period;  -- INAND
        IR <= "00000110"; wait for clk_period;  -- IADD
        IR <= "00000111"; wait for clk_period;  -- IMULT
        IR <= "00001000"; wait for clk_period;  -- ISUB

        IR <= "00001001"; wait for clk_period * 3;  -- IJUMP
        IR <= "00001010"; wait for clk_period * 4;  -- IJMPZ
        IR <= "00001011"; wait for clk_period * 4;  -- IJPNZ
        IR <= "00001100"; wait for clk_period * 5;  -- ILDAC
        IR <= "00001101"; wait for clk_period;      -- IMOVR
        IR <= "00001110"; wait for clk_period;      -- IMVAC
        IR <= "00001111"; wait for clk_period * 5;  -- ISTAC

        wait;
    end process;

end behavior;
