library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity rot_reg_tb is
end rot_reg_tb;

architecture sim of rot_reg_tb is
  constant CLK_PERIOD : time := 10 ns;  -- Clock period
  
  signal sw_a, sw_b, rst, clk : std_logic;
  signal input_addr : std_logic_vector(4 - 1 downto 0);
  signal output_data : std_logic_vector(12 - 1 downto 0);
  
begin

  -- Instantiate the Unit Under Test (UUT)
  uut : entity work.rot_reg
    port map (
      sw_a => sw_a,
      sw_b => sw_b,
      input_addr => input_addr,
      rst => rst,
      clk => clk
    );

  -- Clock process
  clk_process: process
  begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  -- Stimulus process
  stimulus_process: process
  begin
    -- Initialize inputs
    sw_a <= '0';
    sw_b <= '0';
    rst <= '1';
    input_addr <= "0001";
    
    wait for CLK_PERIOD * 5; -- Wait for some time with reset
    
    rst <= '0'; -- De-assert reset
    wait for CLK_PERIOD * 5; -- Wait for some time after reset
    
    -- Scenario 1: Addition mode

    sw_a <= '1'; -- Set input A
    sw_b <= '0'; -- Set input B
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_b <= '1'; -- Reset input A
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_a <= '0'; -- Reset input A
        wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_b <= '0'; -- Reset input A
    
    
        wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles

        sw_b <= '1'; -- Set input A
    sw_a <= '0'; -- Set input B
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_a <= '1'; -- Reset input A
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_b <= '0'; -- Reset input A
        wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_a <= '0'; -- Reset input A
    
            sw_b <= '1'; -- Set input A
    sw_a <= '0'; -- Set input B
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_a <= '1'; -- Reset input A
    wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_b <= '0'; -- Reset input A
        wait for CLK_PERIOD * 2; -- Wait for a few clock cycles
    sw_a <= '0'; -- Reset input A
    
    wait;
  end process;

  -- Output process
  output_process: process
  begin
    wait for CLK_PERIOD * 2; -- Wait for stable outputs
    -- Print output data for observation
--    report "Output data: " & to_string(output_data);
    wait;
  end process;

end sim;
