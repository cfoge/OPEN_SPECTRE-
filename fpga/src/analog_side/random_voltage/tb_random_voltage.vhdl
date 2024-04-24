library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use std.textio.all;

entity tb_random_voltage is
end entity tb_random_voltage;

architecture tb_behavioral of tb_random_voltage is
  signal Clock, Recycle, Rst: std_logic := '0';
  signal Noise_Freq: std_logic_vector(9 downto 0) := (others => '0');
  signal Slew_In: std_logic_vector(2 downto 0) := "000";
  signal Noise_1, Noise_2: std_logic_vector(9 downto 0);

  file output_file: text;
  
begin



  DUT: entity work.random_voltage
    port map (
      Clock => Clock,
      Recycle => Recycle,
      Rst => Rst,
      Noise_Freq => Noise_Freq,
      Slew_In => Slew_In,
      Noise_1 => Noise_1,
      Noise_2 => Noise_2
    );

  Clock_Process: process
  begin
      Clock <= not Clock;
      wait for 5 ns;
  end process Clock_Process;
  
    process
  begin
    file_open(output_file, "output.txt", write_mode);
    Rst <= '1';
    wait for 20 ns;
    Rst <= '0';
    for i in 50 to 100 loop
      Noise_Freq <= std_logic_vector(to_unsigned(i, Noise_Freq'length));
       wait for 22000 ns;--i*100 ns;
  
    end loop;
    
    file_close(output_file);
    wait;
  end process;

  -- Add additional processes or assertions for checking the output signals

end architecture tb_behavioral;
