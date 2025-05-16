library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        T         : out std_logic_vector(2 downto 0);
        microstate: out std_logic_vector(5 downto 0)
    );
end CPU;

architecture Behavioral of CPU is
    signal T_internal : std_logic_vector(2 downto 0);
    signal microstate_internal : std_logic_vector(5 downto 0);

    signal DataBus  : std_logic_vector(7 downto 0);
    signal AC_result: std_logic_vector(7 downto 0);
    signal R_bus    : std_logic_vector(7 downto 0);
    signal AC_val   : std_logic_vector(7 downto 0);
    signal Z_flag   : std_logic;

    signal IR_opcode : std_logic_vector(7 downto 0);
    signal PC_out, AR_out : std_logic_vector(15 downto 0);
    signal addr : std_logic_vector(7 downto 0);
    signal rom_out, ram_out : std_logic_vector(7 downto 0);

    -- Control Signals
    signal ARLOAD, PCLOAD, DRLOAD, TRLOAD, IRLOAD, RLOAD, ACLOAD : std_logic;
    signal AREN, PCEN, DREN, TREN, IREN, REN, ACEN : std_logic;
    signal MEMBUS, BUSMEM : std_logic;
    signal PCINC : std_logic;
    signal OpSel : std_logic_vector(2 downto 0);
    signal readEn, writeEn : std_logic;

begin

    -- Instruction ROM
    InstROM: entity work.Instruction_ROM
        port map (
            addr     => std_logic_vector(AR_out(7 downto 0)),
            data_out => rom_out
        );

    -- Data Memory
    DataRAM: entity work.Data_Memory
        port map (
            clk      => clk,
            addr     => std_logic_vector(AR_out(7 downto 0)),
            data_in  => DataBus,
            writeEn  => BUSMEM,
            readEn   => MEMBUS,
            data_out => ram_out
        );

    -- Multiplex memory into DataBus
    DataBus <= rom_out when MEMBUS = '1' and IRLOAD = '1' else
               ram_out when MEMBUS = '1' else
               (others => 'Z');

    -- Register File
    Regs: entity work.Register_Code
        port map (
            clk        => clk,
            reset      => reset,
            DataBus    => DataBus,
            ARLOAD     => ARLOAD,
            PCLOAD     => PCLOAD,
            DRLOAD     => DRLOAD,
            TRLOAD     => TRLOAD,
            IRLOAD     => IRLOAD,
            RLOAD      => RLOAD,
            ACLOAD     => ACLOAD,
            AREN       => AREN,
            PCEN       => PCEN,
            DREN       => DREN,
            TREN       => TREN,
            IREN       => IREN,
            REN        => REN,
            ACEN       => ACEN,
            AC_in      => AC_val,
            ALU_in     => R_bus,
            ALU_result => AC_result,
            AR         => AR_out,
            PC         => PC_out,
            DR         => open,
            TR         => open,
            IR         => IR_opcode,
            R          => R_bus,
            AC         => AC_val,
            Z          => Z_flag
        );

    -- ALU
    ALU_Core: entity work.ALU_Code
        port map (
            clk   => clk,
            AC    => AC_result,
            R     => R_bus,
            OpSel => OpSel,
            Cin   => '0',
            Z     => Z_flag
        );

    -- Control Unit
    Control_Inst: entity work.Control_Unit_Code
        port map (
            clk    => clk,
            reset  => reset,
            IR     => IR_opcode,
            Z      => Z_flag,
            T      => T_internal,
            OpSel  => OpSel,
            INOP   => open, IAND => open, IOR => open, IXOR => open, INOT => open,
            INAND  => open, IADD => open, IMULT => open, ISUB => open,
            IJUMP  => open, IJMPZ => open, IJPNZ => open, ILDAC => open,
            IMOVR  => open, IMVAC => open, ISTAC => open,
            ARLOAD => ARLOAD,
            PCBUS  => open, PCIN => PCINC,
            DRBUS  => open, TRBUS => open,
            ACBUS  => open, RBUS => open,
            MEMBUS => MEMBUS,
            BUSMEM => BUSMEM,
            ARIN   => open
        );

    T <= T_internal;
    microstate <= microstate_internal;

end Behavioral;
