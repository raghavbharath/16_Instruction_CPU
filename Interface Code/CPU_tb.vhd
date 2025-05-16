library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_tb is
end CPU_tb;

architecture sim of CPU_tb is
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal T      : std_logic_vector(2 downto 0);
    signal micro  : std_logic_vector(5 downto 0);

    component CPU
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            T          : out std_logic_vector(2 downto 0);
            microstate : out std_logic_vector(5 downto 0)
        );
    end component;

begin
    -- Instantiate DUT
    DUT: CPU
        port map (
            clk => clk,
            reset => reset,
            T => T,
            microstate => micro
        );

    -- Clock Generation
    clk_process: process
    begin
        while now < 8000 ns loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        reset <= '1'; wait for 40 ns;
        reset <= '0'; wait for 40 ns;

        -- Allow time for all 38 microstates to be exercised via ROM
        wait for 7000 ns;
        wait;
    end process;

end sim;
