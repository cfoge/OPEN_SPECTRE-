
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: rolling_ave by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity moving_average is
generic (
  G_NBIT                     : integer := 10;
  G_AVG_LEN_LOG              : integer := 2 );
port (
  i_clk                      : in  std_logic;
  i_rstb                     : in  std_logic;
  i_sync_reset               : in  std_logic;
  -- input
  i_data_ena                 : in  std_logic;
  i_data                     : in  std_logic_vector(G_NBIT-1 downto 0);
  -- output
  o_data_valid               : out std_logic;
  o_data                     : out std_logic_vector(G_NBIT-1 downto 0));
end moving_average;
architecture rtl of moving_average is
type t_moving_average is array (0 to 2**G_AVG_LEN_LOG-1) of signed(G_NBIT-1 downto 0);
signal p_moving_average                 : t_moving_average;
signal r_acc                            : signed(G_NBIT+G_AVG_LEN_LOG-1 downto 0);  -- average accumulator
signal r_data_valid                     : std_logic;
begin
p_average : process(i_clk,i_rstb)
begin
  if(i_rstb='1') then
    r_acc              <= (others=>'0');
  p_moving_average   <= (others=>(others=>'0'));
  r_data_valid       <= '0';
  o_data_valid       <= '0';
  o_data             <= (others=>'0');
  elsif(rising_edge(i_clk)) then
  r_data_valid       <= i_data_ena;
  o_data_valid       <= r_data_valid;
  if(i_sync_reset='1') then
    r_acc              <= (others=>'0');
    p_moving_average   <= (others=>(others=>'0'));
  elsif(i_data_ena='1') then
    p_moving_average   <= signed(i_data)&p_moving_average(0 to p_moving_average'length-2);
    r_acc              <= r_acc + signed(i_data)-p_moving_average(p_moving_average'length-1);
  end if;
  o_data             <= std_logic_vector(r_acc(G_NBIT+G_AVG_LEN_LOG-1 downto G_AVG_LEN_LOG ));  -- divide by 2^G_AVG_LEN_LOG
  
  end if;
end process p_average;
end rtl;