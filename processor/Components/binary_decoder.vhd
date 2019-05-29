library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--	-- Assembly operations supported:
--Code	Op		A	B	C
--x"01"	ADD	Ri	Rj	Rk
--x"02"	MUL	Ri	Rj	Rk
--x"03"	SOU	Ri	Rj	Rk
--x"04"	DIV	Ri	Rj	Rk
--x"05"	COP	Ri	Rj	_
--x"06"	AFC	Ri	j	_
--x"07"	LOAD	Ri	@j	_
--x"08"	STORE	@i	Rj	_


entity binary_decoder is
	-- N: Generic size of the assembly instructions and of their parameters
	generic (N: natural := 8);
   Port (
	-- Input: full instruction containing the operation and all its operand
	Full_instr: in  std_logic_vector(4*N-1 downto 0);
	-- Output: disjoint assembly operation and operands
	Op, A, B, C: out std_logic_vector(N-1 downto 0)
	);
end binary_decoder;

architecture Behavioral of binary_decoder is
	signal operation: std_logic_vector(N-1 downto 0);
	
begin
	operation <= Full_instr(4*N-1 downto 3*N);
	
	-- Takes operation when the input operation is know. Else transforms into NOPE.
	Op	<=	operation
				when operation <= x"08" OR operation = x"FF" else
			x"FF";
	-- Takes input when the operation needs a first operand (all assembly instrucitons);
	-- else padding (NOPE & unknown operations).
	A	<= Full_instr(3*N-1 downto 2*N)
				when operation <= x"08" else
			x"FF";
	-- Takes input when the operation needs a first operand (all assembly instrucitons);
	-- else padding (NOPE & unknown operations).
	B	<= Full_instr(2*N-1 downto N)
				when operation <= x"08" else
			x"FF";
	-- Takes input when the operation needs a first operand (ADD, MUL, SOU & DIV);
	-- else padding (COP, AFC, LOAD, STORE, NOPE & unknown operations).
	C	<= Full_instr(1*N-1 downto 0)
				when operation <= x"08" else
			x"FF";
end Behavioral;
