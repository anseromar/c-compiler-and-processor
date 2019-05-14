library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
	-- Na: Generic size of an address
	-- N: Generic size of the memory/register spaces
	-- Nr: Generic size of an assembly instruction parameter
	-- N_instr: Generic size of an instruction
	-- Nb:  Generic size of a bank & biggest size used (for stored data of any kind)
	generic(Na: natural := 4 ; N: natural := 8 ; Nr: natural := 16 ; N_instr: natural := 32 ; Nb: natural := 256);
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
		Addr: in std_logic_vector(N-1 downto 0);
		CLK: in std_logic;
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
	END COMPONENT;

	COMPONENT pipeline
	PORT(
		CLK: in std_logic;
		IN_Op: in std_logic_vector(N-1 downto 0);
		IN_A, IN_B , IN_C: in std_logic_vector(Nr-1 downto 0);
		OUT_Op: in std_logic_vector(N-1 downto 0);
		OUT_A, OUT_B , OUT_C: in std_logic_vector(Nr-1 downto 0)
	);
	END COMPONENT;

	COMPONENT register_file
	PORT(
		CLK, RST, W: in std_logic;
		Addr_A, Addr_B, Addr_W: in std_logic_vector(Na-1 downto 0);
		Data: in std_logic_vector(N-1 downto 0);
		QA, QB: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT arithmetic_logic_unit
	PORT(
		A, B: in std_logic_vector(N-1 downto 0);
		Ctrl: in std_logic_vector(1 downto 0);
		S: out std_logic_vector(N-1 downto 0);
		flag_Z, flag_C, flag_N, flag_O: out std_logic
	);
	END COMPONENT;

	COMPONENT data_bank
	port(
		Addr: in std_logic_vector(Na-1 downto 0);
		Input: in std_logic_vector(N-1 downto 0);
		RW, RST, CLK: in std_logic;
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;



	-- Constant zero; used for comparisons
	constant Zero:  std_logic_vector(Nb-1 downto 0) := (others => '0');
	
	type instruction is record
		Op: in std_logic_vector(N-1 downto 0);
		A, B, C: in std_logic_vector(Nr-1 downto 0);
	end record instruction;

	signal instr_in_P1, instr_in_P2, instr_in_P3, instr_in_P4, instr_out_P4: instruction;

	-- Cf. cours p.13 & https://stackoverflow.com/questions/49197291/connecting-components-in-vhdl-structural
	begin
		IB:  instructions_bank	port map(
		P1:  pipeline			port map(CLK, instr_in_P1.Op, instr_in_P1.A, instr_in_P1.B, instr_in_P1.C		,		instr_in_P2.Op, instr_in_P2.A, instr_in_P2.B, open);
		RF:  register_file	port map(CLK, '0', instr_out_P4.Op, open, open, instr_out_P4.A, instr_out_P4.B		,		open, open);
		P2:  pipeline			port map(CLK, instr_in_P2.Op, instr_in_P2.A, instr_in_P2.B, Zeros(Nr-1 downto 0)		,		instr_in_P3.Op, instr_in_P3.A, instr_in_P3.B, open);
		ALU: arithmetic_logic_unit	port map(open, open, open, open		,		open, open, open, open);
		P3:  pipeline			port map(CLK, instr_in_P3.Op, instr_in_P3.A, instr_in_P3.B, Zeros(Nr-1 downto 0)		,		instr_in_P4.Op, instr_in_P4.A, instr_in_P4.B, open);
		DB:  data_bank			port map(open, open, open, open, open		,		open);
		P4:  pipeline			port map(CLK, instr_in_P4.Op, instr_in_P4.A, instr_in_P4.B, Zeros(Nr-1 downto 0)		,		instr_out_P4.Op, instr_out_P4.A, instr_out_P4.B, open);

End Structural;
