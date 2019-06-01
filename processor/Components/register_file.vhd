library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
	-- Na:	Generic size of the memory addresses
	-- N:		Generic size of the registers
	-- Nr:	Number of registers
	generic(Na:  natural := 32 ; N: natural := 16 ; Nr: natural := 16);
	port(
		-- CLK: Clock event
		-- RST: '1' to reset all registers
		-- W: '1' to write in the register at Addr_W
		CLK, RST, W: in std_logic;
		-- Address of the registers to write into
		Addr_W: in std_logic_vector(Nr-1 downto 0);
		-- Data to write
		Data: in std_logic_vector(N-1 downto 0);
		-- Address of the registers to read from
		Addr_A, Addr_B: in std_logic_vector(Nr-1 downto 0);
		-- Output: content of the two registers if W='0'
		QA, QB: out std_logic_vector(N-1 downto 0)
	);
end register_file;

architecture Behavioral of register_file is
	-- Definition of the registers array
	type reg_type is array (Nr-1 downto 0) of std_logic_vector(N-1 downto 0);
	signal registers: reg_type;
	
begin
	-- Reading registers Addr_A and Addr_B
	QA <= registers(to_integer(unsigned(Addr_A))) when Addr_A /= Addr_W else
		   DATA;
	QB <= registers(to_integer(unsigned(Addr_B))) when Addr_B /= Addr_W else
			DATA;
		
	-- Writing in register Addr_W if W='1'
	process
	begin
		wait until CLK'event and CLK='1';
		--if raising_edge(CLK) then
		if RST = '1' then
			registers <= (others => (others => '0'));
		elsif W = '1' then
			registers(to_integer(unsigned(Addr_W))) <= DATA;
		end if;
	end process;

end Behavioral;

