LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY arithmetic_logic_unit_tb IS
END arithmetic_logic_unit_tb;
 
ARCHITECTURE behavior OF arithmetic_logic_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arithmetic_logic_unit
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Ctrl : IN  std_logic_vector(1 downto 0);
         S : OUT  std_logic_vector(7 downto 0);
         flag_Z : OUT  std_logic;
         flag_C : OUT  std_logic;
         flag_N : OUT  std_logic;
         flag_O : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal Ctrl : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(7 downto 0);
   signal flag_Z : std_logic;
   signal flag_C : std_logic;
   signal flag_N : std_logic;
   signal flag_O : std_logic;

	signal CLK : std_logic := '0';
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arithmetic_logic_unit PORT MAP (
          A => A,
          B => B,
          Ctrl => Ctrl,
          S => S,
          flag_Z => flag_Z,
          flag_C => flag_C,
          flag_N => flag_N,
          flag_O => flag_O
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= not CLK after CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for CLK_period*3;
		
		A <= x"01";
		B <= x"02";
		Ctrl <= "01";
		
      wait for CLK_period*3;

      -- insert stimulus here
		A <= x"01";
		B <= x"02";
		Ctrl <= "01";

      wait;
   end process;

END;
