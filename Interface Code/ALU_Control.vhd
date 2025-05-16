library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_ALU_Control is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        IR    : in  std_logic_vector(7 downto 0);
        R     : in  std_logic_vector(7 downto 0)  -- General-purpose register input
    );
end CPU_ALU_Control;

architecture Structural of CPU_ALU_Control is

    signal AC       : std_logic_vector(7 downto 0);
    signal Z_flag   : std_logic;
    signal OpSel    : std_logic_vector(2 downto 0);
    signal Cin      : std_logic;
    signal T        : std_logic_vector(2 downto 0);

    -- Instruction signals from decoder (optional to monitor/debug)
    signal dummy_signals : std_logic_vector(15 downto 0);
    
    -- Control signals (not fully wired unless needed)
    signal ARLOAD, PCBUS, PCIN, DRBUS, TRBUS, ACBUS, RBUS, MEMBUS, BUSMEM, ARIN : std_logic;

begin

    -- Instantiate Control Unit
    CU: entity work.Control_Unit_Code
        port map (
            clk    => clk,
            reset  => reset,
            IR     => IR,
            Z      => Z_flag,
            T      => T,
            OpSel  => OpSel,

            -- Instruction decode signals (not used here, can be observed in testbench)
            INOP   => dummy_signals(0),
            IAND   => dummy_signals(1),
            IOR    => dummy_signals(2),
            IXOR   => dummy_signals(3),
            INOT   => dummy_signals(4),
            INAND  => dummy_signals(5),
            IADD   => dummy_signals(6),
            IMULT  => dummy_signals(7),
            ISUB   => dummy_signals(8),
            IJUMP  => dummy_signals(9),
            IJMPZ  => dummy_signals(10),
            IJPNZ  => dummy_signals(11),
            ILDAC  => dummy_signals(12),
            IMOVR  => dummy_signals(13),
            IMVAC  => dummy_signals(14),
            ISTAC  => dummy_signals(15),

            -- Control signals
            ARLOAD => ARLOAD,
            PCBUS  => PCBUS,
            PCIN   => PCIN,
            DRBUS  => DRBUS,
            TRBUS  => TRBUS,
            ACBUS  => ACBUS,
            RBUS   => RBUS,
            MEMBUS => MEMBUS,
            BUSMEM => BUSMEM,
            ARIN   => ARIN
        );

    -- Set Cin based on OpSel (ADD = "000", SUB = "001")
    Cin <= '0' when OpSel = "000" else
           '1' when OpSel = "001" else
           '0';

    -- Instantiate ALU
    ALU: entity work.ALU_Code
        port map (
            clk   => clk,
            AC    => AC,
            R     => R,
            OpSel => OpSel,
            Cin   => Cin,
            Z     => Z_flag
        );

end Structural;
