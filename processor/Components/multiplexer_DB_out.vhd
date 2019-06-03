library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_DB_out is
	-- N:		Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_DB_out;

architecture Behavioral of multiplexer_DB_out is
begin
	Output <=	B when Op = x"0006"														-- Use output of the data bank
			else	A when (Op >= x"0001" AND Op <= x"0009")  OR Op = x"FFFF"	-- Bypass the data bank
			else	x"FFFF";		-- Padding/jump/reset/error
end Behavioral;
