LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pipeline_tb IS
END pipeline_tb;
 
ARCHITECTURE behavior OF pipeline_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pipeline
    PORT(
         CLK : IN  std_logic;
         IN_Op : IN  std_logic_vector(7 downto 0);
         IN_A : IN  std_logic_vector(7 downto 0);
         IN_B : IN  std_logic_vector(7 downto 0);
         IN_C : IN  std_logic_vector(7 downto 0);
         OUT_Op : OUT  std_logic_vector(7 downto 0);
         OUT_A : OUT  std_logic_vector(7 downto 0);
         OUT_B : OUT  std_logic_vector(7 downto 0);
         OUT_C : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal IN_Op : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_A : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_B : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_C : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal OUT_Op : std_logic_vector(7 downto 0);
   signal OUT_A : std_logic_vector(7 downto 0);
   signal OUT_B : std_logic_vector(7 downto 0);
   signal OUT_C : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipeline PORT MAP (
          CLK => CLK,
          IN_Op => IN_Op,
          IN_A => IN_A,
          IN_B => IN_B,
          IN_C => IN_C,
          OUT_Op => OUT_Op,
          OUT_A => OUT_A,
          OUT_B => OUT_B,
          OUT_C => OUT_C
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

    IN_Op <= x"2A";
    IN_A <= x"01";
    IN_B <= x"02";
    IN_C <= x"03";

    wait for 5*CLK_period;

    IN_Op <= x"00";
    IN_A <= x"00";
    IN_B <= x"00";
    IN_C <= x"00";

    wait for 5*CLK_period;

    IN_Op <= x"00";
    IN_A <= x"00";
    IN_B <= x"00";
    IN_C <= x"01";

    wait for 5*CLK_period;

    IN_Op <= x"00";
    IN_A <= x"00";
    IN_B <= x"00";
    IN_C <= x"FF";

    wait for 5*CLK_period;

    IN_Op <= x"FF";
    IN_A <= x"FF";
    IN_B <= x"FF";
    IN_C <= x"FF";

    wait;
   end process;

END;
