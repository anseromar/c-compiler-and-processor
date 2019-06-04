LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY datapath_tb IS
END datapath_tb;
 
ARCHITECTURE behavior OF datapath_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         CLK : IN  std_logic;
         First_addr : IN  std_logic_vector(255 downto 0);
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal First_addr : std_logic_vector(255 downto 0) := (others => '0');
   signal RST : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          CLK => CLK,
          First_addr => First_addr,
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
		First_addr <= x"0000";
		
		wait for 5*CLK_period;
		
		-- Full reset of the entire processor
		RST <= '1';
		
		wait for 5*CLK_period;

      wait;
   end process;

END;
