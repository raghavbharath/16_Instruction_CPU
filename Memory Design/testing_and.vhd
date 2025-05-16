library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity;

architecture sim of tb is
  signal A, B, Y : std_logic;
begin
  uut: entity work.test_demo port map(A => A, B => B, Y => Y);

  stim_proc: process
  begin
    A <= '0'; B <= '0'; wait for 10 ns;
    A <= '0'; B <= '1'; wait for 10 ns;
    A <= '1'; B <= '0'; wait for 10 ns;
    A <= '1'; B <= '1'; wait for 10 ns;
    wait;
  end process;
end architecture;
