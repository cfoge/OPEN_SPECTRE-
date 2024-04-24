library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
library work;
use work.array_pck.all;


entity mixer_test_bench is
end mixer_test_bench;

architecture Behavioral of mixer_test_bench is
  -- Signals for your entity inputs and outputs
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '0';
  signal wr       : std_logic := '0';
  signal out_addr : integer := 0;
  signal ch_addr  : integer := 0;
  signal gain_in  : std_logic_vector(3 downto 0) := "0000";
  signal mixer_inputs : array_12(9 downto 0);
  signal outputs : array_12(9 downto 0);
    -- Signal to stop simulation
  signal stop_simulator : boolean := false;
  
  -- Clock period definition
  constant clk_period : time := 10 ns;

begin
  -- Instantiate the mixer_interface entity
  UUT: entity work.mixer_interface
    port map (
      clk => clk,
      rst => rst,
      wr => wr,
      out_addr => out_addr,
      ch_addr => ch_addr,
      gain_in => gain_in,
      mixer_inputs => mixer_inputs,
      outputs => outputs
    );

  -- Clock generation process
  process
  begin
    while not stop_simulator loop
      clk <= not clk;
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Reset and stimulus generation process
  process
  begin
    rst <= '1';
     mixer_inputs <= (others => (others => '0')); -- Initialize mixer_inputs to all zeros
    wait for 100 ns;
    rst <= '0';
    
    wait for 10 ns;  -- Initial delay

    -- Apply test stimuli here
    -- Example: Test writing gain values to mixer_interface
    wr <= '1';
    out_addr <= 0;
    ch_addr <= 0;
--    gain_in <= "1111"; -- Example gain value
   
    wait for 10 ns;
    wr <= '0';
--     mixer_inputs(0) <= (others => '1');
        mixer_inputs(0) <= "000000111111";
        mixer_inputs(2) <= "000000111111";
--    mixer_inputs(0) <= "000000000001";
--    mixer_inputs(1) <= "000000000010";
--    mixer_inputs(2) <= "000000000100";
--    mixer_inputs(3) <= "000000001000";
--      mixer_inputs(4) <= "000000010000";
    
    
    -- Loop through out_addr and ch_addr from 0 to 9
    for i in 0 to 9 loop
         out_addr <= i;
      for j in 0 to 9 loop
            ch_addr <= j;
        for k in 0 to 15 loop
            gain_in <= std_logic_vector(to_unsigned(k, gain_in'length));
            
            wr <= '1'; -- Pulse wr high
            wait for 10 ns;
            wr <= '0'; -- Pulse wr low
            wait for 10 ns;
          end loop;
      end loop;
    end loop;
    
     wait for 40 ns;
    
    -- Add more test cases here as needed

    stop_simulator <= true;  -- Stop simulation after all test cases
    wait;
  end process;

  -- Monitor process (for simulation)
  process
  begin
    wait for 5 ns;  -- Initial delay
    while not stop_simulator loop
      -- Monitor the outputs of your_entity here
--      report "outputs = " & to_string(outputs);
      wait for clk_period;
    end loop;
    wait;
  end process;



end Behavioral;
