
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: random_voltage by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;

use ieee.std_logic_1164.all;

entity random_voltage is

  port (
    Clock, recycle, rst : in std_logic;
    noise_freq : in std_logic_vector(9 downto 0);
    slew_in : in std_logic_vector(2 downto 0);
    noise_1 : out std_logic_vector(9 downto 0);
    noise_2 : out std_logic_vector(9 downto 0);
    extra_in   : in std_logic
    );

end random_voltage;

architecture Behavioral of random_voltage is

  signal spio_out_1, spio_out_2  : std_logic_vector(7 downto 0);
  signal count : std_logic_vector(9 downto 0);
  signal noise_1_to_slew, noise_2_to_slew, slew_out_1, slew_out_2 : std_logic_vector(9 downto 0);
  signal Sin,x , cnt_rst, cnt_match, sipo_clk  : std_logic := '0';
  signal mux_in, mux_in_des : std_logic_vector(7 downto 0) := "01100011"; -- only inputs 0,1,5,6 are set to gnd so i set the rest to 1 i guess
  signal sipo_dac_1, sipo_dac_2 : std_logic_vector(3 downto 0);
  signal mux_sel_in : std_logic_vector(2 downto 0);

begin

  

  sipo_clk <= cnt_match;
  
  sipo_1 : entity work.shift_sipo
    port map(
      Clock => sipo_clk, 
      SinA => Sin, 
      SinB => Sin, 
      rst => rst,
      Pout => spio_out_1
      );

      sipo_dac_1 <= spio_out_1(3 downto 0);
      sipo_dac_2 <= spio_out_1(0) & spio_out_1(1) & spio_out_1(2) & spio_out_1(3);
      


  sipo_2 : entity work.shift_sipo
      port map(
        Clock => sipo_clk, 
        SinA => spio_out_1(7), 
        SinB => spio_out_1(7), 
        rst => '0',
        Pout => spio_out_2
        );

    mux_in_des <= mux_in(7 downto 0);
    mux_sel_in <= spio_out_2(7)&spio_out_2(5)&(recycle xor extra_in);
    
  mux_random : entity work.mux_8_to_1
      Port map( 
          data => mux_in_des,
          sel => mux_sel_in,
          mux_out => sin
      );
      
    process(clock) begin 
        if (count > noise_freq) then 
            cnt_match <= '1';
        else 
            cnt_match <= '0';
        end if;
        
      end process;
      
  cnt_rst <=  cnt_match or rst; -- chroma_pin_74 does it also have this pin?
  
  random_freq: entity work.counter
    generic map (
        width => 10
    )
    port map (
        clk => clock,
        rst => cnt_rst,
        enable => '1',
        count => count
    );
  
  
slew_output_1 : entity work.slew_wraper
  Port map(
    clk => clock,
    rst => rst,
    slew_sel => slew_in,
    input => noise_1_to_slew,
    output => slew_out_1
   );
         
         
slew_output_2 : entity work.slew_wraper
  Port map(
    clk => clock,
    rst => rst,
    slew_sel => slew_in,
    input => noise_2_to_slew,
    output => slew_out_2
   );

      noise_1_to_slew(9 downto 6) <= sipo_dac_1;
      noise_1_to_slew(5 downto 0) <= (others => '0');
      noise_2_to_slew(9 downto 6) <= sipo_dac_2;
      noise_2_to_slew(5 downto 0) <= (others => '0');
      
      noise_1 <= slew_out_1;
      noise_2 <= slew_out_2;

      -- needs level contorl

end Behavioral;