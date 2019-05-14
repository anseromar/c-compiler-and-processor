library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arithmetic_logic_unit is
	generic(N: natural := 8);
	port(
		-- A and B are the input of the operations.
		A, B: in std_logic_vector(N-1 downto 0);
		-- Ctrl commands which operation is to be executed.
		-- Its first bit indicates wether the operation is signed (1) or not (0).
		Ctrl: in std_logic_vector(1 downto 0);
		-- S is the output of the operation A OP B.
		S: out std_logic_vector(N-1 downto 0);
		-- The flags indicate :
		-- 	Z : nul output (S = 0)
		--		C : addition carry
		--		N : negative
		--		O : overflow
		flag_Z, flag_C, flag_N, flag_O: out std_logic
	);
end arithmetic_logic_unit;

architecture Behavioral of arithmetic_logic_unit is
	constant Zero:  std_logic_vector(2*N-1 downto 0) := (others => '0');
	-- Temporary values in 9 bits (addition/substraction) and 16 bits (multiplication) instead of 8 only
	signal S_temp_add:  std_logic_vector(N downto 0) := (others => '0');
	signal S_temp_mult: std_logic_vector(N*2-1 downto 0) := (others => '0');
	-- Temporary value  at the very end of the component, to be able to compare the output without reading it (and so declaring it as inout).
	signal S_temp_bis:  std_logic_vector(N-1 downto 0) := (others => '0');
begin
	
	-- Temporary signals assignation
	S_temp_add <= --Addition or substraction
					std_logic_vector(("0"&signed(A)) + ("0"&signed(B)))							when Ctrl="01"
					else std_logic_vector(("0"&signed(A)) - ("0"&signed(B)))						when Ctrl="10"
					else (others=>'0');
	
	S_temp_mult <=	-- Multiplication
					std_logic_vector(("00000000"&unsigned(A)) * ("00000000"&unsigned(B)))	when Ctrl="11"
					else (others=>'0');
	
	
	-- Output signal assignation
	S_temp_bis <= S_temp_add (N downto 0)
							when (Ctrl="01" or Ctrl="10")
						else (others=>'0');
	S_temp_bis <= S_temp_mult(N downto 0)
							when Ctrl="11"
						else (others=>'0');
	
	S <= S_temp_bis;
	
	--Flags
	-- Null output
	flag_Z <= '1'	when (S_temp_add(N downto 0) = Zero(N downto 0)) and (S_temp_mult(N*2-1 downto 0) = Zero(2*N-1 downto 0))
						else '0';
	-- Carry
	flag_C <= '1'	when S_temp_add(N) = '1'
							and Ctrl="01"
						else '0';
	-- Negative output
	flag_N <= '1'	when	( S_temp_add(N-1) = '1'
							and (Ctrl="01" or Ctrl="10") )
						or		( S_temp_mult(N-1) = '1'
							and Ctrl="11" )
						else '0';
	-- Overflow (signed bit affected)
	flag_O <= '1'	when	( (S_temp_add(N-1) /= S_temp_bis(N-1))
							and (Ctrl="01" or Ctrl="10") )
						or		( (S_temp_mult(7 downto 0) /= "00000000")
							and Ctrl="11" )
						else '0';
						
end Behavioral;
