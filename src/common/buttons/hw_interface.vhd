
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.types_pkg.all;

entity hw_interface is

  port
  (
    reset_n           : in std_logic;
    clock_i           : in std_logic;
    debounce_strobe_i : in std_logic := '1'; -- Strobe for debounce ~10ms    
    -- Keypad Input
    columns_i : in std_logic_vector(4 - 1 downto 0);
    rows_o    : out std_logic_vector(8 - 1 downto 0);
    -- Button state
    button_state_o   : out std_logic_vector(8 * 4 - 1 downto 0);
    button_event_irq : out std_logic
  );

end hw_interface;
architecture Behavioral of hw_interface is
begin

  debounced_button_decoder_inst : entity work.debounced_button_decoder
    generic
    map (
    g_NUM_KEY_ROWS    => 8, -- double check these vals
    g_NUM_KEY_COLUMNS => 4
    )
    port map
    (
      reset_n           => reset_n,
      clock_i           => clock_i,
      debounce_strobe_i => debounce_strobe_i,
      columns_i         => columns_i,
      rows_o            => rows_o,
      button_state_o    => button_state_o,
      button_event_o    => button_event_o
    );

    button_event_irq <=  or_reduce(button_event_o);

  rot_enc_wrapper_inst : entity work.rot_enc_wrapper
    port
    map (
    clk_i           => clk_i,
    swa_i           => swa_i,
    swb_i           => swb_i,
    enc_reg_sel     => enc_reg_sel,
    rot_enc_reg_o_0 => rot_enc_reg_o_0,
    rot_enc_reg_o_1 => rot_enc_reg_o_1,
    rot_enc_reg_o_2 => rot_enc_reg_o_2,
    rot_enc_reg_o_3 => rot_enc_reg_o_3,
    rot_enc_reg_o_4 => rot_enc_reg_o_4
    );

end Behavioral;