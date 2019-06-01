library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_pointer is
	-- Naib:	Generic size of the addresses in the instruction bank
	generic(Naib:  natural := 16);
	port(
		-- Clock, reset to Base_addr (in case of a jump)
		CLK, Reset_base_addr: in std_logic;
		-- Address of the memory space to start reading into
		Base_addr: in std_logic_vector(Naib-1 downto 0);
		-- Output
		Output: out std_logic_vector(Naib-1 downto 0);
		-- Overflow flag 
		flag_O: out std_logic
	);
end instruction_pointer;

architecture Behavioral of instruction_pointer is
	-- Constant zero; used for comparisons
	constant Zeros:  std_logic_vector(Naib-1 downto 0) := (others => '0');
	-- Offset (from Base_addr) of the address in which the program reads
	signal offset: std_logic_vector(Naib-1 downto 0) := Zeros(Naib-1 downto 1) & "1";
	signal current_addr: std_logic_vector(Naib-1 downto 0) := Base_addr;

	begin
		process
		begin
			wait until CLK'event and CLK='1';
			-- Reset to Base_addr if told so
			if Reset_base_addr = '1' then
				current_addr <= Base_addr;
			-- Reset to base address if overflow
			elsif current_addr = 2**Naib then
				current_addr <= Base_addr;
				flag_O <= '1';
			-- Incrementation of the current address
			else
				current_addr <= current_addr + offset;
				flag_O <= '0';
			end if;
			-- Output assignation
			Output <= current_addr;
		end process;
end Behavioral;
