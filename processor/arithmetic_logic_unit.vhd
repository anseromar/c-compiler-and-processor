library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arithmetic_logic_unit is
	generic(N: natural := 8);
	port(
		-- A and B are the input of the operations.
		A, B: in std_logic_vector(N-1 downto 0);
		-- Ctrl commands which operation is to be executed.
		-- Its first bit indicates wether the operation is signed (1) or not (0).
		Ctrl: in std_logic_vector(3 downto 0);
		-- S is the output of the operation A OP B.
		S: out std_logic_vector(N-1 downto 0);
		-- The flags indicate :
		-- 	Z : nul output (S = 0)
		--		C : addition carry
		--		N : negative
		--		O : overflow
		flag_Z, flag_C, flag_N, flag_O: out std_logic;
	);
end arithmetic_logic_unit;

architecture Behavioral of arithmetic_logic_unit is
	-- Temporary value in 16 bits instead of 8 only
	signal S_temp: std_logic_vector(N*2-1 downto 0) := (others => '0');
begin
	
	S_temp <=	-- Unsigned operations
				--	std_logic_vector(unsigned(A)	+ unsigned(B)) when Ctrl="0001" else
				--	std_logic_vector(unsigned(A)	- unsigned(B)) when Ctrl="0010" else
				--	std_logic_vector(unsigned(A)	* unsigned(B)) when Ctrl="0011" else
				--	std_logic_vector(unsigned(A)	/ unsigned(B)) when Ctrl="0100" else
					-- Signed operations
					std_logic_vector(signed(A)		+   signed(B)) when Ctrl="1001" else
					std_logic_vector(signed(A)		-   signed(B)) when Ctrl="1010" else
					std_logic_vector(signed(A)		*   signed(B)) when Ctrl="1011" else
				--	std_logic_vector(signed(A)		/   signed(B)) when Ctrl="1100" else
					x(others=>'0');
	
	-- Null output
	flag_Z <= '1' when S_temp(N*2-1 downto 0) = 0	else '0';
	-- Carry
	flag_C <= '1' when S_temp(N)='1'
						and Ctrl="1001"						else '0';
	-- Negative output
	flag_N <= '1' when S_temp(N-1)
						and (Ctrl="0001" or Ctrl="0010")	else '0';
	-- Overflow (signed bit affected)
	-- Cas a traiter :
		-- p+p=n	;	n+n=p	;	p-n=n	;	n-p=p	;	p*p=n	;	n*n=n	;	p*n=p	;	n*p=p
	flag_O <= '1' when TODO
						and Ctrl(3)='1'						else '0';

end Behavioral;
