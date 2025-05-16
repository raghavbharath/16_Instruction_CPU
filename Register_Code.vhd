library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_Code is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        DataBus    : inout std_logic_vector(7 downto 0); -- Tri-state data bus

        -- Load signals
        ARLOAD, PCLOAD, DRLOAD, TRLOAD, IRLOAD, RLOAD, ACLOAD : in std_logic;

        -- Output enables
        AREN, PCEN, DREN, TREN, IREN, REN, ACEN : in std_logic;

        -- ALU inputs and result
        AC_in     : in  std_logic_vector(7 downto 0);
        ALU_in    : in  std_logic_vector(7 downto 0);
        ALU_result: in  std_logic_vector(7 downto 0);

        -- Outputs
        AR : out std_logic_vector(15 downto 0);
        PC : out std_logic_vector(15 downto 0);
        DR : out std_logic_vector(7 downto 0);
        TR : out std_logic_vector(7 downto 0);
        IR : out std_logic_vector(7 downto 0);
        R  : out std_logic_vector(7 downto 0);
        AC : out std_logic_vector(7 downto 0);
        Z  : out std_logic
    );
end Register_Code;

architecture Behavioral of Register_Code is

    signal AR_reg : std_logic_vector(15 downto 0);
    signal PC_reg : std_logic_vector(15 downto 0);
    signal DR_reg : std_logic_vector(7 downto 0);
    signal TR_reg : std_logic_vector(7 downto 0);
    signal IR_reg : std_logic_vector(7 downto 0);
    signal R_reg  : std_logic_vector(7 downto 0);
    signal AC_reg : std_logic_vector(7 downto 0);

begin

    -- Register update logic
    process(clk, reset)
    begin
        if reset = '1' then
            AR_reg <= (others => '0');
            PC_reg <= (others => '0');
            DR_reg <= (others => '0');
            TR_reg <= (others => '0');
            IR_reg <= (others => '0');
            R_reg  <= (others => '0');
            AC_reg <= (others => '0');
        elsif rising_edge(clk) then
            if ARLOAD = '1' then
                AR_reg <= std_logic_vector(resize(unsigned(DataBus), 16));
            end if;
            if PCLOAD = '1' then
                PC_reg <= std_logic_vector(resize(unsigned(DataBus), 16));
            end if;
            if DRLOAD = '1' then
                DR_reg <= DataBus;
            end if;
            if TRLOAD = '1' then
                TR_reg <= DataBus;
            end if;
            if IRLOAD = '1' then
                IR_reg <= DataBus;
            end if;
            if RLOAD = '1' then
                R_reg <= DataBus;
            end if;
            if ACLOAD = '1' then
                AC_reg <= ALU_result;
            end if;
        end if;
    end process;

    -- Tri-state outputs to the shared DataBus
    DataBus <= AR_reg(7 downto 0) when AREN = '1' else
               PC_reg(7 downto 0) when PCEN = '1' else
               DR_reg             when DREN = '1' else
               TR_reg             when TREN = '1' else
               IR_reg             when IREN = '1' else
               R_reg              when REN  = '1' else
               AC_reg             when ACEN = '1' else
               (others => 'Z');

    -- Outputs for observation
    AR <= AR_reg;
    PC <= PC_reg;
    DR <= DR_reg;
    TR <= TR_reg;
    IR <= IR_reg;
    R  <= R_reg;
    AC <= AC_reg;

    -- Zero flag logic
    Z <= '1' when AC_reg = x"00" else '0';

end Behavioral;
