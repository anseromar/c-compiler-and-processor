library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_DB_in is
	-- N:		Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, A, B: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output_Addr_part1: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_DB_in;

architecture Behavioral of multiplexer_DB_in is
begin
	Output_Addr_part1 <=	A when Op = x"0008"		-- Use output A of pipeline P4
						else	B when Op = x"0007"		-- Use output B of pipeline P4
						else	x"FFFF";						-- Other assembly operations/padding/jump/reset/error
end Behavioral;



-- BE CAREFUL of the bizarre storing system in the pipelines:
--		LOAD Ri @j1 @j2 but STORE @i1 Rj @i2
-- TODO: Draw the circuit before implementing the multiplexers!