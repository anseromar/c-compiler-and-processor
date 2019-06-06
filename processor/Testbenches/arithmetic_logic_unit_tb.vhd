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
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         Ctrl : IN  std_logic_vector(1 downto 0);
         S : OUT  std_logic_vector(15 downto 0);
         flag_Z : OUT  std_logic;
         flag_C : OUT  std_logic;
         flag_N : OUT  std_logic;
         flag_O : OUT  std_logic
        );
    END COMPONENT;


   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal Ctrl : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(15 downto 0);
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
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;


   -- Stimulus process
   stim_proc: process
   begin
		-- All operations without peculiar flag or issue
		
		wait for 5*CLK_period; --> 1
		
		-- Addition
		Ctrl <= "01";
		A	<= x"0029";
		B	<= x"0001";
		
		wait for 5*CLK_period; --> 2
		
		-- Substraction
		Ctrl <= "10";
		A <= x"002B";
		B <= x"0001";
		
		wait for 5*CLK_period; --> 3
		
		-- Multiplication
		Ctrl <= "11";
		A <= x"0006";
		B <= x"0007";
		
		
		-- Flags
		
		wait for 5*CLK_period; --> 4
		
		-- C: Carry (with null output) (addition)
		Ctrl <= "01";
		A <= x"FFFF";
		B <= x"0001";
		
		wait for 5*CLK_period; --> 5
		
		-- Z: Null output (substraction)
		Ctrl <= "10";
		A <= x"002A";
		B <= x"002A";
		
		wait for 5*CLK_period; --> 6
		
		-- Z: Null output (multiplication)
		Ctrl <= "11";
		A <= x"002A";
		B <= x"0000";
		
		wait for 5*CLK_period; --> 7
		
		-- C: Carry (addition)
		Ctrl <= "01";
		A <= x"FFFF";
		B <= x"2AFF";
		
		wait for 5*CLK_period; --> 8
	
		-- C: Carry (substraction)
		Ctrl <= "10";
		A <= x"FF7F";
		B <= x"FFFF";
		
		
		wait for 5*CLK_period; --> 9
		
		-- N: Negative output (addition)
		Ctrl <= "01";
		A <= x"0001";
		B <= x"F000";
		
		wait for 5*CLK_period; --> 10
		
		-- N: Negative output (substraction)
		Ctrl <= "10";
		A <= x"0001";
		B <= x"002B";
		
		
		wait for 5*CLK_period; --> 11
		
		-- O: Overflow (multiplication)
		Ctrl <= "11";
		A <= x"1000";
		B <= x"1000";
		
		wait;
   end process;

END;
