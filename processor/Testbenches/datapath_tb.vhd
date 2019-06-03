LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY datapath_tb IS
END datapath_tb;
 
ARCHITECTURE behavior OF datapath_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         CLK : IN  std_logic;
         IP : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal IP : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          CLK => CLK,
          IP => IP,
          RST => RST
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		
		-- Test with default values
		wait for 10*CLK_period;
		
		-- Reset IP
		IP <= x"0000";
		
		wait for 5*CLK_period;
		
		-- Full reset of the entire processor
		RST <= '1';
		
		wait for 5*CLK_period;

      wait;
   end process;

END;
