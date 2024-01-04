library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity tb_osc_wrapper is
end entity tb_osc_wrapper;

architecture testbench of tb_osc_wrapper is
  signal clk, reset: std_logic := '0';
  signal freq: std_logic_vector(9 downto 0) := "0000001100";
  signal sync_sel: std_logic_vector(1 downto 0) := "00";
  signal sync_plus, sync_minus: std_logic := '0';
  signal dev_lv: std_logic_vector(11 downto 0) := "000000000001";
  signal sin_out: std_logic_vector(11 downto 0);
  signal square_out: std_logic;

  constant CLK_PERIOD: time := 10 ns; -- adjust as needed

begin

  uut: entity work.osc_wrapper
    port map (
      clk        => clk,
      reset      => reset,
      freq       => freq,
      sync_sel   => sync_sel,
      sync_plus  => sync_plus,
      sync_minus => sync_minus,
      dev_lv     => dev_lv,
      sin_out    => sin_out,
      square_out => square_out
    );

  clk_process: process
  begin
  
      clk <= not clk;
      wait for CLK_PERIOD / 2;
 
  end process;

  stimuli_process: process
  begin
    reset <= '1'; -- Activate reset
    wait for CLK_PERIOD * 5;
    reset <= '0'; -- Deactivate reset

    -- Test with different frequencies, sync modes, and deviation levels
--    for i in 0 to 100 loop
--      freq <= std_logic_vector(to_unsigned(i, freq'length));
--      sync_sel <= "00";
--      sync_plus <= '0';
--      sync_minus <= '0';
--      dev_lv <= std_logic_vector(to_unsigned(i mod 4096, dev_lv'length));

--      wait for CLK_PERIOD * 10; -- Adjust delay as needed
--    end loop;

    wait;
  end process;

end architecture testbench;
