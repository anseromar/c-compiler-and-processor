library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
	-- Na: Generic size of an address
	-- N: Generic size of the memory/register spaces
	-- Nb:  Generic size of a bank & biggest size used (for stored data of any kind)
	generic(Na: natural := 4 ; N: natural := 8 ; Nb: natural := 256);
	port (
		CLK : IN  std_logic;
		IP : IN std_logic_vector(N-1 downto 0);
		RST : IN std_logic
	);
end datapath;

architecture Structural of datapath is

	-- Components
	
	-- v0
	COMPONENT instructions_bank
	PORT(
		CLK: in std_logic;
		Base_addr: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(4*N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT binary_decoder
	PORT(
		Full_instr: in  std_logic_vector(4*N-1 downto 0);
		Op, A, B, C: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT pipeline
	PORT(
		CLK: in std_logic;
		IN_Op: in std_logic_vector(N-1 downto 0);
		IN_A, IN_B , IN_C: in std_logic_vector(N-1 downto 0);
		OUT_Op: out std_logic_vector(N-1 downto 0);
		OUT_A, OUT_B , OUT_C: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT register_file
	PORT(
		CLK, RST, W: in std_logic;
		Addr_W: in std_logic_vector(Na-1 downto 0);
		Data: in std_logic_vector(N-1 downto 0);
		Addr_A, Addr_B: in std_logic_vector(Na-1 downto 0);
		QA, QB: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT arithmetic_logic_unit
	PORT(
		Ctrl: in std_logic_vector(1 downto 0);
		A, B: in std_logic_vector(N-1 downto 0);
		S: out std_logic_vector(N-1 downto 0);
		flag_Z, flag_C, flag_N, flag_O: out std_logic
	);
	END COMPONENT;

	COMPONENT data_bank
	port(
		CLK, RST, RW: in std_logic;
		Addr: in std_logic_vector(Na-1 downto 0);
		Input: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT combinatory_logic_W
	PORT(
		Op: in std_logic_vector(N-1 downto 0);
		Flag_W: out std_logic
	);
	END COMPONENT;
	
	-- v1
	COMPONENT multiplexer_reg_addr
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;



	-- Constant zero; used for comparisons
	constant Zeros:  std_logic_vector(Nb-1 downto 0) := (others => '0');

	type instruction is record
		Op, A, B, C: std_logic_vector(N-1 downto 0);
	end record instruction;

	signal out_instr_bank: std_logic_vector(4*N-1 downto 0);
	signal outBD, inP2, inP3, inP4, outP4: instruction;
	signal back_to_RF: std_logic;
	-- v1
--	signal inALU_AddrA: std_logic_vector(N-1 downto 0);
--	signal outP2_B: std_logic_vector(N-1 downto 0);

	begin
		-- v0: Supports AFC
		IB:  instructions_bank	port map(CLK	,	IP		,		out_instr_bank);
		BD:  binary_decoder	port map(out_instr_bank		,		outBD.Op, outBD.A, outBD.B, outBD.C);
		P1:  pipeline			port map(CLK	,	outBD.Op, outBD.A, outBD.B, outBD.C		,		inP2.Op, inP2.A, inP2.B, open);
		RF:  register_file	port map(CLK, '0', back_to_RF	,	outP4.A(Na-1 downto 0), outP4.B, (others => '0'),	(others => '0')		,		open, open);
		P2:	pipeline			port map(CLK	,	inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0)		,		inP3.Op, inP3.A, inP3.B, open);
		ALU:	arithmetic_logic_unit	port map((others => '0'), (others => '0'), (others => '0')		,		open	,	open, open, open, open);
		P3:	pipeline			port map(CLK	,	inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0)		,		inP4.Op, inP4.A, inP4.B, open);
		DB:	data_bank			port map('0', '0', '0'	,	(others => '0'), (others => '0')		,		open);
		P4:	pipeline			port map(CLK	,	inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0)		,		outP4.Op, outP4.A, outP4.B, open);
		LCW:	combinatory_logic_W	port map(outP4.Op		,		back_to_RF);
		
--		-- v1: Support for AFC & COP
--		IB:  instructions_bank	port map(CLK	,	IP		,		out_instr_bank);
--		BD:  binary_decoder	port map(out_instr_bank		,		outBD.Op, outBD.A, outBD.B, outBD.C);
--		P1:  pipeline			port map(CLK	,	outBD.Op, outBD.A, outBD.B, outBD.C		,		inP2.Op, inP2.A, inP2.B, open);
--		RF:  register_file	port map(CLK, '0', back_to_RF	,	outP4.A(Na-1 downto 0), outP4.B, (others => '0'),	(others => '0')		,		open, open);
--		P2:	pipeline			port map(CLK	,	inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0)		,		inP3.Op, inP3.A, inP3.B, open);
--		ALU:	arithmetic_logic_unit	port map((others => '0'), (others => '0'), (others => '0')		,		open	,	open, open, open, open);
--		P3:	pipeline			port map(CLK	,	inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0)		,		inP4.Op, inP4.A, inP4.B, open);
--		DB:	data_bank			port map('0', '0', '0'	,	(others => '0'), (others => '0')		,		open);
--		P4:	pipeline			port map(CLK	,	inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0)		,		outP4.Op, outP4.A, outP4.B, open);
--		LCW:	combinatory_logic_W	port map(outP4.Op		,		back_to_RF);
--		MBP2:	multiplexer_reg_addr port map(inP2.Op, inALU_AddrA(Na-1 downto 0), outP2_B		,		inP2.B);
		
		-- v2: Added support for ADD, SOU & MUL
		
		
		-- v3: Added support for LOAD
		
		
		-- v4 (FINAL VERSION): Added support for STORE
		

End Structural;
