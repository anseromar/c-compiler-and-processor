library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_reg_addr is
	-- N: Generic size of the assembly instructions and of their parameters
	generic (N: natural := 8);
   Port (
	-- Input: Assembly operation and two operands
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_reg_addr;

architecture Behavioral of multiplexer_reg_addr is
begin
	Output <=	B when Op <= x"05" OR Op = x"08" else	-- When the operation needs a register address
					A when Op = x"06"  OR Op = x"07" else	-- When the operation needs a memory address or a value
					x"FF";											-- Padding/error
end Behavioral;
