library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Code is
  port (
    clk   : in  std_logic;
    AC    : out std_logic_vector(7 downto 0);
    R     : in  std_logic_vector(7 downto 0);
    OpSel : in  std_logic_vector(2 downto 0);
    Cin   : in  std_logic;
    Z     : out std_logic
  );
end ALU_Code;

architecture Behavioral of ALU_Code is

  signal AC_reg       : std_logic_vector(7 downto 0) := (others => '0');
  signal mult_result  : std_logic_vector(15 downto 0);

  function add8(A, B : std_logic_vector(7 downto 0); Cin : std_logic) return std_logic_vector is
    variable result : unsigned(8 downto 0);
    variable a_ext, b_ext : unsigned(8 downto 0);
    variable cin_ext : unsigned(8 downto 0);
  begin
    a_ext := to_unsigned(0, 1) & unsigned(A);
    b_ext := to_unsigned(0, 1) & unsigned(B);
    cin_ext := (others => '0');
    cin_ext(0) := Cin;
    result := a_ext + b_ext + cin_ext;
    return std_logic_vector(result(7 downto 0));
  end function;

  function mult8x8(A, B : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable result : unsigned(15 downto 0);
  begin
    result := unsigned(A) * unsigned(B);
    return std_logic_vector(result);
  end function;

begin

  process(clk)
  begin
    if rising_edge(clk) then
      case OpSel is
        when "000" => AC_reg <= add8(AC_reg, R, Cin);          -- ADD
        when "001" => AC_reg <= add8(AC_reg, not R, '1');      -- SUB
        when "010" => AC_reg <= AC_reg and R;                  -- AND
        when "011" => AC_reg <= AC_reg or R;                   -- OR
        when "100" => AC_reg <= not (AC_reg and R);            -- NAND
        when "101" =>                                         -- MULT with saturation
          mult_result <= mult8x8(AC_reg, R);
          if mult_result(15 downto 8) /= "00000000" then
            AC_reg <= (others => '1');  -- Clip to 255
          else
            AC_reg <= mult_result(7 downto 0);
          end if;
        when "110" => AC_reg <= AC_reg xor R;                  -- XOR
        when "111" => AC_reg <= not AC_reg;                    -- NOT
        when others => AC_reg <= (others => '0');
      end case;
    end if;
  end process;

  AC <= AC_reg;
  Z  <= '1' when AC_reg = x"00" else '0';

end Behavioral;
