library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity combinatory_logic_JMPC is
	-- N:		Generic size of an assembly operation and of each of its parameters
  -- Naib:	Generic size of the addresses in the instruction bank
	generic(N: natural := 16 ; Naib:  natural := 16);
	port(
		-- Control
		QA: in std_logic_vector(N-1 downto 0);
    -- Address to jump to
    Addr_in: in std_logic_vector(N-1 downto 0);
    -- No jump-case output
    QA_bis: out std_logic_vector(N-1 downto 0);
		-- Reset address from which the instruction pointer reads the assembly code
		RST_base_addr: out std_logic;
    -- Address from which the instruction pointer reads the assembly code
    Base_addr: out std_logic_vector(Naib-1 donwto 0)
	);
end combinatory_logic_JMPC;

architecture Behavioral of combinatory_logic_JMPC is
begin
  QA_bis <= QA;
	-- Jump if QA = 1
	RST_base_addr <=	'1' when Op = x"0010" AND QA = x"0001";
			        else	'0';
	Base_addr <=	Addr_in when Op = x"0010" AND QA = x"0001";
end Behavioral;
