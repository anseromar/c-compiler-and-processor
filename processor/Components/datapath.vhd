library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
	-- Na: Generic size of an address
	-- Naib: Generic size of the addresses in the instruction bank
	-- N: Generic size of the memory/register spaces
	generic(Na: natural := 4 ; Naib:  natural := 8 ; N: natural := 8);
	port (
		CLK : IN  std_logic;
		First_addr : IN std_logic_vector(N-1 downto 0);
		RST : IN std_logic
	);
end datapath;

architecture Structural of datapath is

	-- Components
	
	-- v0
	COMPONENT instruction_pointer
	PORT(
		CLK, Reset_base_addr: in std_logic;
		Base_addr: in std_logic_vector(Naib-1 downto 0);
		Output: out std_logic_vector(Naib-1 downto 0);
		flag_O: out std_logic
	);
	END COMPONENT;
	
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
	constant Zeros:  std_logic_vector(4*N-1 downto 0) := (others => '0');

	type instruction is record
		Op, A, B, C: std_logic_vector(N-1 downto 0);
	end record instruction;
	
	-- Addresses of the assembly instructions in the instructions bank
	signal reset_base_addr: std_logic := '0';									-- Flag notifying if wether the base address should be changed or not
	signal base_addr: 		std_logic_vector(Naib-1 downto 0) := First_addr;	-- New base address from which the instructions bank will read. It is modified in the event of a jump.
	signal current_addr: 	std_logic_vector(Naib-1 downto 0);			-- Current address at which the instructions bank reads the next assembly instruction
	-- Signals containing complete assembly instructions (operations and operands)
	signal out_instr_bank:	std_logic_vector(4*N-1 downto 0);			-- Full undecoded assembly instruction
	signal outBD, inP2, inP3, inP4, outP4: instruction;					-- Decoded assembly instructions
	-- Register file flags
	signal inRF_W:		std_logic;		-- Write flag
	
	-- Additions for v1
	signal inRF_AddrA: std_logic_vector(N-1 downto 0);
	signal outRF_A: std_logic_vector(N-1 downto 0);

	begin
--		-- v0: Supports AFC
--		IP:	instruction_pointer	port map(CLK, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open);
--		IB: 	instructions_bank	port map(CLK,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C);
--		P1:	pipeline				port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inP2.B, open);
--		RF:	register_file		port map(CLK, '0', inRF_W,
--													outP4.A(Na-1 downto 0), outP4.B, (others => '0'), (others => '0'),
--																				open, open);
--		P2:	pipeline				port map(CLK,
--													inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0),
--																				inP3.Op, inP3.A, inP3.B, open);
--		ALU:	arithmetic_logic_unit	port map((others => '0'), (others => '0'), (others => '0'),
--																				open	,	open, open, open, open);
--		P3:	pipeline				port map(CLK,
--													inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0),
--																				inP4.Op, inP4.A, inP4.B, open);
--		DB:	data_bank			port map('0', '0', '0',
--													(others => '0'), (others => '0'),
--																				open);
--		P4:	pipeline				port map(CLK,
--													inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0),
--																				outP4.Op, outP4.A, outP4.B, open);
--		LCW:	combinatory_logic_W	port map(outP4.Op,
--																				inRF_W);
		
		-- v1: Support for AFC & COP
		IP:	instruction_pointer	port map(CLK, reset_base_addr,
														base_addr,
																				current_addr,
																				open);
		IB: 	instructions_bank	port map(CLK,
													current_addr,
																				out_instr_bank);
		BD:	binary_decoder		port map(out_instr_bank,
																				outBD.Op, outBD.A, outBD.B, outBD.C);
		P1:	pipeline				port map(CLK,
													outBD.Op, outBD.A, outBD.B, outBD.C,
																				inP2.Op, inP2.A, inRF_AddrA, open);
		RF:	register_file		port map(CLK, '0', inRF_W,
													outP4.A(Na-1 downto 0),
													outP4.B,
													inRF_AddrA(Na-1 downto 0),
													(others => '0'),
																				outRF_A, open);
		P2:	pipeline				port map(CLK,
													inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0),
																				inP3.Op, inP3.A, inP3.B, open);
		ALU:	arithmetic_logic_unit	port map((others => '0'), (others => '0'), (others => '0'),
																				open	,	open, open, open, open);
		P3:	pipeline				port map(CLK,
													inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0),
																				inP4.Op, inP4.A, inP4.B, open);
		DB:	data_bank			port map('0', '0', '0',
													(others => '0'), (others => '0'),
																				open);
		P4:	pipeline				port map(CLK,
													inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0),
																				outP4.Op, outP4.A, outP4.B, open);
		LCW:	combinatory_logic_W	port map(outP4.Op,
																				inRF_W);
		MBP2:	multiplexer_reg_addr port map(inP2.Op, inRF_AddrA, outRF_A,
																				inP2.B);
		
		-- v2: Added support for ADD, SOU & MUL
		
		
		-- v3: Added support for LOAD
		
		
		-- v4 (FINAL VERSION): Added support for STORE
		

End Structural;
