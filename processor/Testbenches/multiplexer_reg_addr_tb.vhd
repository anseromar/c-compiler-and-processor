LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY multiplexer_reg_addr_tb IS
END multiplexer_reg_addr_tb;
 
ARCHITECTURE behavior OF multiplexer_reg_addr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT multiplexer_reg_addr
    PORT(
         Op : IN  std_logic_vector(7 downto 0);
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Op : std_logic_vector(7 downto 0) := (others => '0');
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(7 downto 0); 
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: multiplexer_reg_addr PORT MAP (
          Op => Op,
          A => A,
          B => B,
          Output => Output
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= not CLK after CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		-- Test with all possible operations (from x"01" to x"08") ,as well as the padding (x"FF") and error (anything else) cases.
		-- In normal cases, x"2A" (42) should be returned.

		wait for 5*CLK_period;
		
		-- ADD
		Op <= x"01";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- MUL
		Op <= x"02";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- SOU
		Op <= x"03";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- DIV
		Op <= x"04";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- COP
		Op <= x"05";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- AFC
		Op <= x"06";
		A  <= x"0D";
		B  <= x"2A";

		wait for 5*CLK_period;
		
		-- LOAD
		Op <= x"07";
		A  <= x"0D";
		B  <= x"2A";

		wait for 5*CLK_period;
		
		-- STORE
		Op <= x"08";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- Padding
		Op <= x"FF";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- Test/error
		Op <= x"00";
		A  <= x"2A";
		B  <= x"0D";

		wait for 5*CLK_period;
		
		-- Error
		Op <= x"2A";
		A  <= x"2A";
		B  <= x"0D";
		
		wait;
   end process;

END;
