library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_reg_addr is
	-- N: Generic size of the assembly instructions and of their parameters
	generic (N: natural := 8);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_reg_addr;

architecture Behavioral of multiplexer_reg_addr is
begin
	Output <=	A when (Op >= x"01" AND Op <= x"03") OR Op = x"08"		-- When the operation needs a register address
			else	A when (Op >= x"05" AND Op <= x"09") OR Op = x"FF"		-- Else
			else	x"FF";		-- Padding/error
end Behavioral;
