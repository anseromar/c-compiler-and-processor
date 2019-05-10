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
	generic(N: natural := 8);
	port(
		-- A is the input and Mult the multiplier of the 
		A, Mult: in std_logic_vector(N-1 downto 0);
		-- Clock flag
		Ck: in std_logic;
		-- S is the output of the pipeline.
		S: in std_logic_vector(N-1 downto 0);
	);
end pipeline;

architecture Behavioral of pipeline is
	signal Temp: std_logic_vector(N-1 downto 0) = Mult;
begin

	wait until Ck ' event and Ck = '1';
	Temp = std_logic_vector(unsigned(Temp)-1);
	Temp	<= Mult	when Temp=0;
	S		<= A		when Temp=0;

end Behavioral;
