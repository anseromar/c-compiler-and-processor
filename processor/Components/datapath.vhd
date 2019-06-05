library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- TODO: add MUX out RF bis

entity datapath is
	-- Naib:	Generic size of the addresses in the instruction bank
	-- Nr:	Number of registers
	-- Na:	Generic size of an memory addresses
	-- N:		Generic size of the memory/register spaces
	-- Nb:	Generic size of a data bank
	generic(Naib:  natural := 16 ; Nr: natural := 16 ; Na: natural := 32 ; N: natural := 16 ; Nb: natural := 256);
	port (
		CLK : IN  std_logic;
		First_addr : IN std_logic_vector(Naib-1 downto 0);
		RST : IN std_logic
	);
end datapath;

architecture Structural of datapath is

	-- Components

	-- v0
	COMPONENT instruction_pointer
	GENERIC(Naib: natural);
	PORT(
		CLK, in_RST, Reset_base_addr: in std_logic;
		Base_addr: in std_logic_vector(Naib-1 downto 0);
		Output: out std_logic_vector(Naib-1 downto 0);
		flag_O, out_RST: out std_logic
	);
	END COMPONENT;

	COMPONENT instructions_bank
	GENERIC(Naib:  natural; N_instr: natural);
	PORT(
		CLK, in_RST: in std_logic;
		Addr: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(4*N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT binary_decoder
	GENERIC(N: natural ; Naib: natural);
	PORT(
		Full_instr: in  std_logic_vector(4*N-1 downto 0);
		Op, A, B, C: out std_logic_vector(N-1 downto 0);
		Reset_base_addr: out std_logic;
		Base_addr: out std_logic_vector(Naib-1 downto 0)
	);
	END COMPONENT;

	COMPONENT pipeline
	GENERIC(N: natural);
	PORT(
		CLK: in std_logic;
		IN_Op: in std_logic_vector(N-1 downto 0);
		IN_A, IN_B , IN_C: in std_logic_vector(N-1 downto 0);
		OUT_Op: out std_logic_vector(N-1 downto 0);
		OUT_A, OUT_B , OUT_C: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT register_file
	GENERIC(Na:  natural; N: natural; Nr: natural);
	PORT(
		CLK, RST, W: in std_logic;
		Addr_W: in std_logic_vector(Nr-1 downto 0);
		Data: in std_logic_vector(N-1 downto 0);
		Addr_A, Addr_B: in std_logic_vector(Nr-1 downto 0);
		QA, QB: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT arithmetic_logic_unit
	GENERIC(N: natural);
	PORT(
		Ctrl: in std_logic_vector(1 downto 0);
		A, B: in std_logic_vector(N-1 downto 0);
		S: out std_logic_vector(N-1 downto 0);
		flag_Z, flag_C, flag_N, flag_O: out std_logic
	);
	END COMPONENT;

	COMPONENT data_bank
	generic(Na:  natural; N: natural; Nb: natural);
	port(
		CLK, RST, RW: in std_logic;
		Addr_part1, Addr_part2: in std_logic_vector(N-1 downto 0);
		Input: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT combinatory_logic_W
	GENERIC(N: natural);
	PORT(
		Op: in std_logic_vector(N-1 downto 0);
		out_RST, Flag_W: out std_logic
	);
	END COMPONENT;

	-- v1
	COMPONENT multiplexer_reg_addr
	GENERIC(N: natural);
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	-- V2
	COMPONENT combinatory_logic_Ctrl_ALU
	GENERIC(N: natural);
	PORT(
		Op: in std_logic_vector(N-1 downto 0);
		Ctrl_ALU: out std_logic_vector(1 downto 0)
	);
	END COMPONENT;

	COMPONENT multiplexer_UAL
	GENERIC(N: natural);
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	-- V3
	COMPONENT combinatory_logic_DB
	GENERIC(N: natural);
	PORT(
		Op: in std_logic_vector(N-1 downto 0);
		out_RST, Flag_RW: out std_logic
	);
	END COMPONENT;

	COMPONENT multiplexer_DB_out
	GENERIC(N: natural);
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	-- V4
	COMPONENT multiplexer_reg_addr_bis
	GENERIC(N: natural);
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT multiplexer_DB_in
	GENERIC(N: natural);
	PORT(
		Op, A, B: in std_logic_vector(N-1 downto 0);
		Output_Addr_part1: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	-- V5
	COMPONENT combinatory_logic_JMPC
	GENERIC(N: natural; Naib: natural);
	PORT(
		Op, QA: in std_logic_vector(N-1 downto 0);
		Addr_in: in std_logic_vector(N-1 downto 0);
		QA_bis: out std_logic_vector(N-1 downto 0);
		RST_base_addr: out std_logic;
		Base_addr: out std_logic_vector(Naib-1 downto 0)
	);
	END COMPONENT;

	COMPONENT multiplexer_COMP
	GENERIC(N: natural);
	PORT(
		Op, QA, QB: in std_logic_vector(N-1 downto 0);
		Output: out std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	COMPONENT multiplexer_reset
	GENERIC(N: natural);
	PORT(
		RST_Base_addr1, RST_Base_addr2: in std_logic;
		Base_addr1, Base_addr2: in std_logic_vector(N-1 downto 0);
		out_RST_Base_addr: out std_logic;
		out_Base_addr: out std_logic_vector(N-1 downto 0)
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
	signal outIP_reset:		std_logic;		-- Reset flag for the instructions bank
	signal inRF_reset:		std_logic;		-- Reset flag for the register file
	signal inRF_W:				std_logic;		-- Write flag for the register file

	-- Additions for v1
	signal inRF_AddrA:		std_logic_vector(N-1 downto 0);
	signal outRF_A:			std_logic_vector(N-1 downto 0);

	-- Additions for v2
	signal inRF_AddrB:		std_logic_vector(N-1 downto 0);
	signal inALU_Ctrl:		std_logic_vector(1 downto 0);
	signal inALU_A:			std_logic_vector(N-1 downto 0);
	signal outALU_S:			std_logic_vector(N-1 downto 0);

	-- Additions for v3
	signal inDB_reset:		std_logic;		-- Reset flag for the data bank
	signal inDB_RW:			std_logic;		-- Read/write flag for the data bank
	signal inDB_Addr_part1:	std_logic_vector(N-1 downto 0);
	signal inDB_Addr_part2:	std_logic_vector(N-1 downto 0);
	signal outDB:				std_logic_vector(N-1 downto 0);

	-- Additions for v4
	signal outRF_B:			std_logic_vector(N-1 downto 0);
	signal outP3_B:			std_logic_vector(N-1 downto 0);

	-- Additions for v5
	signal outCL_JMPC:					std_logic_vector(N-1 downto 0);
	signal inter_mux:						std_logic_vector(N-1 downto 0);
	signal outBD_RST_Base_addr:		std_logic;
	signal outBD_Base_addr:				std_logic_vector(N-1 downto 0);
	signal outCL_JMPC_RST_Base_addr:	std_logic;
	signal outCL_JMPC_Base_addr:		std_logic_vector(N-1 downto 0);





	begin
		--					v0: Supports AFC

--		IP:	instruction_pointer	generic map(Naib => Naib)
--											port map(CLK, RST, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open, outIP_reset);
--		IB: 	instructions_bank	generic map(Naib => Naib,
--														N_instr => 4*N)
--										port map(CLK, outIP_reset,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		generic map(N => N)
--										port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C);
--		P1:	pipeline				generic map(N => N)
--										port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inP2.B, open);
--		RF:	register_file		generic map(Na => Na,
--														N => N,
--														Nr => N)
--										port map(CLK, inRF_reset, inRF_W,
--													outP4.A(Nr-1 downto 0), outP4.B, (others => '0'), (others => '0'),
--																				open, open);
--		P2:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0),
--																				inP3.Op, inP3.A, inP3.B, open);
--		ALU:	arithmetic_logic_unit	generic map(N => N)
--										port map((others => '0'), (others => '0'), (others => '0'),
--																				open,
--																				open, open, open, open);
--		P3:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0),
--																				inP4.Op, inP4.A, inP4.B, open);
--		DB:	data_bank			generic map(Na => Na,
--														N => N,
--														Nb => Nb)
--										port map('0', '0', '0',
--													(others => '0'), (others => '0'), (others => '0'),
--																				open);
--		P4:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0),
--																				outP4.Op, outP4.A, outP4.B, open);
--		CLW:	combinatory_logic_W	generic map(N => N)
--										port map(outP4.Op,
--																				inRF_reset, inRF_W);

		--					v1: Support for AFC & COP

--		IP:	instruction_pointer	generic map(Naib => Naib)
--											port map(CLK, RST, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open, outIP_reset);
--		IB: 	instructions_bank	generic map(Naib => Naib,
--														N_instr => 4*N)
--										port map(CLK, outIP_reset,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		generic map(N => N)
--										port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C);
--		P1:	pipeline				generic map(N => N)
--										port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inRF_AddrA, open);
--		RF:	register_file		generic map(Na => Na,
--														N => N,
--														Nr => N)
--										port map(CLK, inRF_reset, inRF_W,
--													outP4.A(Nr-1 downto 0), outP4.B,
--													inRF_AddrA(Nr-1 downto 0), (others => '0'),
--																				outRF_A, open);
--		P2:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP2.Op, inP2.A, inP2.B, Zeros(N-1 downto 0),
--																				inP3.Op, inP3.A, inP3.B, open);
--		ALU:	arithmetic_logic_unit	generic map(N => N)
--										port map((others => '0'), (others => '0'), (others => '0'),
--																				open,
--																				open, open, open, open);
--		P3:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP3.Op, inP3.A, inP3.B, Zeros(N-1 downto 0),
--																				inP4.Op, inP4.A, inP4.B, open);
--		DB:	data_bank			generic map(Na => Na,
--														N => N,
--														Nb => Nb)
--										port map('0', '0', '0',
--													(others => '0'), (others => '0'), (others => '0'),
--																				open);
--		P4:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0),
--																				outP4.Op, outP4.A, outP4.B, open);
--		CL_W:	combinatory_logic_W	generic map(N => N)
--										port map(outP4.Op,
--																				inRF_reset, inRF_W);
--		MPP2:	multiplexer_reg_addr generic map(N => N)
--										port map(inP2.Op, inRF_AddrA, outRF_A,
--																				inP2.B);

		--					v2: Added support for ADD, SOU & MUL

--		IP:	instruction_pointer	generic map(Naib => Naib)
--											port map(CLK, RST, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open, outIP_reset);
--		IB: 	instructions_bank	generic map(Naib => Naib,
--														N_instr => 4*N)
--										port map(CLK, outIP_reset,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		generic map(N => N,
--														Naib => Naib)
--										port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C,
--																				reset_base_addr, base_addr);
--		P1:	pipeline				generic map(N => N)
--										port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inRF_AddrA, inRF_AddrB);
--		RF:	register_file		generic map(Na => Na,
--														N => N,
--														Nr => N)
--										port map(CLK, inRF_reset, inRF_W,
--													outP4.A(Nr-1 downto 0), outP4.B,
--													inRF_AddrA(Nr-1 downto 0), inRF_AddrB(Nr-1 downto 0),
--																				outRF_A, inP2.B);
--		P2:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP2.Op, inP2.A, inP2.B, inP2.C,
--																				inP3.Op, inP3.A, inALU_A, inP3.B);
--		ALU:	arithmetic_logic_unit	generic map(N => N)
--										port map(inALU_Ctrl, inALU_A, inP3.C,
--																				outALU_S,
--																				open, open, open, open);
--		P3:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP3.Op, inP3.A, inP3.B, inP3.C,
--																				inP4.Op, inP4.A, inP4.B, open);
--		DB:	data_bank			generic map(Na => Na,
--														N => N,
--														Nb => Nb)
--										port map('0', '0', '0',
--													(others => '0'), (others => '0'), (others => '0'),
--																				open);
--		P4:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP4.Op, inP4.A, inP4.B, Zeros(N-1 downto 0),
--																				outP4.Op, outP4.A, outP4.B, open);
--		CL_W:	combinatory_logic_W	generic map(N => N)
--										port map(outP4.Op,
--																				inRF_reset, inRF_W);
--		MPP2:	multiplexer_reg_addr generic map(N => N)
--										port map(inP2.Op, inRF_AddrA, outRF_A,
--																				inP2.B);
--		CL_Ctrl:	combinatory_logic_Ctrl_ALU	generic map(N => N)
--										port map(inP3.Op,
--																				inALU_Ctrl);
--		MPP3:	multiplexer_UAL	generic map(N => N)
--										port map(inP3.Op, inALU_A, outALU_S,
--																				inP3.B);

		--					v3: Added support for LOAD

--		IP:	instruction_pointer	generic map(Naib => Naib)
--											port map(CLK, RST, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open, outIP_reset);
--		IB: 	instructions_bank	generic map(Naib => Naib,
--														N_instr => 4*N)
--										port map(CLK, outIP_reset,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		generic map(N => N,
--														Naib => Naib)
--										port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C,
--																				reset_base_addr, base_addr);
--		P1:	pipeline				generic map(N => N)
--										port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inRF_AddrA, inRF_AddrB);
--		RF:	register_file		generic map(Na => Na,
--														N => N,
--														Nr => N)
--										port map(CLK, inRF_reset, inRF_W,
--													outP4.A(Nr-1 downto 0), outP4.B,
--													inRF_AddrA(Nr-1 downto 0), inRF_AddrB(Nr-1 downto 0),
--																				outRF_A, inP2.B);
--		P2:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP2.Op, inP2.A, inP2.B, inP2.C,
--																				inP3.Op, inP3.A, inALU_A, inP3.C);
--		ALU:	arithmetic_logic_unit	generic map(N => N)
--										port map(inALU_Ctrl, inALU_A, inP3.C,
--																				outALU_S,
--																				open, open, open, open);
--		P3:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP3.Op, inP3.A, inP3.B, inP3.C,
--																				inP4.Op, inP4.A, inDB_Addr_part1, inDB_Addr_part2);
--		DB:	data_bank			generic map(Na => Na,
--														N => N,
--														Nb => Nb)
--										port map('0', inDB_reset, inDB_RW,
--													inDB_Addr_part1, inDB_Addr_part2, (others => '0'),
--																				outDB);
--		P4:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP4.Op, inP4.A, inP4.B, (others=>0),
--																				outP4.Op, outP4.A, outP4.B, open);
--		CL_W:	combinatory_logic_W	generic map(N => N)
--										port map(outP4.Op,
--																				inRF_reset, inRF_W);
--		MPP2:	multiplexer_reg_addr generic map(N => N)
--										port map(inP2.Op, inRF_AddrA, outRF_A,
--																				inP2.B);
--		CL_Ctrl:	combinatory_logic_Ctrl_ALU	generic map(N => N)
--										port map(inP3.Op,
--																				inALU_Ctrl);
--		MPP3:	multiplexer_UAL	generic map(N => N)
--										port map(inP3.Op, inALU_A, outALU_S,
--																				inP3.B);
--		CL_DB:	combinatory_logic_DB	generic map(N => N)
--										port map(inP4.Op,
--																				inDB_reset, inDB_RW);
--		MPP4:	multiplexer_DB_out	generic map(N => N)
--										port map(inP4.Op, inDB_Addr_part1, outDB,
--																				inP4.B);


		--					v4 (FINAL VERSION): Added support for STORE

--		IP:	instruction_pointer	generic map(Naib => Naib)
--											port map(CLK, RST, reset_base_addr,
--														base_addr,
--																				current_addr,
--																				open, outIP_reset);
--		IB: 	instructions_bank	generic map(Naib => Naib,
--														N_instr => 4*N)
--										port map(CLK, outIP_reset,
--													current_addr,
--																				out_instr_bank);
--		BD:	binary_decoder		generic map(N => N,
--														Naib => Naib)
--										port map(out_instr_bank,
--																				outBD.Op, outBD.A, outBD.B, outBD.C,
--																				reset_base_addr, base_addr);
--		P1:	pipeline				generic map(N => N)
--										port map(CLK,
--													outBD.Op, outBD.A, outBD.B, outBD.C,
--																				inP2.Op, inP2.A, inRF_AddrA, inRF_AddrB);
--		RF:	register_file		generic map(Na => Na,
--														N => N,
--														Nr => N)
--										port map(CLK, inRF_reset, inRF_W,
--													outP4.A(Nr-1 downto 0), outP4.B,
--													inRF_AddrA(Nr-1 downto 0), inRF_AddrB(Nr-1 downto 0),
--																				outRF_A, outRF_B);
--		P2:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP2.Op, inP2.A, inP2.B, inP2.C,
--																				inP3.Op, inP3.A, inALU_A, inP3.C);
--		ALU:	arithmetic_logic_unit	generic map(N => N)
--										port map(inALU_Ctrl, inALU_A, inP3.C,
--																				outALU_S,
--																				open, open, open, open);
--		P3:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP3.Op, inP3.A, inP3.B, inP3.C,
--																				inP4.Op, inP4.A, outP3_B, inDB_Addr_part2);
--		DB:	data_bank			generic map(Na => Na,
--														N => N,
--														Nb => Nb)
--										port map('0', inDB_reset, inDB_RW,
--													inDB_Addr_part1, inDB_Addr_part2, outP3_B,
--																				outDB);
--		P4:	pipeline				generic map(N => N)
--										port map(CLK,
--													inP4.Op, inP4.A, inP4.B, (others=>'0'),
--																				outP4.Op, outP4.A, outP4.B, open);
--		CL_W:	combinatory_logic_W	generic map(N => N)
--										port map(outP4.Op,
--																				inRF_reset, inRF_W);
--		MPP2:	multiplexer_reg_addr generic map(N => N)
--										port map(inP2.Op, inRF_AddrA, outRF_A,
--																				inP2.B);
--		CL_Ctrl:	combinatory_logic_Ctrl_ALU	generic map(N => N)
--										port map(inP3.Op,
--																				inALU_Ctrl);
--		MPP3:	multiplexer_UAL	generic map(N => N)
--										port map(inP3.Op, inALU_A, outALU_S,
--																				inP3.B);
--		CL_DB:	combinatory_logic_DB	generic map(N => N)
--										port map(inP4.Op,
--																				inDB_reset, inDB_RW);
--		MPP4:	multiplexer_DB_out	generic map(N => N)
--										port map(inP4.Op, outP3_B, outDB,
--																				inP4.B);
--		MPP2b:	multiplexer_reg_addr_bis	generic map(N => N)
--										port map(inP2.Op, inRF_AddrB, outRF_B,
--																				inP2.C);
--		MPDB:	multiplexer_DB_in	generic map(N => N)
--										port map(inP4.Op, inP4.A, outP3_B,
--																				inDB_Addr_part1);


		--					v5: Added support for EQU, INF, INFE, SUP, SUPE & JMPC

		IP:	instruction_pointer	generic map(Naib => Naib)
											port map(CLK, RST, reset_base_addr,
														base_addr,
																				current_addr,
																				open, outIP_reset);
		IB: 	instructions_bank	generic map(Naib => Naib,
														N_instr => 4*N)
										port map(CLK, outIP_reset,
													current_addr,
																				out_instr_bank);
		BD:	binary_decoder		generic map(N => N,
														Naib => Naib)
										port map(out_instr_bank,
																				outBD.Op, outBD.A, outBD.B, outBD.C,
																				outBD_RST_Base_addr, outBD_Base_addr);
		P1:	pipeline				generic map(N => N)
										port map(CLK,
													outBD.Op, outBD.A, outBD.B, outBD.C,
																				inP2.Op, inP2.A, inRF_AddrA, inRF_AddrB);
		RF:	register_file		generic map(Na => Na,
														N => N,
														Nr => N)
										port map(CLK, inRF_reset, inRF_W,
													outP4.A(Nr-1 downto 0), outP4.B,
													inRF_AddrA(Nr-1 downto 0), inRF_AddrB(Nr-1 downto 0),
																				outRF_A, outRF_B);
		P2:	pipeline				generic map(N => N)
										port map(CLK,
													inP2.Op, inP2.A, inP2.B, inP2.C,
																				inP3.Op, inP3.A, inALU_A, inP3.C);
		ALU:	arithmetic_logic_unit	generic map(N => N)
										port map(inALU_Ctrl, inALU_A, inP3.C,
																				outALU_S,
																				open, open, open, open);
		P3:	pipeline				generic map(N => N)
										port map(CLK,
													inP3.Op, inP3.A, inP3.B, inP3.C,
																				inP4.Op, inP4.A, outP3_B, inDB_Addr_part2);
		DB:	data_bank			generic map(Na => Na,
														N => N,
														Nb => Nb)
										port map('0', inDB_reset, inDB_RW,
													inDB_Addr_part1, inDB_Addr_part2, outP3_B,
																				outDB);
		P4:	pipeline				generic map(N => N)
										port map(CLK,
													inP4.Op, inP4.A, inP4.B, (others=>'0'),
																				outP4.Op, outP4.A, outP4.B, open);
		CL_W:	combinatory_logic_W	generic map(N => N)
										port map(outP4.Op,
																				inRF_reset, inRF_W);
		MPP2:	multiplexer_reg_addr generic map(N => N)
										port map(inP2.Op, inRF_AddrA, inter_mux,
																				inP2.B);
		CL_Ctrl:	combinatory_logic_Ctrl_ALU	generic map(N => N)
										port map(inP3.Op,
																				inALU_Ctrl);
		MPP3:	multiplexer_UAL	generic map(N => N)
										port map(inP3.Op, inALU_A, outALU_S,
																				inP3.B);
		CL_DB:	combinatory_logic_DB	generic map(N => N)
										port map(inP4.Op,
																				inDB_reset, inDB_RW);
		MPP4:	multiplexer_DB_out	generic map(N => N)
										port map(inP4.Op, outP3_B, outDB,
																				inP4.B);
		MPP2b:	multiplexer_reg_addr_bis	generic map(N => N)
										port map(inP2.Op, inRF_AddrB, outRF_B,
																				inP2.C);
		MPDB:	multiplexer_DB_in	generic map(N => N)
										port map(inP4.Op, inP4.A, outP3_B,
																				inDB_Addr_part1);
		CL_JMPC:	combinatory_logic_JMPC	generic map(N => N,
																	Naib => Naib)
										port map(inP2.Op, outRF_A, inP2.A,
																				outCL_JMPC, outCL_JMPC_RST_Base_addr, outCL_JMPC_Base_addr);
		MPCOMP:	multiplexer_COMP generic map(N => N)
										port map(inP2.Op, outCL_JMPC, outRF_B,
																				inter_mux);
		MPRST:	multiplexer_reset	generic map(N => N)
										port map(outBD_RST_Base_addr, outCL_JMPC_RST_Base_addr,
													outBD_Base_addr, outCL_JMPC_Base_addr,
																				reset_base_addr,
																				base_addr);

End Structural;
