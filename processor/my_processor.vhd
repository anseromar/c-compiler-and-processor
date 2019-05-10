library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use std.textio.all;
use ieee.std_logic_textio.all;

entity my_processor is
	constant LEN_SEL: natural := 16;
	constant LEN_INSTR: natural := 32;
	
	type instrArray is array(0 to 2**LEN_SEL-1) of std_logic_vector(LEN_INSTR-1 downto 0);
	
	impure function init_rom(filename: string) return instrArray;
end my_processor;

architecture Behavioral of my_processor is

	impure function init_rom(filename: string) return instrArray is
		file file_ptr: text;
		-- the rom is initialised with 1 because, in my code, an instruction filled with 1 does nothing. 
		-- It is a NOP (no operation), so the remaining instructions can't change the state of memories.
		variable rom: instrArray := (others => (others => '1'));
		variable f_line: line;
		variable slv_v: std_logic_vector(LEN_INSTR-1 downto 0);
		variable lines_read: integer := 0;
		
	begin
		file_open(file_ptr, filename, READ_MODE);

		while (not endfile(file_ptr)) loop
			-- a line is read from file_ptr
			readline(file_ptr, f_line);

			-- the line is converted into a std_logic_vector
			hread(f_line, slv_v);

			-- the std_logic_vector is assigned into memory
			rom(lines_read) := slv_v;

			lines_read := lines_read + 1;
		end loop;

		file_close(file_ptr);

		return rom;
	end function;


end Behavioral;

