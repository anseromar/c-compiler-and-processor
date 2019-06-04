library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_COMP is
	-- N: 	Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
	-- Input: Assembly operation (for control) and two operands from which to choose
	Op, QA, QB: in std_logic_vector(N-1 downto 0);
	-- Output: Selected operand (between A & B, depending on Op)
	Output: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_COMP;

architecture Behavioral of multiplexer_COMP is
begin
	Output <=	-- EQU
						x"0001" when Op = x"0009" AND QA = QB
			else	x"0000" when Op = x"0009"
						-- INF
						x"0001" when Op = x"000A" AND QA < QB
			else	x"0000" when Op = x"000A"
						-- INFE
						x"0001" when Op = x"000B" AND QA <= QB
			else	x"0000" when Op = x"000B"
						-- SUP
						x"0001" when Op = x"000C" AND QA > QB
			else	x"0000" when Op = x"000C"
						-- SUPE
						x"0001" when Op = x"000D" AND QA >= QB
			else	x"0000" when Op = x"000D"
						-- Default case
			else	QA;
end Behavioral;
