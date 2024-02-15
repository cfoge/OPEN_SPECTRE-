


--invert
  rgb_invert_inst : entity work.rgb_invert
  port map (
    pxclk => pxclk,
    vid_pData_in => vid_pData_in,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- swap RGB channels
  rgb_swap_inst : entity work.rgb_swap
  port map (
    vid_pData_in => vid_pData_in,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- remap RGB using luts (remaps the gamma of the colour)
  RGB_remap_inst : entity work.RGB_remap
  port map (
    vid_pData_in => vid_pData_in,
    pixclk => pixclk,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- posterise colours
  posterise_inst : entity work.posterise
  port map (
    vid_pData_in => vid_pData_in,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- colourise the video using ROM
  colourise_inst : entity work.colourise
  port map (
    vid_pData_in => vid_pData_in,
    pixclk => pixclk,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- liquid glitch (mixes up colours by masking the bits and bitshifting them)
  liquid_glitch_inst : entity work.liquid_glitch
  port map (
    vid_pData_in => vid_pData_in,
    mode => mode,
    vid_pData_out => vid_pData_out
  );

  -- find and add smear effect

  -- tv effect
  tv_fx_inst : entity work.tv_fx
  port map (
    vid_pData_in => vid_pData_in,
    pixclk => pixclk,
    hs => hs,
    vs => vs,
    mode => mode,
    vid_pData_out => vid_pData_out
  );
