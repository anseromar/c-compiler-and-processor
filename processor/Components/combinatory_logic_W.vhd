library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_logic_W is
	-- N:  Generic size of an assembly operation and of each of its parameters
	generic(N: natural := 8);
	port(
		-- Address of the memory space to start reading into
		Op: in std_logic_vector(N-1 downto 0);
		-- Output
		Flag_W: out std_logic
	);
end combinatory_logic_W;

architecture Behavioral of combinatory_logic_W is
begin
	-- The flag is set to '1' (write) when the input is AFC
	Flag_W <= '1' when Op = x"06";
end Behavioral;

