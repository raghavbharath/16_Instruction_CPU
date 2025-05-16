library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_tb is
end Register_tb;

architecture sim of Register_tb is

    component Register_Code is
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            DataBus    : inout std_logic_vector(7 downto 0); -- now inout

            ARLOAD, PCLOAD, DRLOAD, TRLOAD, IRLOAD, RLOAD, ACLOAD : in std_logic;
            AREN, PCEN, DREN, TREN, IREN, REN, ACEN               : in std_logic;

            AC_in     : in  std_logic_vector(7 downto 0);
            ALU_in    : in  std_logic_vector(7 downto 0);
            ALU_result: in  std_logic_vector(7 downto 0);

            AR : out std_logic_vector(15 downto 0);
            PC : out std_logic_vector(15 downto 0);
            DR : out std_logic_vector(7 downto 0);
            TR : out std_logic_vector(7 downto 0);
            IR : out std_logic_vector(7 downto 0);
            R  : out std_logic_vector(7 downto 0);
            AC : out std_logic_vector(7 downto 0);
            Z  : out std_logic
        );
    end component;

    signal clk, reset                          : std_logic := '0';
    signal DataBus                             : std_logic_vector(7 downto 0) := (others => 'Z');
    signal ARLOAD, PCLOAD, DRLOAD, TRLOAD     : std_logic := '0';
    signal IRLOAD, RLOAD, ACLOAD              : std_logic := '0';
    signal AREN, PCEN, DREN, TREN             : std_logic := '0';
    signal IREN, REN, ACEN                    : std_logic := '0';
    signal AC_in, ALU_in, ALU_result          : std_logic_vector(7 downto 0) := (others => '0');
    signal AR, PC                              : std_logic_vector(15 downto 0);
    signal DR, TR, R, AC                       : std_logic_vector(7 downto 0);
    signal IR                                  : std_logic_vector(7 downto 0);
    signal Z                                   : std_logic;

begin

    -- Instantiate the Register_Code module
    UUT: Register_Code
        Port Map (
            clk => clk,
            reset => reset,
            DataBus => DataBus,
            ARLOAD => ARLOAD, PCLOAD => PCLOAD, DRLOAD => DRLOAD, TRLOAD => TRLOAD,
            IRLOAD => IRLOAD, RLOAD => RLOAD, ACLOAD => ACLOAD,
            AREN => AREN, PCEN => PCEN, DREN => DREN, TREN => TREN,
            IREN => IREN, REN => REN, ACEN => ACEN,
            AC_in => AC_in,
            ALU_in => ALU_in,
            ALU_result => ALU_result,
            AR => AR,
            PC => PC,
            DR => DR,
            TR => TR,
            IR => IR,
            R => R,
            AC => AC,
            Z => Z
        );

    -- Clock generation process
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process with tri-state usage
    stim_proc: process
    begin
        reset <= '1'; wait for 20 ns;
        reset <= '0'; wait for 20 ns;

        -- Load AR
        report "Loading 0x12 into AR";
        DataBus <= x"12";
        ARLOAD <= '1'; wait for 20 ns;
        ARLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Load PC
        report "Loading 0x34 into PC";
        DataBus <= x"34";
        PCLOAD <= '1'; wait for 20 ns;
        PCLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Load DR
        report "Loading 0x56 into DR";
        DataBus <= x"56";
        DRLOAD <= '1'; wait for 20 ns;
        DRLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Load TR
        report "Loading 0x78 into TR";
        DataBus <= x"78";
        TRLOAD <= '1'; wait for 20 ns;
        TRLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Load IR
        report "Loading 0x8A into IR";
        DataBus <= x"8A";
        IRLOAD <= '1'; wait for 20 ns;
        IRLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Load R
        report "Loading 0x9C into R";
        DataBus <= x"9C";
        RLOAD <= '1'; wait for 20 ns;
        RLOAD <= '0'; DataBus <= (others => 'Z'); wait for 20 ns;

        -- Drive ALU result into AC
        report "Simulating ALU result of 0x3F into AC";
        ALU_result <= x"3F";
        ACLOAD <= '1'; wait for 20 ns;
        ACLOAD <= '0'; wait for 20 ns;

        -- Set AC to 0 to trigger Z
        report "Loading 0x00 into AC to trigger Z flag";
        ALU_result <= x"00";
        ACLOAD <= '1'; wait for 20 ns;
        ACLOAD <= '0'; wait for 20 ns;

        -- Drive R to bus for testing REN
        report "Testing REN output";
        REN <= '1'; wait for 20 ns;
        REN <= '0'; wait for 20 ns;

        wait;
    end process;

end sim;
