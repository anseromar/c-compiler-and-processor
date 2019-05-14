library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instructions_bank is
	-- N:  Generic size of the addresses
	-- N_instr: Generic size of the instructions
	-- Nb: Generic size of the bank
	generic(N:  natural := 8 ; N_instr: natural := 32 ; Nb: natural := 256);
	port(
		-- Address of the memory space to read into
		Addr: in std_logic_vector(N-1 downto 0);
		-- Clk: Clock event
		CLK: in std_logic;
		-- Output
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
end instructions_bank;


architecture Behavioral of instructions_bank is
	type bank is array (Nb-1 downto 0) of std_logic_vector;
	signal instr_b: bank;
begin
	process
	begin
		wait until CLK'event and CLK='1';
		-- Reading
		Output <= instr_b(to_integer(unsigned(Addr)));
	end process;

end Behavioral;
