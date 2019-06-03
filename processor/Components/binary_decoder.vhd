library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- TODO: Prévir le passage 32 bits en adaptant @i XX _ en @i1@i2 XX (STORE & JMP)

--	-- Assembly operations supported:
--Code		Op		A		B		C
--	(Use			Write	Read	Read)
--x"0000"	RST	_		_		_
--x"0001"	ADD	Ri		Rj		Rk
--x"0002"	MUL	Ri		Rj		Rk
--x"0003"	SOU	Ri		Rj		Rk
--x"0004"	DIV	Ri		Rj		Rk
--x"0005"	COP	Ri		Rj		_
--x"0006"	AFC	Ri		j		_
--x"0007"	LOAD	Ri		@j		_
--x"0008"	STORE	@i1	Rj 	@i2		-- Output of compiler: <STORE @i(1&2) Rj>. The decoder translates it to <STORE @i1 Rj @i2>.
--x"0009"	JMP	@i		_		_


entity binary_decoder is
	-- N:		Generic size of the assembly instructions and of their parameters
	-- Naib:	Generic size of the addresses in the instruction bank
	generic (N: natural := 16 ; Naib:  natural := 16);
   Port (
	-- Input: full instruction containing the operation and all its operand
	Full_instr: in  std_logic_vector(4*N-1 downto 0);
	-- Output: disjoint assembly operation and operands
	Op, A, B, C: out std_logic_vector(N-1 downto 0);
	-- Reset to Base_addr (in case of a jump)
	-- Reset if '1'
	Reset_base_addr: out std_logic;
	-- Address of the memory space to start reading into
	Base_addr: out std_logic_vector(Naib-1 downto 0)
	);
end binary_decoder;

architecture Behavioral of binary_decoder is
	signal operation: std_logic_vector(N-1 downto 0);
	
begin
	operation <= Full_instr(4*N-1 downto 3*N);
	
	-- Takes operation when the input operation is know. Else transforms into NOPE.
	Op	<=		operation 							when	operation <= x"0008"
																-- Padding and reset of the entire processor
															OR	operation = x"FFFF" OR operation = x"0000"
		else	x"FFFF";
	-- Takes input when the operation needs a first operand (all assembly instructions); else padding (JMP, NOPE unknown operations).
	A	<=		Full_instr(3*N-1 downto 2*N)	when operation <= x"0008"
		else	x"0000" when operation = x"0000"
		else	x"FFFF";
	-- Takes input when the operation needs a second operand (all assembly instructions); else padding (JMP, NOPE & unknown operations).
	B	<=		Full_instr(2*N-1 downto N)		when operation <= x"0007"
		-- STORE is saved as <STORE @i(1&2) Rj> by the compiler. Here is part of its translation to <STORE @i1 Rj @i2> (second and last modification in the first ELSE of the C assignement below).
		else	Full_instr(N-1 downto 0)		when operation = x"0008"
		else	x"0000" when operation = x"0000"
		else	x"FFFF";
	-- Takes input when the operation needs a third operand (ADD, MUL, SOU, DIV & STORE); else padding (COP, AFC, LOAD, JMP, NOPE & unknown operations).
	C	<=		Full_instr(N-1 downto 0)		when operation <= x"0007"
		else	Full_instr(2*N-1 downto N)		when operation = x"0008"
		else	x"0000"								when operation = x"0000"
		else	x"FFFF";
	-- JMP case: send instruction to reset base address to the instruction pointer
	Reset_base_addr	<=	'1'					when x"0009"
						else	'0';
	Base_addr	<=	Full_instr(3*N-1 downto 2*N)	when operation = x"0000"
				else	x"0000";
end Behavioral;
