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
         Addr_part1 : IN  std_logic_vector(15 downto 0);
         Addr_part2 : IN  std_logic_vector(15 downto 0);
         Input : IN  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal RW : std_logic := '0';
   signal Addr_part1 : std_logic_vector(15 downto 0) := (others => '0');
   signal Addr_part2 : std_logic_vector(15 downto 0) := (others => '0');
   signal Input : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_bank PORT MAP (
          CLK => CLK,
          RST => RST,
          RW => RW,
          Addr_part1 => Addr_part1,
          Addr_part2 => Addr_part2,
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
		Addr_part1 <= x"0000";
		Addr_part2 <= x"0000";
		Input	<= x"002A";

		wait for 5*CLK_period;

		-- Read @ "00"
		RW <= '0';
		Addr_part1 <= x"0000";
		Addr_part2 <= x"0000";


		wait for 10*CLK_period;


		-- Write @ "07"
		RW <= '1';
		Addr_part1 <= x"0000";
		Addr_part2 <= x"0007";
		Input <= x"00FF";

		wait for 5*CLK_period;

		-- Read @ "00"
		RW <= '0';
		Addr_part1 <= x"0000";
		Addr_part2 <= x"0000";

		wait for 5*CLK_period;

		-- Read @ "07"
		RW <= '0';
		Addr_part1 <= x"0000";
		Addr_part2 <= x"0007";


		wait for 10*CLK_period;

		-- TODO: Verify the database has been erased
		-- Reset
		RST <= '1';

		wait;
	end process;

END;
