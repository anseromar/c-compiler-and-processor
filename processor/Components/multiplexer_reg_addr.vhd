library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_reg_addr is
	-- N: 	Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_reg_addr;

architecture Behavioral of multiplexer_reg_addr is
begin
	Output <=	-- ADD, MUL, SOU, DIV, COP, STORE
					B when (Op >= x"0001" AND Op <= x"0005") OR Op = x"0008"		-- Use output of the register file
					-- AFC, LOAD
			else	A when Op = x"0006" OR Op = x"0007"									-- Bypass the register file
					-- JMPC, RST, padding, error
			else	x"FFFF";		-- Padding
end Behavioral;
