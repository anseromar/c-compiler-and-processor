library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_pointer is
	-- Naib: Generic size of the addresses in the instruction bank
	generic(Naib:  natural := 8 ; N_instr: natural := 32);
	port(
		-- Clock flag
		CLK: in std_logic;
		-- Address of the memory space to start reading into
		Base_addr: in std_logic_vector(Naib-1 downto 0);
		-- Output
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
end instruction_pointer;

architecture Behavioral of instruction_pointer is

	begin
		process
		begin
			wait until CLK'event and CLK='1';
			-- Reading
			Output <= instr_b(to_integer(unsigned(Base_addr)+unsigned(offset)));
		end process;
end Behavioral;

