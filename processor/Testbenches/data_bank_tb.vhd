LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY data_bank_tb IS
END data_bank_tb;
 
ARCHITECTURE behavior OF data_bank_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_bank
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         RW : IN  std_logic;
         Addr : IN  std_logic_vector(7 downto 0);
         Input : IN  std_logic_vector(7 downto 0);
         Output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal RW : std_logic := '0';
   signal Addr : std_logic_vector(7 downto 0) := (others => '0');
   signal Input : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_bank PORT MAP (
          CLK => CLK,
          RST => RST,
          RW => RW,
          Addr => Addr,
          Input => Input,
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
		-- Write & read addr0; then write addr1 and read both addr; then reset.

		wait for 5*CLK_period;

		-- Write @ "00"
		RW <= '1';
		Addr <= x"00";
		Input	<= x"2A";

		wait for 5*CLK_period;

		-- Read @ "00"
		RW <= '0';
		Addr <= x"00";


		wait for 10*CLK_period;


		-- Write @ "07"
		RW <= '1';
		Addr <= x"07";
		Input <= x"FF";

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
