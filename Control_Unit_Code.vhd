--==================================================
-- Final Fixed Control Unit with Internal Decoder Signals
--==================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit_Code is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        IR     : in  std_logic_vector(7 downto 0);
        Z      : in  std_logic;
        T      : out std_logic_vector(2 downto 0);

			-- ALU Operation Select
        OpSel  : out std_logic_vector(2 downto 0);
		  
        -- Instruction select outputs (from 4:16 decoder)
        INOP, IAND, IOR, IXOR, INOT, INAND, 
        IADD, IMULT, ISUB, IJUMP, IJMPZ, IJPNZ, ILDAC, IMOVR, IMVAC, ISTAC : out std_logic;

        -- Control signals
        ARLOAD, PCBUS, PCIN, DRBUS, TRBUS, ACBUS, RBUS, MEMBUS, BUSMEM, ARIN : out std_logic
    );
end Control_Unit_Code;

architecture Behavioral of Control_Unit_Code is
    signal t_count : unsigned(2 downto 0) := "000";
    signal T_internal : std_logic_vector(2 downto 0);
    signal decoder_output : std_logic_vector(15 downto 0);
    signal enable_decoder : std_logic;

    -- Internal instruction select signals
    signal s_INOP, s_IAND, s_IOR, s_IXOR, s_INOT, s_INAND,
           s_IADD, s_IMULT, s_ISUB, s_IJUMP, s_IJMPZ, s_IJPNZ,
           s_ILDAC, s_IMOVR, s_IMVAC, s_ISTAC : std_logic;
begin

    -- Time counter: T0 to T7
    process(clk, reset)
    begin
        if reset = '1' then
            t_count <= (others => '0');
        elsif rising_edge(clk) then
            if t_count = "111" then
                t_count <= (others => '0');
            else
                t_count <= t_count + 1;
            end if;
        end if;
    end process;

    T_internal <= std_logic_vector(t_count);
    T <= T_internal;

    -- Enable decoder when IR[7:4] = 0000
    enable_decoder <= not (IR(7) or IR(6) or IR(5) or IR(4));

    -- Valid 4:16 decoder process (avoids multiple drivers)
    process(IR, enable_decoder)
    begin
        decoder_output <= (others => '0');
        if enable_decoder = '1' then
            case IR(3 downto 0) is
                when "0000" => decoder_output(0)  <= '1';  -- INOP
                when "0001" => decoder_output(1)  <= '1';  -- IAND
                when "0010" => decoder_output(2)  <= '1';  -- IOR
                when "0011" => decoder_output(3)  <= '1';  -- IXOR
                when "0100" => decoder_output(4)  <= '1';  -- INOT
                when "0101" => decoder_output(5)  <= '1';  -- INAND
                when "0110" => decoder_output(6)  <= '1';  -- IADD
                when "0111" => decoder_output(7)  <= '1';  -- IMULT
                when "1000" => decoder_output(8)  <= '1';  -- ISUB
                when "1001" => decoder_output(9)  <= '1';  -- IJUMP
                when "1010" => decoder_output(10) <= '1';  -- IJMPZ
                when "1011" => decoder_output(11) <= '1';  -- IJPNZ
                when "1100" => decoder_output(12) <= '1';  -- ILDAC
                when "1101" => decoder_output(13) <= '1';  -- IMOVR
                when "1110" => decoder_output(14) <= '1';  -- IMVAC
                when "1111" => decoder_output(15) <= '1';  -- ISTAC
                when others => null;
            end case;
        end if;
    end process;

    -- Internal signal assignments
    s_INOP  <= decoder_output(0);
    s_IAND  <= decoder_output(1);
    s_IOR   <= decoder_output(2);
    s_IXOR  <= decoder_output(3);
    s_INOT  <= decoder_output(4);
    s_INAND <= decoder_output(5);
    s_IADD  <= decoder_output(6);
    s_IMULT <= decoder_output(7);
    s_ISUB  <= decoder_output(8);
    s_IJUMP <= decoder_output(9);
    s_IJMPZ <= decoder_output(10);
    s_IJPNZ <= decoder_output(11);
    s_ILDAC <= decoder_output(12);
    s_IMOVR <= decoder_output(13);
    s_IMVAC <= decoder_output(14);
    s_ISTAC <= decoder_output(15);

    -- Output port assignments
    INOP   <= s_INOP;
    IAND   <= s_IAND;
    IOR    <= s_IOR;
    IXOR   <= s_IXOR;
    INOT   <= s_INOT;
    INAND  <= s_INAND;
    IADD   <= s_IADD;
    IMULT  <= s_IMULT;
    ISUB   <= s_ISUB;
    IJUMP  <= s_IJUMP;
    IJMPZ  <= s_IJMPZ;
    IJPNZ  <= s_IJPNZ;
    ILDAC  <= s_ILDAC;
    IMOVR  <= s_IMOVR;
    IMVAC  <= s_IMVAC;
    ISTAC  <= s_ISTAC;
	 
	     -- ALU Operation Select (only on T3)
	OpSel <= "000" when T_internal = "011" and s_IADD  = '1' else
				"001" when T_internal = "011" and s_ISUB  = '1' else
				"010" when T_internal = "011" and s_IAND  = '1' else
				"011" when T_internal = "011" and s_IOR   = '1' else
				"100" when T_internal = "011" and s_INAND = '1' else
				"101" when T_internal = "011" and s_IMULT = '1' else
				"110" when T_internal = "011" and s_IXOR  = '1' else
				"111" when T_internal = "011" and s_INOT  = '1' else
				"XXX"; -- <-- FINAL ELSE: default to NOP or safe state

	-- ARLOAD: FETCH1 (000), FETCH3 (010), LDAC3 (101), STAC3 (101)
	ARLOAD <= '1' when T_internal = "000" or T_internal = "010" or
							 (T_internal = "101" and (s_ILDAC = '1' or s_ISTAC = '1'))
				 else '0';

	-- PCBUS: FETCH1 (000), FETCH3 (010)
	PCBUS <= '1' when T_internal = "000" or T_internal = "010" else '0';

	-- PCIN: FETCH2 (001), LDAC1 (011), LDAC2 (100), STAC1 (011), STAC2 (100),
	--        JMPZ1 (011), JMPZ2 (100), JPNZ1 (011), JPNZ2 (100)
	PCIN <= '1' when 
		 T_internal = "001" or
		 (T_internal = "011" and (s_ILDAC = '1' or s_ISTAC = '1' or
										  (s_IJMPZ = '1' and Z = '0') or 
										  (s_IJPNZ = '1' and Z = '1'))) or
		 (T_internal = "100" and (s_ILDAC = '1' or s_ISTAC = '1' or
										  (s_IJMPZ = '1' and Z = '0') or 
										  (s_IJPNZ = '1' and Z = '1')))
		 else '0';

	-- DRBUS: FETCH2 (001), LDAC3 (101), LDAC5 (111), JUMP3 (101), JMPZ3 (101), JPNZ3 (101), STAC3 (101), STAC5 (111)
	DRBUS <= '1' when 
		 T_internal = "001" or
		 (T_internal = "101" and (s_ILDAC = '1' or s_ISTAC = '1' or s_IJUMP = '1' or 
										  (s_IJMPZ = '1' and Z = '1') or 
										  (s_IJPNZ = '1' and Z = '0'))) or
		 (T_internal = "111" and (s_ILDAC = '1' or s_ISTAC = '1'))
		 else '0';

	-- TRBUS: LDAC3 (101), STAC3 (101), JMPZ3 (101), JPNZ3 (101), JUMP3 (101)
	TRBUS <= '1' when 
		 T_internal = "101" and 
		 (s_ILDAC = '1' or s_ISTAC = '1' or 
		  (s_IJMPZ = '1' and Z = '1') or 
		  (s_IJPNZ = '1' and Z = '0') or 
		  s_IJUMP = '1')
		 else '0';

	-- ACBUS: STAC4 (110), MVAC1 (011)
	ACBUS <= '1' when 
		 (T_internal = "110" and s_ISTAC = '1') or
		 (T_internal = "011" and s_IMVAC = '1')
		 else '0';

	-- RBUS: AND1/OR1/XOR1/NAND1/ADD1/MULT1/SUB1 → all at T_internal = 011
	RBUS <= '1' when 
		 T_internal = "011" and 
		 (s_IAND = '1' or s_IOR = '1' or s_IXOR = '1' or 
		  s_INAND = '1' or s_IADD = '1' or s_IMULT = '1' or s_ISUB = '1')
		 else '0';

	-- MEMBUS: FETCH2 (001), LDAC1 (011), LDAC2 (100), LDAC4 (110),
	--         STAC1 (011), STAC2 (100),
	--         JUMP1 (011), JUMP2 (100),
	--         JMPZ1 (011), JMPZ2 (100),
	--         JPNZ1 (011), JPNZ2 (100)
	MEMBUS <= '1' when 
		 T_internal = "001" or
		 (T_internal = "011" and (s_ILDAC = '1' or s_ISTAC = '1' or s_IJUMP = '1' or 
										  (s_IJMPZ = '1' and Z = '1') or 
										  (s_IJPNZ = '1' and Z = '0'))) or
		 (T_internal = "100" and (s_ILDAC = '1' or s_ISTAC = '1' or s_IJUMP = '1' or 
										  (s_IJMPZ = '1' and Z = '1') or 
										  (s_IJPNZ = '1' and Z = '0'))) or
		 (T_internal = "110" and s_ILDAC = '1')
		 else '0';

	-- BUSMEM: STAC5 (111)
	BUSMEM <= '1' when T_internal = "111" and s_ISTAC = '1' else '0';

	-- ARIN: LDAC1 (011), STAC1 (011), JUMP1 (011), JMPZ1 (011), JPNZ1 (011)
	ARIN <= '1' when 
		 T_internal = "011" and 
		 (s_ILDAC = '1' or s_ISTAC = '1' or 
		  s_IJUMP = '1' or 
		  (s_IJMPZ = '1' and Z = '1') or 
		  (s_IJPNZ = '1' and Z = '0'))
		 else '0';



end Behavioral;
