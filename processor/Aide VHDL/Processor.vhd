----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:59 05/07/2019 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Processor is
	 generic (N: natural := 16);
end Processor;

architecture Behavioral of Processor is

	Component Pipeline Port ( 
			  Ck : in std_logic;
			  OPi : in  std_logic_vector(N/2-1 downto 0);
           Ai : in  std_logic_vector(N-1 downto 0);
           Bi : in  std_logic_vector(N-1 downto 0);
           Ci : in  std_logic_vector(N-1 downto 0);
           OPo : out  std_logic_vector(N/2-1 downto 0);
           Ao : out  std_logic_vector(N-1 downto 0);
           Bo : out  std_logic_vector(N-1 downto 0);
           Co : out  std_logic_vector(N-1 downto 0)
	);
	end Component;
	
	Component UAL port(
		A: in std_logic_vector (N-1 downto 0);
		B: in std_logic_vector (N-1 downto 0);
		Op: in std_logic_vector (N/2-1 downto 0);
		S: out std_logic_vector (N-1 downto 0);
		N, O, C, Z: out std_logic
	);
	end Component;
	
	Component Registers port(
		Ck : in  std_logic;
		RST : in std_logic;
		AA : in std_logic_vector(3 downto 0);
		AB : in std_logic_vector(3 downto 0);
		AW : in std_logic_vector(3 downto 0);
		QA : out std_logic_vector(N-1 downto 0);
		QB : out std_logic_vector(N-1 downto 0);
		W : in std_logic;
		DATA : in std_logic_vector(N-1 downto 0)
	);
	end Component;
	
	Component Decode  port ( 
			 ins_di : in  std_logic_vector(N-1 downto 0);
			 A : out std_logic_vector((N/2)-1 downto 0);
			 B : out std_logic_vector((N/2)-1 downto 0);
			 C : out std_logic_vector((N/2)-1 downto 0);
			 OP : out std_logic_vector((N/4)-1  downto 0)
	);
	end Component;
	
	Component MI port (
		ins_a : in std_logic_vector (N-1 downto 0);
		ins_di : out std_logic_vector (N*2-1 downto 0)
	);
	end Component;
	
	type stageRecord is record
			op : std_logic_vector(N/2-1 downto 0);
			a, b, c : std_logic_vector(N-1 downto 0);
	end record stageRecord;
	
	signal mibr_out, br_out,brual_out, ualmd_out, mdual_out, decode_out : stage_record;
	signal IP : std_logic_vector(N-1 downto 0);
	signal ins_di : std_logic_vector(N*2-1 downto 0);
	Ck : in  std_logic;
	
	MEMINS: MI port map(IP,ins_di);
	DEC: Decode port map(ins_di, decode_out.a,decode_out.b,decode_out.c,decode_out.op);
	--MIBR: Pipeline	port map(Ck,decode_out.op,decode_out.a,decode_out.b,decode_out.c,mibr_out.op,mibr_out.a,mibr_out.b,mibr_out.c);
	MIBR: Pipeline	port map(Ck,decode_out.op,decode_out.a,decode_out.b,decode_out.c,mibr_out.op,mibr_out.a,mibr_out.b,open);
	BR: Registers port map(Ck,x"0",x"0",x"0",??,x"0",x"0",??,??);
	--BRUAL: Pipeline port map(Ck,mibr_out.op,mibr_out.a,br_out.b,br_out.c,brual_out.op,brual_out.a,brual_out.b,brual_out.c);
	BRUAL: Pipeline port map(Ck,mibr_out.op,mibr_out.a,br_out.b,x"0",brual_out.op,brual_out.a,brual_out.b,open);
	--ALU: UAL port map(brual_out.b,brual_out.c,brual_out.op,ALUo);
	UALMD: Pipeline port map(Ck,brual_out.op,brual_out.a, ALUo,x"0",ualmd_out.op,ualmd_out.a,ualmd_out.b,open);
	--c3 <= x"0000";
	MDUAL: Pipeline port map(Ck, ualmd_out.op, uamld_out.a, x"0", mdual_out.a, mdual_out.b, open);
begin
	
end Behavioral;

