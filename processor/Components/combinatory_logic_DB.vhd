library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_logic_DB is
	-- N:		Generic size of an assembly operation and of each of its parameters
	generic(N: natural := 16);
	port(
		-- Address of the memory space to start reading into
		Op: in std_logic_vector(N-1 downto 0);
		-- Reset; write
		out_RST, Flag_RW: out std_logic
	);
end combinatory_logic_DB;

architecture Behavioral of combinatory_logic_DB is
begin
	-- Reset if '1'
	out_RST <=	'1' when Op = x"0000"
			else	'0';
	-- The flag is set to '1' (read) when the input is LOAD
	Flag_RW <= '0' when Op = x"0007";		--LOAD
end Behavioral;
