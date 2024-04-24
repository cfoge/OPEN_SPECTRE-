
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: slew_wraper by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity slew_wraper is
  Port (
    clk : in std_logic ;
    rst : in std_logic ;
    slew_sel : in std_logic_vector(2 downto 0);
    input: in std_logic_vector(9 downto 0);
    output: out std_logic_vector(9 downto 0)
   );
end slew_wraper;

architecture Behavioral of slew_wraper is
    signal out_fast: std_logic_vector(9 downto 0);
    signal out_med: std_logic_vector(9 downto 0);
    signal out_slow: std_logic_vector(9 downto 0);
    signal out_snail: std_logic_vector(9 downto 0);
    signal rst_n : std_logic;

begin
    rst_n <= rst;
    process(clk)
      begin
        if rising_edge(clk) then
            case slew_sel is
                when "000" => output <= input; 
                when "001" => output <= out_fast; 
                when "010" => output <= out_med; 
                when "011" => output <= out_slow; 
                when "100" => output <= out_snail;
                when others => output <= (others => '0');
            end case;
        end if;
    end process;

   slew_fast : entity work.moving_average 
       generic map (
        G_NBIT => 10,
        G_AVG_LEN_LOG => 2
       )
       port map (
        i_clk => clk,
        i_rstb => rst,
        i_sync_reset => rst,
        i_data_ena => '1',
        i_data => input,
        o_data_valid => open,
        o_data => out_fast
       );
       
   slew_med : entity work.moving_average 
       generic map (
        G_NBIT => 10,
        G_AVG_LEN_LOG => 4
       )
       port map (
        i_clk => clk,
        i_rstb => rst,
        i_sync_reset => rst,
        i_data_ena => '1',
        i_data => input,
        o_data_valid => open,
        o_data => out_med
       );
       
   slew_slow : entity work.moving_average 
       generic map (
        G_NBIT => 10,
        G_AVG_LEN_LOG => 6
       )
       port map (
        i_clk => clk,
        i_rstb => rst,
        i_sync_reset => rst,
        i_data_ena => '1',
        i_data => input,
        o_data_valid => open,
        o_data => out_slow
       );
       
   slew_snail : entity work.moving_average  
       generic map (
        G_NBIT => 10,
        G_AVG_LEN_LOG => 8
       )
       port map (
        i_clk => clk,
        i_rstb => rst,
        i_sync_reset => rst,
        i_data_ena => '1',
        i_data => input,
        o_data_valid => open,
        o_data => out_snail
       );

end Behavioral;
