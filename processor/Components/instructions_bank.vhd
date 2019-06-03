library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.common.all;

-- TODO: IP externe (avec incrémentation et renvoi)

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
	signal instr_b: instrArray; --:= init_rom(filename => "../../compiler/assembler/assembly.o");
	
	-- Omar, c'est pour toi ! Si tu peux coder en dur (comme ci-dessous) une dizaine (11 pour être sûrs) d'instructions assembleur selon ce format (décrit dans binary_decoder.vhd), ça serait super. :)
--	instr_b(0) <= 16#000600000001FFFF#;
--	instr_b(1) <= 16#0008FFFF0000FFFF#;
--	instr_b(2) <= 16#00070000FFFFFFFF#;
	
	begin
		instr_b <= (others=>(others=>'0')) when in_RST = '1';
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
