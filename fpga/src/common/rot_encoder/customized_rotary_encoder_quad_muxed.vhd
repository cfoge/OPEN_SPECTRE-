library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity customized_rotary_encoder_quad is
  generic
  (
    g_DATA_WIDTH : integer := 16
  );
  port
  (
    clk_i          : in std_logic;
    swa_i          : in std_logic;
    swb_i          : in std_logic;
    enc_mux_sel    : in std_logic_vector(3 - 1 downto 0); -- 3 bits to select form 16 possible registers to write to
    rotary_event_o : out std_logic;
    rotary_dir_o   : out std_logic; -- '1': Left, '0' :Right 
    -- add out of all 15 regs using encoder ram? or just break out to std logic?
    encoder_data_ram_o : out encoder_ram;
    data_out_o       : out std_logic_vector(g_DATA_WIDTH - 1 downto 0)
  );
end entity customized_rotary_encoder_quad;

architecture customized_rtl of customized_rotary_encoder_quad is
  -- put this in a package so that multiple modules can use it
  type encoder_ram is array (0 to 15) of std_logic_vector(DATA_WIDTH - 1 downto 0); -- make one of these for each encoder, so that each encoder can drive 1 of 15 regiosters
  signal encoder_data_ram : encoder_ram; --
  type lut16x2_custom is array (0 to 15) of std_logic_vector(1 downto 0);

  -- Lookup table for the rotary encoder states
  signal enc_lut_custom : lut16x2_custom := ("00", "11", "01", "00", -- 00
  "01", "00", "00", "11", -- 01
  "11", "00", "00", "01", -- 10
  "00", "01", "11", "00"); -- 11

  -- Output signals
  signal dir_d_custom                           : std_logic                                   := '0';
  signal reg_swa_custom, reg_swb_custom         : std_logic_vector(1 downto 0)                := "00";
  signal in_d1_custom, in_d2_custom, enc_custom : std_logic_vector(1 downto 0)                := "00";
  signal count_int_custom                       : std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal curent_reg_val                         : std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
begin

  -- Main process for rotary encoder
  enc_p_custom : process (clk_i)
  begin
    if rising_edge(clk_i) then
      -- Shift and update register values
      reg_swa_custom <= reg_swa_custom(0) & swa_i;
      reg_swb_custom <= reg_swb_custom(0) & swb_i;

      -- Combine inputs to form current and previous states
      in_d1_custom <= reg_swa_custom(1) & reg_swb_custom(1);
      in_d2_custom <= in_d1_custom;

      -- Use lookup table to determine the rotary encoder output
      enc_custom <= enc_lut_custom(conv_integer(in_d2_custom & in_d1_custom));

      -- grab the curent value form the selected register to use later to stop over/underflow
      curent_reg_val <= encoder_data_ram(to_integer(unsigned(enc_mux_sel)));

      -- Process the encoder output and update counters
      if (enc_custom(0) = '1') then -- Valid event
        dir_d_custom <= enc_custom(1);
        if (dir_d_custom = enc_custom(1)) then -- No direction change
          rotary_dir_o   <= enc_custom(1);
          rotary_event_o <= '1';
          if (enc_custom(1) = '1') then
            count_int_custom <= count_int_custom + 1;
            if (curent_reg_val ! = (others => '1')) then
              encoder_data_ram(to_integer(unsigned(enc_mux_sel))) <= encoder_data_ram(to_integer(unsigned(enc_mux_sel))) + 1;
            end if;
          else
            count_int_custom <= count_int_custom - 1;
            if (curent_reg_val ! = (others => '0')) then
              encoder_data_ram(to_integer(unsigned(enc_mux_sel))) <= encoder_data_ram(to_integer(unsigned(enc_mux_sel))) - 1;
            end if;
          end if;
        else
          rotary_event_o <= '0';
        end if;
      else
        rotary_event_o <= '0';
      end if;
    end if;
  end process enc_p_custom;

  -- Output the count value
  data_out_o <= count_int_custom;
  encoder_data_ram_o <= encoder_data_ram;

end architecture customized_rtl;