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
	process
	begin
		operation <= Full_instr((N*4)-1 downto N*3);

		--TODO: Error with comparison in the if/elsif statements

		-- ADD, MUL, SOU, DIV
		if (unsigned(operation)<=x"04") then
			Op <= operation;
			A <= Full_instr((N*3)-1 downto N*2);
			B <= Full_instr((N*2)-1 downto N*1);
			C <= Full_instr((N*1)-1 downto 0);
		-- COP, AFC, LOAD, STORE
		elsif (unsigned(operation)>=x"05" AND unsigned(operation)<="08") then
			Op <= operation;
			A <= Full_instr((N*3)-1 downto N*1);
			B <= Full_instr((N*1)-1 downto 0);
			C <= x"FF";
		-- NOPE
		elsif (unsigned(operation)=x"FF") then
			Op <= operation;
			A <= x"FF";
			B <= x"FF";
			C <= x"FF";
		-- All others: We transform the unknown instructions to NOPE.
		else
			Op <= x"FF";
			A  <= x"FF";
			B  <= x"FF";
			C  <= x"FF";
		end if;

	end process;

end Behavioral;
