library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_bank is
	-- Na: Generic size of the addresses
	-- N:  Generic size of the memory spaces
	-- Nb: Generic size of the bank
	generic(Na:  natural := 8 ; N: natural := 8 ; Nb: natural := 256);
	port(
		-- CLK: Clock event
		-- RST: '1' to reset all registers
		-- RW: '1' to write & '0' to read in the memory at Addr
		CLK, RST, RW: in std_logic;
		-- Address of the memory space to read/write into
		Addr: in std_logic_vector(Na-1 downto 0);
		-- Content to write
		Input: in std_logic_vector(N-1 downto 0);
		-- Output
		Output: out std_logic_vector(N-1 downto 0)
	);
end data_bank;


architecture Behavioral of data_bank is
	type bank is array (Nb-1 downto 0) of std_logic_vector(N-1 downto 0);
	signal data_b: bank;
begin
	process
	begin
		wait until CLK'event and CLK='1';

		-- The priority between the different actions is as follows:
		--   (1) reset, because reading or writing whilst resetting is useless
		--   (2) read, to read before potentially overwriting
		--   (3) write
		-- Reset
		if RST = '1' then
			data_b <= (others => (others => '0'));
		-- Reading
		elsif RW = '0' then
			Output <= data_b(to_integer(unsigned(Addr)));
		-- Writing
		elsif RW = '1' then
			data_b(to_integer(unsigned(Addr))) <= Input;
		end if;
	end process;

end Behavioral;
