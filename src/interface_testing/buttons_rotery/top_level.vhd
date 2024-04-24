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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
  port
  (
    ja_p1 : in std_logic;
    ja_n1 : in std_logic;
    ja_p2 : in std_logic;
    ja_n2 : in std_logic;
    btn0  : in std_logic;
    btn1  : in std_logic;
    sw0   : in std_logic;
    clk   : in std_logic;
    led0  : out std_logic;
    led1  : out std_logic;
    led2  : out std_logic;
    led3  : out std_logic
  );
end top_level;

architecture Behavioral of top_level is

  constant g_NUM_KEY_ROWS    : integer := 5;
  constant g_NUM_KEY_COLUMNS : integer := 6;
  constant g_NUM_ROT         : integer := 5;

  signal rst : std_logic := '0';

  -- buttons
  signal debounce_strobe_i : std_logic := '1'; --should be a 10ms strobe
  signal columns_i      : std_logic_vector(g_NUM_KEY_COLUMNS - 1 downto 0);
  signal rows_o         : std_logic_vector(g_NUM_KEY_ROWS - 1 downto 0);
  signal button_state_o : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS - 1 downto 0);
  signal button_event_o : std_logic_vector(g_NUM_KEY_COLUMNS * g_NUM_KEY_ROWS - 1 downto 0);

  -- rotery encoders
  signal rotary_event_o : std_logic_vector(g_NUM_ROT - 1 downto 0); -- rotery events for all roter encoders to use for interupts
  signal input_addr     : std_logic_vector(4 - 1 downto 0); -- the address of which register the roterys whould write to from their personal register bank

  signal step_size : std_logic := '1'; --rotery encoder step size is 4, hook up so there is a way to control this  
  signal sw_a      : std_logic_vector(g_NUM_ROT - 1 downto 0);
  signal sw_b      : std_logic_vector(g_NUM_ROT - 1 downto 0);
  type output_rot_a is array (0 to 5 - 1) of std_logic_vector(12 downto 0 * (4 - 1) - 1 downto 0); -- each of these 0,1,2,3,4 represetn all 4 registers for each rotery as one long vector
  signal output_regs_rot : output_rot_a;

  attribute keep : string;
  -- attribute keep of rotary_event_o : signal is "true";
  attribute keep of output_regs_rot : signal is "true";

begin

  debounced_button_decoder_inst : entity work.debounced_button_decoder
    generic
    map (
    g_NUM_KEY_ROWS    => g_NUM_KEY_ROWS,
    g_NUM_KEY_COLUMNS => g_NUM_KEY_COLUMNS
    )
    port map
    (
      reset_n           => not rst,
      clock_i           => clk,
      debounce_strobe_i => debounce_strobe_i,
      columns_i         => columns_i,
      rows_o            => rows_o,
      button_state_o    => button_state_o,
      button_event_o    => button_event_o
    );
  g_GENERATE_ROT : for ii in 0 to 4 generate
    rot_reg_inst : entity work.rot_reg
      port
      map (
      sw_a          => sw_a(ii),
      sw_b          => sw_b(ii),
      step_size     => step_size,
      input_addr    => input_addr,
      rst           => rst,
      clk           => clk,
      output_regs_o => output_regs_rot(ii),
      rotary_event_o(ii)
      );
  end generate g_GENERATE_ROT;
  led0 <= rotary_event_o;
  led1 <= rotary_dir_o;
end Behavioral;