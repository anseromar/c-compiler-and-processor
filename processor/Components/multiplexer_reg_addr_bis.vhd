library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_reg_addr_bis is
	-- N: 	Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_reg_addr_bis;

architecture Behavioral of multiplexer_reg_addr_bis is
begin
	Output <=	-- ADD, MUL, SOU, DIV
					B when Op >= x"0001" AND Op <= x"0004"		-- Use output of the register file
					-- COP, AFC, LOAD, STORE
			else	A when Op >= x"0005" AND Op <= x"0008"		-- Bypass the register file
					-- JMPC, RST, padding, error
			else	x"FFFF";		-- Padding
end Behavioral;
