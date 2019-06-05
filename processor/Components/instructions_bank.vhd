library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

entity instructions_bank is
	-- Naib:		Generic size of the addresses in the instruction bank
	-- N_instr:	Generic size of the instructions (assembly operation  and its operands)
	generic(Naib:  natural := 16 ; N_instr: natural := 64);
	port(
		-- Clock, full reset of the processor
		-- Reset if '1'
		CLK, in_RST: in std_logic;
		-- Address of the memory space to read into
		Addr: in std_logic_vector(Naib-1 downto 0);
		-- Output
		Output: out std_logic_vector(N_instr-1 downto 0)
	);
end instructions_bank;


architecture Behavioral of instructions_bank is
	-- Getter of all the instructions defining the program to execute
	signal instr_b: instrArray := (others=>(others=>'1')); --:= init_rom(filename => "../../compiler/assembler/assembly.o");
	
	begin
		-- For testing purposes
		-- ========== BEGINNING OF TEST ==========
		-- AFC 0 1
		instr_b(0)	<= x"000600000001FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 255 0
		instr_b(1)	<= x"000800FF0000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 255
		instr_b(2)	<= x"0007000000FFFFFF" when in_RST = '0' else (others=>'1');
		-- STORE 0 0
		instr_b(3)	<= x"000800000000FFFF" when in_RST = '0' else (others=>'1');
		-- AFC 0 5
		instr_b(4)	<= x"000600000005FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 255 0
		instr_b(5)	<= x"000800FF0000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 255
		instr_b(6)	<= x"0007000000FFFFFF" when in_RST = '0' else (others=>'1');
		-- STORE 2 0
		instr_b(7)	<= x"000800020000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 0
		instr_b(8)	<= x"000700000000FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 255 0
		instr_b(9)	<= x"000800FF0000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 2
		instr_b(10)	<= x"000700000002FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 254 0
		instr_b(11)	<= x"0008000000FE0000" when in_RST = '0' else (others=>'1');
		-- LOAD 0 255
		instr_b(12)	<= x"0007000000FFFFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 1 254
		instr_b(13)	<= x"00070001000000FE" when in_RST = '0' else (others=>'1');
		-- INF 0 0 1
		instr_b(14)	<= x"0007000000000001" when in_RST = '0' else (others=>'1');
		-- STORE 255 0
		instr_b(15)	<= x"000800FF0000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 1 255
		instr_b(16)	<= x"0007000100FFFFFF" when in_RST = '0' else (others=>'1');
		-- JMPC 30 1
		instr_b(17)	<= x"0010001E0001FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 0
		instr_b(18)	<= x"000700000000FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 254 0
		instr_b(19)	<= x"0008000000FE0000" when in_RST = '0' else (others=>'1');
		-- AFC 0 1
		instr_b(20)	<= x"000600000001FFFF" when in_RST = '0' else (others=>'1');
		-- STORE 253 0
		instr_b(21)	<= x"000800FD0000FFFF" when in_RST = '0' else (others=>'1');
		-- LOAD 0 254
		instr_b(22)	<= x"00070000000000FE" when in_RST = '0' else (others=>'1');
		-- LOAD 1 253
		instr_b(23)	<= x"0007000100FDFFFF" when in_RST = '0' else (others=>'1');
		-- ADD 0 1 0
		instr_b(24)	<= x"0001000000010000" when in_RST = '0' else (others=>'1');
		-- STORE 254 0
		instr_b(25)	<= x"0008000000FE0000" when in_RST = '0' else (others=>'1');
		-- LOAD 0 254
		instr_b(26)	<= x"00070000000000FE" when in_RST = '0' else (others=>'1');
		-- STORE 0 0
		instr_b(27)	<= x"000800000000FFFF" when in_RST = '0' else (others=>'1');
		-- JMPC 9
		instr_b(28)	<= x"00090009FFFFFFFF" when in_RST = '0' else (others=>'1');
		-- ========== END OF TEST ==========
	
		instr_b(29 to 255) <= (others=>(others=>'1'));
		process
		begin
			wait until CLK'event and CLK='1';
			-- Full reset of the processor
			if in_RST = '1' then
				Output <= (others=>'0');
			-- Reading
			else
				Output <= instr_b(to_integer(unsigned(Addr)));
			end if;
		end process;
		
end Behavioral;
