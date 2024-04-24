
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: rot_enc_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rot_enc_tb is
end rot_enc_tb;

architecture Behavioral of rot_enc_tb is

  -- Component Declaration
  component rot_enc is
    Port (
      clk        : in  STD_LOGIC;
      enc_a      : in  STD_LOGIC;
      enc_b      : in  STD_LOGIC;
      count_en   : out  STD_LOGIC;
      count_dir  : out  STD_LOGIC);
  end component;

  -- Input Signals
  signal clk        : STD_LOGIC := '0';
  signal enc_a      : STD_LOGIC := '0';
  signal enc_b      : STD_LOGIC := '0';

  -- Output Signals
  signal count_en   : STD_LOGIC;
  signal count_dir  : STD_LOGIC;

begin

  -- Instantiate the Design Under Test (DUT)
  uut : rot_enc
    port map (
      clk        => clk,
      enc_a      => enc_a,
      enc_b      => enc_b,
      count_en   => count_en,
      count_dir  => count_dir);

  -- Clock Generation Process
  process
  begin
    while true loop
      clk <= not clk;
      wait for 10 ns;
    end loop;
  end process;

  -- Stimulus Process
  process
  begin
    wait for 20 ns;
    enc_a <= '1';
    enc_b <= '0';
    wait for 10 ns;
    enc_a <= '0';
    enc_b <= '0';
    wait for 10 ns;
    enc_a <= '0';
    enc_b <= '1';
    wait for 10 ns;
    enc_a <= '1';
    enc_b <= '1';
    wait for 10 ns;
    enc_a <= '1';
    enc_b <= '0';
    wait for 10 ns;
    enc_a <= '0';
    enc_b <= '0';
    wait for 10 ns;
    enc_a <= '0';
    enc_b <= '1';
    wait for 10 ns;
    enc_a <= '1';
    enc_b <= '1';
    wait for 10 ns;
    wait;
  end process;

  -- Check Output Process
  process
  begin
    wait for 50 ns;
    assert count_en = '1' and count_dir = '0'
      report "Test Case 1 Failed"
      severity error;
    wait for 20 ns;
    assert count_en = '1' and count_dir = '1'
      report "Test Case 2 Failed"
      severity error;
    wait for 20 ns;
    assert count_en = '1' and count_dir = '0'
      report "Test Case 3 Failed"
      severity error;
    wait for 20 ns;
    assert count_en = '1' and count_dir = '1'
      report "Test Case 4 Failed"
      severity error;
    wait;
  end process;

end Behavioral;
