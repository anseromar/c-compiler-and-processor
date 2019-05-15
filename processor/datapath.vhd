library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
	-- Na: Generic size of an address
	-- N: Generic size of the memory/register spaces
	-- Nb:  Generic size of a bank & biggest size used (for stored data of any kind)
	generic(Na: natural := 4 ; N: natural := 8 ; Nb: natural := 256);
	port (
		CLK : IN  std_logic;
		IP : IN std_logic_vector (N-1 downto 0);
		RST : IN std_logic
	);
end datapath;

architecture Structural of datapath is

	-- Components
	COMPONENT instructions_bank
	PORT(
		CLK: in std_logic;
		Addr: in std_logic_vector(N-1 downto 0);
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
		OUT_Op: in std_logic_vector(N-1 downto 0);
		OUT_A, OUT_B , OUT_C: in std_logic_vector(N-1 downto 0)
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



	-- Constant zero; used for comparisons
	constant Zero:  std_logic_vector(Nb-1 downto 0) := (others => '0');

	type instruction is record
		Op, A, B, C: std_logic_vector(N-1 downto 0);
	end record instruction;

	signal out_instr_bank: std_logic_vector(4*N-1 downto 0);
	signal out_BD, in_P2, in_P3, in_P4, out_P4: instruction;

	-- Cf. cours p.13 & https://stackoverflow.com/questions/49197291/connecting-components-in-vhdl-structural
	begin
		-- TODO: LC for Op between P4 and RF.W
		IB:  instructions_bank	port map(CLK	,	(others => '0')		,		out_instr_bank);
		BD:  binary_decoder	port map(out_instr_bank		,		out_BD.Op, out_BD.A, out_BD.B, out_BD.C);
		P1:  pipeline			port map(CLK	,	out_BD.Op, out_BD.A, out_BD.B, out_BD.C		,		in_P2.Op, in_P2.A, in_P2.B, open);
		RF:  register_file	port map(CLK, '0', LC(instr_out_P4.Op)	,	instr_out_P4.A, instr_out_P4.B, (others => '0'), (others => '0')		,		open, open);
		P2:  pipeline			port map(CLK	,	in_P2.Op, in_P2.A, in_P2.B, Zeros(N-1 downto 0)		,		in_P3.Op, in_P3.A, in_P3.B, open);
		ALU: arithmetic_logic_unit	port map((others => '0'), (others => '0'), (others => '0')		,		open	,	open, open, open, open);
		P3:  pipeline			port map(CLK	,	in_P3.Op, in_P3.A, in_P3.B, Zeros(N-1 downto 0)		,		in_P4.Op, in_P4.A, in_P4.B, open);
		DB:  data_bank			port map('0', '0', '0'	,	(others => '0'), (others => '0')		,		open);
		P4:  pipeline			port map(CLK	,	in_P4.Op, in_P4.A, in_P4.B, Zeros(N-1 downto 0)		,		out_P4.Op, out_P4.A, out_P4.B, open);

End Structural;
