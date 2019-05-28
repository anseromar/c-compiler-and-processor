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
         IN_Op : IN  std_logic_vector(7 downto 0);
         IN_A : IN  std_logic_vector(15 downto 0);
         IN_B : IN  std_logic_vector(15 downto 0);
         IN_C : IN  std_logic_vector(15 downto 0);
         Ck : IN  std_logic;
         OUT_Op : IN  std_logic_vector(7 downto 0);
         OUT_A : IN  std_logic_vector(15 downto 0);
         OUT_B : IN  std_logic_vector(15 downto 0);
         OUT_C : IN  std_logic_vector(15 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal IN_Op : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_A : std_logic_vector(15 downto 0) := (others => '0');
   signal IN_B : std_logic_vector(15 downto 0) := (others => '0');
   signal IN_C : std_logic_vector(15 downto 0) := (others => '0');
   signal Ck : std_logic := '0';
   signal OUT_Op : std_logic_vector(7 downto 0) := (others => '0');
   signal OUT_A : std_logic_vector(15 downto 0) := (others => '0');
   signal OUT_B : std_logic_vector(15 downto 0) := (others => '0');
   signal OUT_C : std_logic_vector(15 downto 0) := (others => '0');

	signal CLK : std_logic := '0';
   constant CLK_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: pipeline PORT MAP (
          IN_Op => IN_Op,
          IN_A => IN_A,
          IN_B => IN_B,
          IN_C => IN_C,
          Ck => Ck,
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
    IN_A <= x"0A";
    IN_B <= x"0B";
    IN_C <= x"0C";

    wait;
   end process;

END;
