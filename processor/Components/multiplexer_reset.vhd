library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_reset is
	-- N: 	Generic size of the assembly instructions and of their parameters
	generic (N: natural := 16);
   Port (
		-- Intersecting signals
		RST_Base_addr1, RST_Base_addr2: in std_logic;
		Base_addr1, Base_addr2: in std_logic_vector(N-1 downto 0);
		-- Output
		out_RST_Base_addr: out std_logic;
		out_Base_addr: out std_logic_vector(N-1 downto 0)
	);
end multiplexer_reset;

architecture Behavioral of multiplexer_reset is
begin
	-- Jump has priority over other instructions
	out_RST_Base_addr <=	RST_Base_addr1 OR RST_Base_addr2;
	-- Normaly, padding can only be encountered if a JMPC goes to the register file for jump clearance and only the first case is used.
	out_Base_addr <=	-- Reset to the concerned address
							Base_addr2 when RST_Base_addr1 = '0' AND RST_Base_addr2 = '1'
					else	Base_addr1 when RST_Base_addr1 = '1' AND RST_Base_addr2 = '0'
							-- No jump
					else	Base_addr1 when RST_Base_addr1 = '0' AND RST_Base_addr2 = '0'
							-- Oldest instruction has the priority
					else	Base_addr2 when RST_Base_addr1 = '0' AND RST_Base_addr2 = '1';
end Behavioral;
