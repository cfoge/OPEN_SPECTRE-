library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity customized_rotary_encoder_quad is
  generic (
    g_DATA_WIDTH : integer := 16
  );
  port (
    clk_i          : in  std_logic;
    swa_i          : in  std_logic;
    swb_i          : in  std_logic;
    rotary_event_o : out std_logic;
    rotary_dir_o   : out std_logic;                 -- '1': Left, '0' :Right 
    data_out_o     : out std_logic_vector(g_DATA_WIDTH-1 downto 0)
  );
end entity customized_rotary_encoder_quad;

architecture customized_rtl of customized_rotary_encoder_quad is
  type lut16x2_custom is array (0 to 15) of std_logic_vector(1 downto 0);

  -- Lookup table for the rotary encoder states
  signal enc_lut_custom : lut16x2_custom := ("00", "11", "01", "00",  -- 00
                                            "01", "00", "00", "11",  -- 01
                                            "11", "00", "00", "01",  -- 10
                                            "00", "01", "11", "00"); -- 11
  
  -- Output signals
  signal dir_d_custom     : std_logic := '0';
  signal reg_swa_custom, reg_swb_custom : std_logic_vector(1 downto 0) := "00";
  signal in_d1_custom, in_d2_custom, enc_custom : std_logic_vector(1 downto 0) := "00";
  signal count_int_custom : std_logic_vector(g_DATA_WIDTH-1 downto 0) := (others => '0');

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
     
      -- Process the encoder output and update counters
      if (enc_custom(0) = '1') then -- Valid event
        dir_d_custom <= enc_custom(1);
        if (dir_d_custom = enc_custom(1)) then -- No direction change
          rotary_dir_o <= enc_custom(1);
          rotary_event_o <= '1';
          if (enc_custom(1) = '1') then
            count_int_custom <= count_int_custom + 1;
          else
            count_int_custom <= count_int_custom - 1;
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

end architecture customized_rtl;
