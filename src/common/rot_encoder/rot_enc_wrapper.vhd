-- !!! MAKE OVER?UNDERFLOW PROTECTION
-- make input mux sel register to direct the encoders to their registers
-- make register rest
-- make global reset
clk_i       : in std_logic;
swa_i       : in std_logic_vector(5 - 1 downto 0);
swb_i       : in std_logic_vector(5 - 1 downto 0);
enc_reg_sel : in std_logic_vector(16 - 1 downto 0); -- 3 bits for each encoder
rot_enc_reg_o_0 : out encoder_ram;
rot_enc_reg_o_1 : out encoder_ram;
rot_enc_reg_o_2 : out encoder_ram;
rot_enc_reg_o_3 : out encoder_ram;
rot_enc_reg_o_4 : out encoder_ram

constant DATA_WIDTH : integer := 16

signal rotary_event : std_logic_vector(5 - 1 downto 0);
signal rotary_dir   : std_logic_vector(5 - 1 downto 0);
signal encoder_data_ram : encoder_ram(5-1 downto 0); --all the encoder ram for each rotery encoder packed into a 5x16x16 bit bus

begin

    rot_enc_0 : entity work.customized_rotary_encoder_quad
    generic map (
      g_DATA_WIDTH => DATA_WIDTH
    )
    port map (
      clk_i => clk_i,
      swa_i => swa_i(0),
      swb_i => swb_i(0),
      enc_mux_sel => enc_mux_sel(2 downto 0),
      rotary_event_o => rotary_event(0),
      rotary_dir_o => rotary_dir(0),
      encoder_data_ram_o => encoder_data_ram(0),
      data_out_o => open
    );

    rot_enc_1 : entity work.customized_rotary_encoder_quad
    generic map (
      g_DATA_WIDTH => DATA_WIDTH
    )
    port map (
      clk_i => clk_i,
      swa_i => swa_i(1),
      swb_i => swb_i(1),
      enc_mux_sel => enc_mux_sel(5 downto 3),
      rotary_event_o => rotary_event(1),
      rotary_dir_o => rotary_dir(1),
      encoder_data_ram_o => encoder_data_ram(1),
      data_out_o => open
    );

    rot_enc_2 : entity work.customized_rotary_encoder_quad
    generic map (
      g_DATA_WIDTH => DATA_WIDTH
    )
    port map (
      clk_i => clk_i,
      swa_i => swa_i(2),
      swb_i => swb_i(2),
      enc_mux_sel => enc_mux_sel(8 downto 6),
      rotary_event_o => rotary_event(2),
      rotary_dir_o => rotary_dir(2),
      encoder_data_ram_o => encoder_data_ram(2),
      data_out_o => open
    );

    rot_enc_3 : entity work.customized_rotary_encoder_quad
    generic map (
      g_DATA_WIDTH => DATA_WIDTH
    )
    port map (
      clk_i => clk_i,
      swa_i => swa_i(3),
      swb_i => swb_i(3),
      enc_mux_sel => enc_mux_sel(11 downto 9),
      rotary_event_o => rotary_event(3),
      rotary_dir_o => rotary_dir(3),
      encoder_data_ram_o => encoder_data_ram(3),
      data_out_o => open
    );

    rot_enc_4 : entity work.customized_rotary_encoder_quad
    generic map (
      g_DATA_WIDTH => DATA_WIDTH
    )
    port map (
      clk_i => clk_i,
      swa_i => swa_i(4),
      swb_i => swb_i(4),
      enc_mux_sel => enc_mux_sel(14 downto 12),
      rotary_event_o => rotary_event(4),
      rotary_dir_o => rotary_dir(4),
      encoder_data_ram_o => encoder_data_ram(4),
      data_out_o => open
    );
  

    -- output each block of 16 registers to the cpu registers for reading
    rot_enc_reg_o_0 <= encoder_data_ram(0);
    rot_enc_reg_o_1 <= encoder_data_ram(1);
    rot_enc_reg_o_2 <= encoder_data_ram(2);
    rot_enc_reg_o_3 <= encoder_data_ram(3);
    rot_enc_reg_o_4 <= encoder_data_ram(4);