--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   16:52:21 05/15/2019
-- Design Name:
-- Module Name:   /home/dandin/Bureau/4_IR I/Semestre 2/Projet systeme info/c-compiler-and-processor/processor/Testbenches/register_file_tb.vhd
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
         CLK : IN  std_logic;
         RST : IN  std_logic;
         W : IN  std_logic;
         Addr_W : IN  std_logic_vector(2 downto 0);
         Data : IN  std_logic_vector(7 downto 0);
         Addr_A : IN  std_logic_vector(2 downto 0);
         Addr_B : IN  std_logic_vector(2 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal W : std_logic := '0';
   signal Addr_W : std_logic_vector(2 downto 0) := (others => '0');
   signal Data : std_logic_vector(7 downto 0) := (others => '0');
   signal Addr_A : std_logic_vector(2 downto 0) := (others => '0');
   signal Addr_B : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          CLK => CLK,
          RST => RST,
          W => W,
          Addr_W => Addr_W,
          Data => Data,
          Addr_A => Addr_A,
          Addr_B => Addr_B,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= not CLK after CLK_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
    -- Write & read addr0; then write addr1 and read both addr; then reset.

    wait for 5*CLK_period;

    -- Write @ "00"
    CLK <= CLK;
    RW <= '1';
    Addr <= x"00";
    Data	<= x"2A";

    wait for 5*CLK_period;

    -- Read @ "00"
    RW <= '0';
    Addr <= x"00";


    wait for 10*CLK_period;


    -- Write @ "07"
    RW <= '1';
    Addr <= x"07";
    Data <= x"FF";

    wait for 5*CLK_period;

    -- Read @ "00"
    RW <= '0';
    Addr <= x"00";

    wait for 5*CLK_period;

    -- Read @ "07"
    RW <= '0';
    Addr <= x"07";


    wait for 10*CLK_period;


    -- Reset
    RST <= '1';

		wait;
	end process;

END;
