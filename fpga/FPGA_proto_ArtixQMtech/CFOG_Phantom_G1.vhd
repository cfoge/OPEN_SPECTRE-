-- ARTIX DESIGN FOR EMS SPECTRE -- Working tile Phantom

signal clk_25mhz       : std_logic;
signal clk_input_0     : std_logic;
signal clk_input_1     : std_logic;
signal clk_input_2     : std_logic;
signal clk_input_3     : std_logic;
signal clk_input_4     : std_logic;
signal clk_input_5     : std_logic;
signal clk_input_6     : std_logic;
signal clk_input_7     : std_logic;
signal clk_selected    : std_logic_vector(3 downto 0);
signal new_sample_flag : std_logic;
signal frequency       : std_logic_vector(23 downto 0);
begin
-- MICRO BLAZE 

-- in 100mhz clk, rst (comes from clk wizz pll directly)

-- out BRAM to registers
-- optinal SDRAM interfasce
-- register interface (100mhz clk)

------------------------------------------------
-- CPU WRAPPER
------------------------------------------------
cpu_wrapper : entity work.cpu_wrapper
  port map
  (
    clk                 => clk,
    rst                 => rst,
    mb_int0             => mb_int0,
    mb_int1             => mb_int1,
    mb_int3             => mb_int3,
    vert_int            => vert_int,
    matrix_out_addr     => matrix_out_addr,
    matrix_mask_out     => matrix_mask_out,
    matrix_load         => matrix_load,
    invert_matrix       => invert_matrix,
    vid_span            => vid_span,
    out_addr            => out_addr,
    ch_addr             => ch_addr,
    gain_in             => gain_in,
    anna_matrix_wr      => anna_matrix_wr,
    rotery_addr_mux     => rotery_addr_mux,
    rotery_enc_0        => rotery_enc_0,
    rotery_enc_1        => rotery_enc_1,
    rotery_enc_2        => rotery_enc_2,
    rotery_enc_3        => rotery_enc_3,
    rotery_enc_4        => rotery_enc_4,
    rotery_enc_preset_w => rotery_enc_preset_w,
    rotery_enc_0_preset => rotery_enc_0_preset,
    rotery_enc_1_preset => rotery_enc_1_preset,
    rotery_enc_2_preset => rotery_enc_2_preset,
    rotery_enc_3_preset => rotery_enc_3_preset,
    rotery_enc_4_preset => rotery_enc_4_preset,
    button_matrix       => button_matrix,
    led_output          => led_output,
    led_global_pwm      => led_global_pwm,
    lcd_backligh        => lcd_backligh,
    fan_pwm             => fan_pwm,
    fan_rpm             => fan_rpm,
    pos_h_1             => pos_h_1,
    pos_v_1             => pos_v_1,
    zoom_h_1            => zoom_h_1,
    zoom_v_1            => zoom_v_1,
    circle_1            => circle_1,
    gear_1              => gear_1,
    lantern_1           => lantern_1,
    fizz_1              => fizz_1,
    pos_h_2             => pos_h_2,
    pos_v_2             => pos_v_2,
    zoom_h_2            => zoom_h_2,
    zoom_v_2            => zoom_v_2,
    circle_2            => circle_2,
    gear_2              => gear_2,
    lantern_2           => lantern_2,
    fizz_2              => fizz_2,
    noise_freq          => noise_freq,
    slew_in             => slew_in,
    cycle_recycle       => cycle_recycle,
    sync_sel_osc1       => sync_sel_osc1,
    osc_1_freq          => osc_1_freq,
    osc_1_derv          => osc_1_derv,
    sync_sel_osc2       => sync_sel_osc2,
    osc_2_freq          => osc_2_freq,
    osc_2_derv          => osc_2_derv,
    y_level             => y_level,
    cr_level            => cr_level,
    cb_level            => cb_level,
    video_active_o      => video_active_o
  );

------------------------------------------------
-- HW INTERFACE (roterys, buttons, leds...)
------------------------------------------------

------------------------------------------------
-- LCD INTERFACE (roterys, buttons, leds...)
------------------------------------------------

------------------------------------------------
-- FRAMER
------------------------------------------------
vga_trimming_signals_inst : entity work.vga_trimming_signals -- need to make switchible??
  port
  map (
  clk_25mhz => clk_25mhz, -- better name
  h_sync    => h_sync,
  v_sync    => v_sync,
  -- add SOF
  video_on => video_on -- rename video active
  -- add row number out
  -- add pixel num out (per row)
  );

-- add microblaze adjustible devider that goes only to the x/y counters so that we can change the perceved resolution that way

-- FORMATS:
-- XGA Signal 1024 x 768 @ 60 Hz timing = 	65.0 MHz pixel clk
-- 720p60, 1280x720p60 = 74.250 MHz pixel clk //// 1080p30 has the same pixel clk freq
-- IN CLK 100MHZ
-- IN CLK 148....
-- 100mhz in (from clk wizz 1)
-- 148..... from 33.333 mhz in (crom clk wizz2)
-- buffg clock mux driven by SW 
-- enable generator/ devider to get different formats of video/video clk software controll
-- or do i just use these clks as the pixel clks and ignore doing diff formats, just one computer format and one video format (1080p and xga??)
--OUT CLK MUX
-- Framer generates HS,VS and active video based on format/clock selected (CLK MUX)

------------------------------------------------
-- DIGITAL SIDE
------------------------------------------------
digital_wrapper : entity work.test_digital_side
  port
  map (
  sys_clk        => sys_clk,
  clk_x          => clk_x,
  clk_y          => clk_y,
  clk_25_in      => clk_25_in,
  rst            => rst,
  YCRCB          => YCRCB,
  matrix_in_addr => matrix_in_addr,
  matrix_load    => matrix_load,
  matrix_mask_in => matrix_mask_in,
  invert_matrix  => invert_matrix,
  vid_span       => vid_span,
  clk_x_out      => clk_x_out,
  clk_y_out      => clk_y_out,
  video_on       => video_on,
  osc1_sqr       => osc1_sqr,
  osc2_sqr       => osc2_sqr,
  random1        => random1,
  random2        => random2,
  audio_T        => audio_T,
  audio_B        => audio_B,
  extinput       => extinput,
  shape_a_analog => shape_a_analog,
  shape_b_analog => shape_b_analog,
  acm_out1_o     => acm_out1_o,
  acm_out2_o     => acm_out2_o
  );


------------------------------------------------
-- VIDEO OUT WRAPPER
------------------------------------------------
analog_side_wrapper : entity work.analog_side
  port map (
    clk => clk,
    rst => rst,
    wr => wr,
    vsync => vsync,
    hsync => hsync,
    out_addr => out_addr,
    ch_addr => ch_addr,
    gain_in => gain_in,
    pos_h_1 => pos_h_1,
    pos_v_1 => pos_v_1,
    zoom_h_1 => zoom_h_1,
    zoom_v_1 => zoom_v_1,
    circle_1 => circle_1,
    gear_1 => gear_1,
    lantern_1 => lantern_1,
    fizz_1 => fizz_1,
    pos_h_2 => pos_h_2,
    pos_v_2 => pos_v_2,
    zoom_h_2 => zoom_h_2,
    zoom_v_2 => zoom_v_2,
    circle_2 => circle_2,
    gear_2 => gear_2,
    lantern_2 => lantern_2,
    fizz_2 => fizz_2,
    noise_freq => noise_freq,
    slew_in => slew_in,
    cycle_recycle => cycle_recycle,
    YUV_in => YUV_in,
    y_alpha => y_alpha,
    u_alpha => u_alpha,
    v_alpha => v_alpha,
    audio_in_t => audio_in_t,
    audio_in_b => audio_in_b,
    audio_in_sig => audio_in_sig,
    sync_sel_osc1 => sync_sel_osc1,
    osc_1_freq => osc_1_freq,
    osc_1_derv => osc_1_derv,
    sync_sel_osc2 => sync_sel_osc2,
    osc_2_freq => osc_2_freq,
    osc_2_derv => osc_2_derv,
    audio_in_sig_i => audio_in_sig_i,
    dsm_hi_i => dsm_hi_i,
    dsm_lo_i => dsm_lo_i,
    vid_span => vid_span,
    y_out => y_out,
    u_out => u_out,
    v_out => v_out
  );


------------------------------------------------
-- VIDEO OUT WRAPPER
------------------------------------------------
-- DVI generator (CLK MUX x10)

------------------------------------------------
-- DEBUG
------------------------------------------------
freq_cnt_inst : entity work.freq_cnt
  port
  map (
  clk_25mhz       => clk_25mhz,
  clk_input_0     => clk_input_0,
  clk_input_1     => clk_input_1,
  clk_input_2     => clk_input_2,
  clk_input_3     => clk_input_3,
  clk_input_4     => clk_input_4,
  clk_input_5     => clk_input_5,
  clk_input_6     => clk_input_6,
  clk_input_7     => clk_input_7,
  clk_selected    => clk_selected,
  new_sample_flag => new_sample_flag,
  frequency       => frequency
  );