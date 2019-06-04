library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_pointer is
	-- Naib:	Generic size of the addresses in the instruction bank
	generic(Naib:  natural := 16);
	port(
		-- Clock, full reset of the processor, reset to Base_addr (in case of a jump)
		-- Reset if '1'
		CLK, in_RST, Reset_base_addr: in std_logic;
		-- Address of the memory space to start reading into
		Base_addr: in std_logic_vector(Naib-1 downto 0);
		-- Output
		Output: out std_logic_vector(Naib-1 downto 0);
		-- Overflow flag, full reset of the processor, 
		flag_O, out_RST: out std_logic
	);
end instruction_pointer;

architecture Behavioral of instruction_pointer is
	-- Constant zero; used for comparisons
	constant Zeros:  std_logic_vector(Naib-1 downto 0) := (others => '0');
	-- 
	signal continue: std_logic := '1';
	signal jump_stopwatch: std_logic_vector := x"0";
	-- Offset (from Base_addr) of the address in which the program reads
	signal offset: std_logic_vector(Naib-1 downto 0) := Zeros(Naib-1 downto 1) & "1";
	signal current_addr: std_logic_vector(Naib-1 downto 0) := Base_addr;

	begin
		-- Full reset of all the processor
		continue <=	'0'	when in_RST = '1';
		out_RST <=	'1'	when in_RST = '1'
				else	'0';
		
		-- Waiting then reactivation of the incrementation after a jump
		jump_stopwatch <= jump_stopwatch - 1	when jump_stopwatch > x"0";
		continue <= '1'	when jump_stopwatch = x"0";
		
		process
		begin
			wait until CLK'event and CLK='1';
			-- Reset to Base_addr if told so
			if Reset_base_addr = '1' then
				current_addr <= Base_addr;
				-- Wait for 4 clock cycles after a jump
				jump_stopwatch <= x"3";
				continue <= '0';
			-- Reset to base address if overflow
			elsif current_addr = 2**Naib AND continue = '1' then
				current_addr <= Base_addr;
				flag_O <= '1';
			-- Incrementation of the current address
			elsif  continue = '1' then
				current_addr <= current_addr + offset;
				flag_O <= '0';
			end if;
			-- Output assignation
			if continue = '1' then
				Output <= current_addr;
			-- Waiting after a jump
			elsif jump_stopwatch < x"0" then
				Output <= x"FFFF";
			end if;
		end process;
end Behavioral;
