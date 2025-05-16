library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit_tb is
end Control_Unit_tb;

architecture Behavioral of Control_Unit_tb is

    signal clk    : std_logic := '0';
    signal reset  : std_logic := '1';
    signal IR     : std_logic_vector(7 downto 0) := (others => '0');
    signal Z      : std_logic := '0';
    signal T      : std_logic_vector(2 downto 0);

    -- Instruction select outputs

    signal INOP, IAND, IOR, IXOR, INOT, INAND, IADD, IMULT: std_logic;
    signal ISUB, IJUMP, IJMPZ, IJPNZ, ILDAC, IMOVR, IMVAC, ISTAC: std_logic;

    -- Control signals
    signal ARLOAD, PCBUS, PCIN, DRBUS, TRBUS, ACBUS, RBUS, MEMBUS, BUSMEM, ARIN : std_logic;

    component Control_Unit_Code
        Port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            IR     : in  std_logic_vector(7 downto 0);
            Z      : in  std_logic;
            T      : out std_logic_vector(2 downto 0);
            INOP, IAND, IOR, IXOR, INOT, INAND, IADD, IMULT : out std_logic;
            ISUB, IJUMP, IJMPZ, IJPNZ, ILDAC, IMOVR, IMVAC, ISTAC : out std_logic;
            ARLOAD, PCBUS, PCIN, DRBUS, TRBUS, ACBUS, RBUS, MEMBUS, BUSMEM, ARIN : out std_logic
        );
    end component;

begin

    -- Clock generation (10 ns period)
    clk_process : process
    begin
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    -- Instantiate UUT
    uut: Control_Unit_Code
        port map (
            clk => clk,
            reset => reset,
            IR => IR,
            Z => Z,
            T => T,
            INOP => INOP, IAND => IAND, IOR => IOR,
            IXOR => IXOR, INOT => INOT, INAND => INAND, IADD => IADD, 
				IMULT => IMULT, ISUB => ISUB, IJUMP => IJUMP, IJMPZ => IJMPZ,
            IJPNZ => IJPNZ, ILDAC => ILDAC, IMOVR => IMOVR, IMVAC => IMVAC, ISTAC => ISTAC,
            ARLOAD => ARLOAD, PCBUS => PCBUS, PCIN => PCIN,
            DRBUS => DRBUS, TRBUS => TRBUS, ACBUS => ACBUS,
            RBUS => RBUS, MEMBUS => MEMBUS, BUSMEM => BUSMEM, ARIN => ARIN
        );

    -- Stimulus process
    stimulus : process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Set Z flag high to test conditional jumps
        Z <= '0';

        -- Loop through all 16 instruction opcodes
        for opcode in 0 to 15 loop
            IR <= std_logic_vector(to_unsigned(opcode, 8));  -- Set IR[3:0]
            wait for 80 ns;  -- Enough time to pass through T0 to T7
        end loop;

        wait;
    end process;

end Behavioral;
