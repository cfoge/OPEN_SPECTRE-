----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2024 21:16:54
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port ( ja_p1 : in STD_LOGIC;
           ja_n1 : in STD_LOGIC;
           ja_p2 : in STD_LOGIC;
           ja_n2 : in STD_LOGIC;
           btn0 : in STD_LOGIC;
           btn1  : in STD_LOGIC;
           sw0  : in STD_LOGIC;
           clk : in STD_LOGIC;
           led0 : out STD_LOGIC;
           led1 : out STD_LOGIC;
           led2 : out STD_LOGIC;
           led3 : out STD_LOGIC
           
           
           );
end top_level;

architecture Behavioral of top_level is

constant   g_NUM_KEY_ROWS      : integer := 5;
 constant   g_NUM_KEY_COLUMNS   : integer := 6;

signal rotary_event_o :  std_logic;
signal rotary_dir_o   :  std_logic;                 -- '1': Left, '0' :Right 
signal data_out_o     :  std_logic_vector(16-1 downto 0);

signal    button_state_o      : std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);
signal    button_event_o      : std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);   

attribute keep : string;
attribute keep of data_out_o : signal is "true";
attribute keep of rotary_event_o : signal is "true";
attribute keep of rotary_dir_o : signal is "true";



begin

--debounced_button_decoder_inst : entity work.debounced_button_decoder
--  generic map (
--    g_NUM_KEY_ROWS => g_NUM_KEY_ROWS,
--    g_NUM_KEY_COLUMNS => g_NUM_KEY_COLUMNS
--  )
--  port map (
--    reset_n => sw0,
--    clock_i => clk,
--    debounce_strobe_i => debounce_strobe_i,
--    columns_i => columns_i,
--    rows_o => rows_o,
--    button_state_o => button_state_o,
--    button_event_o => button_event_o
--  );
  
  customized_rotary_encoder_quad_inst : entity work.customized_rotary_encoder_quad
  generic map (
    g_DATA_WIDTH => 16
  )
  port map (
    clk_i => clk,
    swa_i => ja_p1,
    swb_i => ja_n1,
    rotary_event_o => rotary_event_o,
    rotary_dir_o => rotary_dir_o,
    data_out_o => data_out_o
  );

led0 <= rotary_event_o;
led1 <= rotary_dir_o;


end Behavioral;