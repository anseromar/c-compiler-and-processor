library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

-- TODO: IP externe (avec incrémentation et renvoi)

entity instructions_bank is
	-- Naib: Generic size of the addresses in the instruction bank
	-- N_instr: Generic size of the instructions (assembly operation  and its operands)
	generic(Naib:  natural := 8 ; N_instr: natural := 32);
	port(
		-- Clock flag
		CLK: in std_logic;
		-- Address of the memory space to read into
		Addr: in std_logic_vector(Naib-1 downto 0);
		-- Output
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
end instructions_bank;


architecture Behavioral of instructions_bank is
	-- Getter of all the instructions defining the program to execute
	-- Hard-type the path in the code
	signal instr_b: instrArray := init_rom(filename => "../../compiler/assembler/assembly.o");
	
	begin
		process
		begin
			wait until CLK'event and CLK='1';
			-- Reading
			Output <= instr_b(to_integer(unsigned(Addr)));
		end process;
		
end Behavioral;
