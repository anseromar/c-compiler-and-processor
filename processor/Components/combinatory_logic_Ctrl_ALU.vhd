library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_logic_Ctrl_ALU is
	-- N:		Generic size of an assembly operation and of each of its parameters
	generic(N: natural := 16);
	port(
		-- Assembly operation
		Op: in std_logic_vector(N-1 downto 0);
		-- Output
		Ctrl_ALU: out std_logic_vector(1 downto 0)
	);
end combinatory_logic_Ctrl_ALU;

architecture Behavioral of combinatory_logic_Ctrl_ALU is
begin
	Ctrl_ALU <=	"01" when Op = x"0001"	-- ADD
			else	"10" when Op = x"0003"	-- SOU
			else	"11" when Op = x"0002"	-- MUL
			else	"00";							-- Error
end Behavioral;
