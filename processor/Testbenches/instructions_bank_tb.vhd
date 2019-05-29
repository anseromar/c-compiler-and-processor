LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY instructions_bank_tb IS
END instructions_bank_tb;
 
ARCHITECTURE behavior OF instructions_bank_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT instructions_bank
    PORT(
         CLK : IN  std_logic;
         Addr : IN  std_logic_vector(7 downto 0);
         Output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Addr : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: instructions_bank PORT MAP (
          CLK => CLK,
          Addr => Addr,
          Output => Output
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
		wait for 5*CLK_period;

		-- Launch
		-- CLK <= CLK;

		wait;
	end process;

END;