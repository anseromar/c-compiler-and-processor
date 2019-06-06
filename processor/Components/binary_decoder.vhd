library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--	-- Assembly operations:
--Code		Op		A		B		C		supported?
-- Operands' use:	Write	Read	Read)
--
--x"0000"	RST	_		_		_		Y
--
--x"0001"	ADD	Ri		Rj		Rk		Y
--x"0002"	MUL	Ri		Rj		Rk		Y
--x"0003"	SOU	Ri		Rj		Rk		Y
--x"0004"	DIV	Ri		Rj		Rk		NO (but taken into account in all CL & MUX)
--
--x"0005"	COP	Ri		Rj		_		Y
--x"0006"	AFC	Ri		j		_		Y
--x"0007"	LOAD	Ri		@j1	@j2	Y
--x"0008"	STORE	@i1	Rj 	@i2	Y		-- Output of compiler: <STORE @i(1&2) Rj> with @i(1&2) on 32 bits. The decoder translates it to <STORE @i1 Rj @i2>.
--
--x"0009"	EQU	Ri		Rj		Rk		Y
--x"000A"	INF	Ri		Rj		Rk		Y
--x"000B"	INFE	Ri		Rj		Rk		Y
--x"000C"	SUP	Ri		Rj		Rk		Y
--x"000D"	SUPE	Ri		Rj		Rk		Y
--
--x"000E"	JMP	@i		_		_		Y
--x"000F"	JMPC	@i		_		Rj		Y		-- Rj in C in case we want to change the IB addressing to 32 bits.
--
--x"FFFF"	NOP	_		_		_		Y



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
	-- Reset/pause if '1'
	out_Pause, Reset_base_addr: out std_logic;
	-- Address of the memory space to start reading into
	Base_addr: out std_logic_vector(Naib-1 downto 0)
	);
end binary_decoder;

architecture Behavioral of binary_decoder is
	signal operation: std_logic_vector(N-1 downto 0);
	-- Decrementing stopwatches set to 3 when a jump is encountered
	shared variable stopwatch1, stopwatch2, stopwatch3, stopwatch4: integer range 0 to 3:= 0;
	-- Signals to store the associated registers' addresses
	signal reg_addr1, reg_addr2, reg_addr3, reg_addr4: std_logic_vector(N-1 downto 0);

begin
	operation <= Full_instr(4*N-1 downto 3*N);

	-- Takes operation when the input operation is know. Else transforms into NOP.
	Op	<=		-- ADD, MUL, SOU, DIV, COP, AFC, LOAD, STORE, EQU, INF, INFE, SUP, SUPE, JMP, JMPC, NOP, RST
				operation 							when (operation >= x"0000" AND operation <= x"000F") OR	operation = x"FFFF"
				-- Error
		else	x"FFFF";
	-- Takes input when the operation needs a first operand (all assembly instructions)
	A	<=		-- ADD, MUL, SOU, DIV, COP, AFC, LOAD, STORE, EQU, INF, INFE, SUP, SUPE, JMP, JMPC, RST
				Full_instr(3*N-1 downto 2*N)	when operation >= x"0000" AND operation <= x"000F"
				-- NOP, error
		else	x"FFFF";
	-- Takes input when the operation needs a second operand (all assembly instructions)
	B	<=		-- ADD, MUL, SOU, DIV, COP, AFC, LOAD, EQU, INF, INFE, SUP, SUPE
				Full_instr(2*N-1 downto N)		when (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D")
		-- STORE is saved as <STORE @i(1&2) Rj> by the compiler. Here is part of its translation to <STORE @i1 Rj @i2> (second and last modification in the first ELSE of the C assignement below).
		else	-- STORE
				Full_instr(N-1 downto 0)		when operation = x"0008"
		else	-- JMP, JMPC, NOP, RST, error
				x"FFFF";
	-- Takes input when the operation needs a third operand (ADD, MUL, SOU, DIV & STORE); else padding (COP, AFC, LOAD, JMP, NOP & unknown operations).
	C	<=		-- ADD, MUL, SOU, DIV, COP, AFC, LOAD, EQU, INF, INFE, SUP, SUPE, JMPC
				Full_instr(N-1 downto 0)		when (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") OR operation >= x"000F"
		else	-- STORE
				Full_instr(2*N-1 downto N)		when operation = x"0008"
		else	-- JMP, NOP, RST, error
				x"FFFF";
	
	-- JMP case: send instruction to reset base address to the instruction pointer (JMPC passes through the register file)
	Reset_base_addr	<=	'1'					when operation = x"000E"
						else	'0';
	Base_addr	<=	Full_instr(3*N-1 downto 2*N)	when operation = x"000E"
				else	x"0000";
	
	
	
	-- TODO: JMPC hazards
	-- To prevent writing in the register file just before a previous JMPC has taken effect, we verify the next instruction cannot be passed.
	
	
	
	-- DEBUG: Registers hazards
	-- When an instruction that writes in a register is seen, it must have a minimum of 4 clock cycles before any other that reads in the same register.
	-- To do so, we will implement four (in case of multiple simultaneous instances of this problem) different stopwatches along with four signals in which the concerned register addresses will be saved.
	
	out_Pause <= '0';
--	out_Pause <=	'1'	when	( stopwatch1 > 0 AND reg_addr1 = Full_instr(3*N-1 downto 2*N) )
--								OR	( stopwatch2 > 0 AND reg_addr2 = Full_instr(3*N-1 downto 2*N) )
--								OR	( stopwatch3 > 0 AND reg_addr3 = Full_instr(3*N-1 downto 2*N) )
--								OR	( stopwatch4 > 0 AND reg_addr4 = Full_instr(3*N-1 downto 2*N) )
--				else	'0';
	
--	-- First stopwatch and associated stored address
--	stopwatch1 :=	-- Set stopwatch when needed
--						3					when	stopwatch1 = 0
--											AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") )
--						-- Decrementing when watching
--				else stopwatch1 - 1	when	stopwatch1 > 0
--						-- Error => return to default
--				else 0;
--	reg_addr1 <=	Full_instr(3*N-1 downto 2*N)	when	stopwatch1 = 0
--																AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") );
--	
--	
--	-- Second stopwatch and associated stored address. It is used only when the first is already used.
--	stopwatch2 :=	-- Set stopwatch when needed
--						3					when	stopwatch2 = 0
--											AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") )
--						-- Decrementing when watching
--				else stopwatch2 - 1	when	stopwatch1 > 0 AND stopwatch2 > 0
--						-- Error => return to default
--				else 0;
--	reg_addr2 <=	Full_instr(3*N-1 downto 2*N)	when	stopwatch2 = 0
--																AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") );
--	
--	
--	-- Second stopwatch and associated stored address. It is used only when the first two are already used.
--	stopwatch3 :=	-- Set stopwatch when needed
--						3					when	stopwatch3 = 0
--											AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") )
--						-- Decrementing when watching
--				else stopwatch3 - 1	when	stopwatch1 > 0 AND stopwatch2 > 0 AND stopwatch3 > 0
--						-- Error => return to default
--				else 0;
--	reg_addr3 <=	Full_instr(3*N-1 downto 2*N)	when	stopwatch3 = 0
--																AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") );
--	
--	
--	-- Second stopwatch and associated stored address. It is used only when the first thre are already used.
--	stopwatch4 :=	-- Set stopwatch when needed
--						3					when	stopwatch4 = 0
--											AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") )
--						-- Decrementing when watching
--				else stopwatch4 - 1	when	stopwatch1 > 0 AND stopwatch2 > 0 AND stopwatch3 > 0 AND stopwatch4 > 0
--						-- Error => return to default
--				else	0;
--	reg_addr4 <=	Full_instr(3*N-1 downto 2*N)	when	stopwatch4 = 0
--																AND	( (operation >= x"0001" AND operation <= x"0007") OR (operation >= x"0009" AND operation <= x"000D") );
	
end Behavioral;
