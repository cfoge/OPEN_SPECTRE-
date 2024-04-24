
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: nco by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity nco is
port (
  i_clk                       : in  std_logic;
  i_rstb                      : in  std_logic;
  i_sync_reset                : in  std_logic;
  i_fcw                       : in  std_logic_vector(8 downto 0);
  o_nco                       : out std_logic_vector(8 downto 0));
end nco;
architecture rtl of nco is
signal r_sync_reset                : std_logic;
signal r_fcw                       : unsigned(8 downto 0);
signal r_nco                       : unsigned(8 downto 0);
begin
p_nco8 : process(i_clk,i_rstb)
begin
  if(i_rstb='1') then
    r_sync_reset      <= '1';
    r_fcw             <= (others=>'0');
    r_nco             <= (others=>'0');
  elsif(rising_edge(i_clk)) then
    r_sync_reset      <= i_sync_reset   ;
    r_fcw             <= unsigned(i_fcw);
    if(r_sync_reset='0') then
      r_nco             <= (others=>'0');
    else
      r_nco             <= r_nco + r_fcw;
    end if;
  end if;
end process p_nco8;
o_nco            <= std_logic_vector(r_nco);
end rtl;