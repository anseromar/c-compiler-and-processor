LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY register_file_tb IS
END register_file_tb;

ARCHITECTURE behavior OF register_file_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT register_file
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         W : IN  std_logic;
         Addr_W : IN  std_logic_vector(2 downto 0);
         Data : IN  std_logic_vector(7 downto 0);
         Addr_A : IN  std_logic_vector(2 downto 0);
         Addr_B : IN  std_logic_vector(2 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal W : std_logic := '0';
   signal Addr_W : std_logic_vector(2 downto 0) := (others => '0');
   signal Data : std_logic_vector(7 downto 0) := (others => '0');
   signal Addr_A : std_logic_vector(2 downto 0) := (others => '0');
   signal Addr_B : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          CLK => CLK,
          RST => RST,
          W => W,
          Addr_W => Addr_W,
          Data => Data,
          Addr_A => Addr_A,
          Addr_B => Addr_B,
          QA => QA,
          QB => QB
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
			-- Write & read (with A & B) @0; then write @1 and read both addr (with A & B same address then separate ones); then reset.

		wait for 5*CLK_period;

		-- Write @ "00" with B
		W <= '1';
		Addr_W <= x"00";
		Data	<= x"2A";

		wait for 5*CLK_period;

		-- Read @ "00" with A
		W <= '0';
		Addr_A <= x"00";
		
		wait for 5*CLK_period;
		
		-- Read @ "00" with B
		W <= '0';
		Addr_B <= x"00";
		
		
		wait for 10*CLK_period;
		
		
		-- Write @ "07"
		W <= '1';
		Addr_W <= x"07";
		Data <= x"FF";
		
		wait for 5*CLK_period;
		
		-- Read @ "00"
		W <= '0';
		Addr_A <= x"00";
		Addr_B <= x"00";
		
		wait for 5*CLK_period;
		
		-- Read @ "07"
		W <= '0';
		Addr_A <= x"07";
		Addr_B <= x"00";
		
		
		wait for 10*CLK_period;
		
		
		-- Reset
		RST <= '1';
		
		wait;
	end process;

END;
