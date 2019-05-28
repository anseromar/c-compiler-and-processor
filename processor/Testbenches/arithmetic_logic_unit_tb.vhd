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
		-- All operations without peculiar flag or issue wait for 5*CLK_period;
		
		wait for 5*CLK_period;
		
		-- Addition
		Ctrl <= "01";
		A	<= x"29";
		B	<= x"01";
		
		wait for 5*CLK_period;
		
		-- Substraction
		Ctrl <= "10";
		A <= x"2B";
		B <= x"01";
		
		wait for 5*CLK_period;
		
		-- Multiplication
		Ctrl <= "11";
		A <= x"06";
		B <= x"07";
		
		
		
		-- Flags
		wait for 15*CLK_period;
		
		
		-- Z: Null output (addition)
		Ctrl <= "01";
		A <= x"7F";
		B <= x"01";
		
		wait for 5*CLK_period;
		
		-- Z: Null output (substraction)
		Ctrl <= "10";
		A <= x"2A";
		B <= x"2A";
		
		wait for 5*CLK_period;
		
		-- Z: Null output (multiplication)
		Ctrl <= "11";
		A <= x"2A";
		B <= x"00";
		
		
		wait for 10*CLK_period;
		
		
		-- C: Carry (addition)
		Ctrl <= "01";
		A <= x"7F";
		B <= x"2A";
		
		wait for 5*CLK_period;
		
		-- C: Carry (substraction)
		Ctrl <= "10";
		A <= x"7F";
		B <= x"FF";
		
		
		wait for 10*CLK_period;
		
		
		-- N: Negative output (addition)
		Ctrl <= "01";
		A <= x"01";
		B <= x"F0";
		
		wait for 5*CLK_period;
		
		-- N: Negative output (substraction)
		Ctrl <= "10";
		A <= x"01";
		B <= x"2B";
		
		
		wait for 10*CLK_period;
		
		
		-- O: Overflow (multiplication, almost)
		Ctrl <= "11";
		A <= x"10";
		B <= x"10";
		
		wait for 5*CLK_period;
		
		-- O: Overflow (multiplication, large)
		Ctrl <= "11";
		A <= x"FF";
		B <= x"2A";
		
		wait;
   end process;

END;
