library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity video_fx_wrapper is
  port
  (
    clk : in std_logic;
    rst : in std_logic;

    video_in       : in std_logic_vector(23 downto 0);
    hsync_i        : in std_logic;
    vsync_i        : in std_logic;
    video_active_i : in std_logic;

    video_out      : out std_logic_vector(23 downto 0);
    hsync_o        : out std_logic;
    vsync_o        : out std_logic;
    video_active_o : out std_logic

  );

end source_sel;

architecture rtl of video_fx_wrapper is

  signal hsync_d        : std_logic_vector(7 downto 0);
  signal vsync_d        : std_logic_vector(7 downto 0);
  signal video_active_d : std_logic_vector(7 downto 0);
  -- video signal wires
  signal vw_1, vw_2, vw_3, vw_4, vw_5, vw_6: std_logic_vector(23 downto 0);
  --pipeline registers for video signal
  signal v1_i, v1_o : std_logic_vector(23 downto 0);
  signal v2_i, v2_o : std_logic_vector(23 downto 0);
  signal v3_i, v3_o : std_logic_vector(23 downto 0);
begin

  delay_hv : process (clk) is -- delay chain for sync signals to match the pipeline length
  begin
    if rising_edge(clk) then
      -- put sync signal sinto shift regs
      hsync_d        <= hsync_d(6 downto 0) & hsync_i;
      vsync_d        <= vsync_d(6 downto 0) & vsync_i;
      video_active_d <= video_active_d(6 downto 0) & video_active_i;

      --shift video signal through pipeline regs
      v1_o <= v1_i;
      v2_o <= v2_i;
      v3_o <= v3_i;

    end if;

  end process;

  vw_1 <= video_in;
  --invert
  rgb_invert_inst : entity work.rgb_invert
    port map
    (
      pxclk         => clk,
      vid_pData_in  => vw_1,
      mode          => mode,
      vid_pData_out => vw_2
    );

  -- swap RGB channels
  rgb_swap_inst : entity work.rgb_swap
    port
    map (
    vid_pData_in  => vw_2,
    mode          => mode,
    vid_pData_out => v1_i -- goes to first pipeline stage
    );

  -- remap RGB using luts (remaps the gamma of the colour)
  RGB_remap_inst : entity work.RGB_remap -- ?2 clock delays to read from memory, add delay for bypass mode of 2 clocks
    port
    map (
    vid_pData_in  => v1_o,
    pixclk        => clk,
    mode          => mode,
    vid_pData_out => vw_3
    );

  -- posterise colours
  posterise_inst : entity work.posterise
    port
    map (
    vid_pData_in  => vw_3,
    mode          => mode,
    vid_pData_out => vw_4
    );

  -- colourise the video using ROM
  colourise_inst : entity work.colourise -- ?2 clock delays to read from memory, add delay for bypass mode of 2 clocks
    port
    map (
    vid_pData_in  => vw_4,
    pixclk        => clk,
    mode          => mode,
    vid_pData_out => vw_5
    );

  -- liquid glitch (mixes up colours by masking the bits and bitshifting them)
  liquid_glitch_inst : entity work.liquid_glitch
    port
    map (
    vid_pData_in  => vw_5,
    mode          => mode,
    vid_pData_out => vw_6
    );

  -- find and add smear effect

  -- tv effect
  tv_fx_inst : entity work.tv_fx
    port
    map (
    vid_pData_in  => vw_6,
    pixclk        => clk,
    hs            => hsync_i,
    vs            => vsync_i,
    mode          => mode,
    vid_pData_out => video_out
    );

  -- output delayed sync signals
  hsync_o        <= hsync_d(3);
  vsync_o        <= vsync_d(3);
  video_active_o <= video_active_d(3);

end rtl;