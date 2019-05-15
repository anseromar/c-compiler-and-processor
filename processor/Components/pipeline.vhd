library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipeline is
	-- N:  Generic size of an assembly operation and of each of its parameters
	generic(N: natural := 8);
	port(
		-- Clock flag
		CLK: in std_logic;
		-- Input: the assembly operation and its three caracteristics
		IN_Op: in std_logic_vector(N-1 downto 0);
		IN_A, IN_B , IN_C: in std_logic_vector(N-1 downto 0);
		-- Output:  the assembly operation and its three caracteristics
		OUT_Op: out std_logic_vector(N-1 downto 0);
		OUT_A, OUT_B , OUT_C: out std_logic_vector(N-1 downto 0)
	);
end pipeline;

architecture Behavioral of pipeline is

begin
	process
	begin
		wait until CLK'event and CLK='1';
		OUT_Op <= IN_Op;
		OUT_A <= IN_A;
		OUT_B <= IN_B;
		OUT_C <= IN_C;
	end process;

end Behavioral;
