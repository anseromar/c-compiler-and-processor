library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_logic_W is
	-- N:		Generic size of an assembly operation and of each of its parameters
	generic(N: natural := 16);
	port(
		-- Address of the memory space to start reading into
		Op: in std_logic_vector(N-1 downto 0);
		-- Reset; write
		-- Reset if '1'
		out_RST, Flag_W: out std_logic
	);
end combinatory_logic_W;

architecture Behavioral of combinatory_logic_W is
begin
	-- Reset
	out_RST <=	'1' when Op = x"0000"
			else	'0';
	Flag_W <=	-- ADD, MUL, SOU, DIV, COP, AFC, LOAD, EQU, INF, INFE, SUP, SUPE
					'1' when (Op >= x"0001" AND Op <= x"0007") OR (Op >= x"0009" AND Op <= x"000D")		-- Write in register file
					-- STORE, JMP, JMPC, RST, padding, error
			else	'0';
end Behavioral;
