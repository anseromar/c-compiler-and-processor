library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instructions_bank is
	-- Na: Generic size of the addresses
	-- N_instr: Generic size of the instructions
	-- Nb: Generic size of the bank
	generic(Na:  natural := 8 ; N_instr: natural := 32 ; Nb: natural := 256);
	port(
		-- Clock flag
		CLK: in std_logic;
		-- Address of the memory space to start reading into
		Base_addr: in std_logic_vector(Na-1 downto 0);
		-- Output
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
end instructions_bank;


architecture Behavioral of instructions_bank is
	type bank is array (0 to Nb-1) of std_logic_vector (N_instr-1 downto 0);
	-- Getter of all the instructions defining the program to execute
	-- Hard-type the path in the code
	-- TODO: Ask for the right path format
	signal instr_b: bank := init_rom(filename => "../../compiler/source/dummy.txt");
	-- Offset (from Base_addr) of the address in which the program reads
	signal offset: std_logic_vector(Na-1 downto 0);
	
	begin
		process
		begin
			wait until CLK'event and CLK='1';
			-- Reading
			Output <= instr_b(to_integer(unsigned(Base_addr)+unsigned(offset)));
		end process;
		
end Behavioral;
