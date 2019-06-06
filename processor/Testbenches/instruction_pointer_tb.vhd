LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY instruction_pointer_tb IS
END instruction_pointer_tb;
 
ARCHITECTURE behavior OF instruction_pointer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instruction_pointer
    PORT(
         CLK : IN  std_logic;
         in_RST : IN  std_logic;
         Reset_base_addr : IN  std_logic;
         Base_addr : IN  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(15 downto 0);
         flag_O : OUT  std_logic;
         out_RST : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal in_RST : std_logic := '0';
   signal Reset_base_addr : std_logic := '0';
   signal Base_addr : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(15 downto 0);
   signal flag_O : std_logic;
   signal out_RST : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instruction_pointer PORT MAP (
          CLK => CLK,
          in_RST => in_RST,
          Reset_base_addr => Reset_base_addr,
          Base_addr => Base_addr,
          Output => Output,
          flag_O => flag_O,
          out_RST => out_RST
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
		wait for 5*CLK_period;
		
		-- Change base address to middle-range address
		Base_addr <= x"002A";
		Reset_base_addr <= '1';
		
		wait for 5*CLK_period;
		
		-- Try changing after Base_addr has been changed 5 clock persiods before
		Base_addr <= x"000D";
		wait for 5*CLK_period;
		Reset_base_addr <= '1';

		wait for 5*CLK_period;
		
		-- Try changing base address without flag
		Base_addr <= x"002A";
		
		wait for 5*CLK_period;
		
		-- Change to close-to-end address to provoque an overflow within the next 
		Base_addr <= x"00FD";
		Reset_base_addr <= '1';
		wait for CLK_period;
		Base_addr <= x"000D";
		
		wait for 5*CLK_period;
		
		wait;
   end process;

END;
