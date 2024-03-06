


clk_i          : in  std_logic;
swa_i          : in  std_logic_vector(5-1 downto 0);
swb_i          : in  std_logic_vector(5-1 downto 0);



constant DATA_WIDTH : integer := 16

signal    rotary_event : std_logic_vector(5-1 downto 0);
signal    rotary_dir   : std_logic_vector(5-1 downto 0);    

type encoder_ram is array (0 to 15) of std_logic_vector(DATA_WIDTH-1 downto 0);

begin

encoder_1 : entity work.customized_rotary_encoder_quad
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    clk_i => clk_i,
    swa_i => swa_i(0),
    swb_i => swb_i(0),
    rotary_event_o => rotary_event(0),
    rotary_dir_o => rotary_dir(0),
    data_out_o => open
  );

  encoder_2 : entity work.customized_rotary_encoder_quad
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    clk_i => clk_i,
    swa_i => swa_i(1),
    swb_i => swb_i(1),
    rotary_event_o => rotary_event(1),
    rotary_dir_o => rotary_dir(1),
    data_out_o => open
  );

  encoder_3 : entity work.customized_rotary_encoder_quad
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    clk_i => clk_i,
    swa_i => swa_i(2),
    swb_i => swb_i(2),
    rotary_event_o => rotary_event(2),
    rotary_dir_o => rotary_dir(2),
    data_out_o => open
  );

  encoder_4 : entity work.customized_rotary_encoder_quad
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    clk_i => clk_i,
    swa_i => swa_i(3),
    swb_i => swb_i(3),
    rotary_event_o => rotary_event(3),
    rotary_dir_o => rotary_dir(3),
    data_out_o => open
  );

  encoder_5 : entity work.customized_rotary_encoder_quad
  generic map (
    DATA_WIDTH => DATA_WIDTH
  )
  port map (
    clk_i => clk_i,
    swa_i => swa_i(4),
    swb_i => swb_i(4),
    rotary_event_o => rotary_event(4),
    rotary_dir_o => rotary_dir(4),
    data_out_o => open
  );
