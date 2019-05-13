--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:41:20 05/13/2019
-- Design Name:   
-- Module Name:   /home/dandin/Bureau/4_IR I/Semestre 2/Projet systeme info/c-compiler-and-processor/processor/register_file_tb.vhd
-- Project Name:  processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY register_file_tb IS
END register_file_tb;
 
ARCHITECTURE behavior OF register_file_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         Addr_A : IN  std_logic_vector(2 downto 0);
         Addr_B : IN  std_logic_vector(2 downto 0);
         Addr_W : IN  std_logic_vector(2 downto 0);
         W : IN  std_logic;
         RST : IN  std_logic;
         Clk : IN  std_logic;
         Data : IN  std_logic_vector(7 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr_A : std_logic_vector(2 downto 0) := (others => '0');
   signal Addr_B : std_logic_vector(2 downto 0) := (others => '0');
   signal Addr_W : std_logic_vector(2 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal RST : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          Addr_A => Addr_A,
          Addr_B => Addr_B,
          Addr_W => Addr_W,
          W => W,
          RST => RST,
          Clk => Clk,
          Data => Data,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		

      wait for Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
