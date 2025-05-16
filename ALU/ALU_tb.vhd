library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end entity;

architecture sim of ALU_tb is
  signal clk    : std_logic := '0';
  signal AC     : std_logic_vector(7 downto 0);
  signal R      : std_logic_vector(7 downto 0);
  signal OpSel  : std_logic_vector(2 downto 0);
  signal Cin    : std_logic := '0';
  signal Z      : std_logic;

  constant clk_period : time := 10 ns;

begin

  -- Clock generation
  clk_process : process
  begin
    while true loop
      clk <= '0'; wait for clk_period / 2;
      clk <= '1'; wait for clk_period / 2;
    end loop;
  end process;

  uut: entity work.ALU_Code
    port map (
      clk   => clk,
      AC    => AC,
      R     => R,
      OpSel => OpSel,
      Cin   => Cin,
      Z     => Z
    );

  stim_proc: process
  begin
    -- ADD: 40 + 30 = 70
    R     <= std_logic_vector(to_unsigned(40, 8));
    OpSel <= "000";  -- Load 40 into AC
    wait for clk_period;
    
    R     <= std_logic_vector(to_unsigned(30, 8));
    OpSel <= "000";  -- ADD 30 to AC (should now be 70)
    wait for clk_period;

    -- SUB: 70 - 20 = 50
    R     <= std_logic_vector(to_unsigned(20, 8));
    OpSel <= "001";
    wait for clk_period;

    -- AND with 0xCC
    R     <= x"CC";
    OpSel <= "010";
    wait for clk_period;

    -- OR with 0x0F
    R     <= x"0F";
    OpSel <= "011";
    wait for clk_period;

    -- NAND with 0xCC
    R     <= x"CC";
    OpSel <= "100";
    wait for clk_period;

    -- MULT with 12
    R     <= std_logic_vector(to_unsigned(12, 8));
    OpSel <= "101";
    wait for clk_period;

    -- XOR with 0x55
    R     <= x"55";
    OpSel <= "110";
    wait for clk_period;

    -- NOT AC
    R     <= (others => '0'); -- ignored
    OpSel <= "111";
    wait for clk_period;

    wait;
  end process;

end architecture;  