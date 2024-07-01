-- ARTIX DESIGN FOR EMS SPECTRE -- Working tile Phantom

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;


entity CFOG_Phantom_G1 is
  port
  (
    sys_clk : in std_logic;
    sys_rst : in std_logic
);
    
    end CFOG_Phantom_G1;

architecture rtl of CFOG_Phantom_G1 is

-- System level IO
signal clk_100 : std_logic;
signal clk_40 : std_logic;

--signal rst : std_logic;



-- Microblaze Interupts
signal mb_int0 : std_logic;
signal mb_int1 : std_logic;
signal mb_int3 : std_logic;
signal vert_int : std_logic;

-- Framer Signals
signal h_sync : std_logic;
signal v_sync : std_logic;
signal video_on : std_logic;
signal sof : std_logic; -- curently unused



-- Sys Reg interface
signal matrix_out_addr : std_logic_vector(5 downto 0);
signal matrix_mask_out : std_logic_vector(63 downto 0);
signal matrix_load : std_logic;
signal invert_matrix : std_logic_vector(63 downto 0);
signal vid_span : std_logic_vector(7 downto 0);
signal out_addr : std_logic_vector(7 downto 0);
signal ch_addr : std_logic_vector(7 downto 0);
signal gain_in : std_logic_vector(4 downto 0);
signal anna_matrix_wr : std_logic;
signal rotery_addr_mux : std_logic_vector(3 downto 0);
signal rotery_enc_0 : std_logic_vector(31 downto 0);
signal rotery_enc_1 : std_logic_vector(31 downto 0);
signal rotery_enc_2 : std_logic_vector(31 downto 0);
signal rotery_enc_3 : std_logic_vector(31 downto 0);
signal rotery_enc_4 : std_logic_vector(31 downto 0);
signal rotery_enc_preset_w : std_logic;
signal rotery_enc_0_preset : std_logic_vector(31 downto 0);
signal rotery_enc_1_preset : std_logic_vector(31 downto 0);
signal rotery_enc_2_preset : std_logic_vector(31 downto 0);
signal rotery_enc_3_preset : std_logic_vector(31 downto 0);
signal rotery_enc_4_preset : std_logic_vector(31 downto 0);
signal button_matrix : std_logic_vector(31 downto 0);
signal led_output : std_logic_vector(31 downto 0);
signal led_global_pwm : std_logic_vector(31 downto 0);
signal lcd_backligh : std_logic;
signal fan_pwm : std_logic_vector(31 downto 0);
signal fan_rpm : std_logic_vector(31 downto 0);
signal pos_h_1 : std_logic_vector(8 downto 0);
signal pos_v_1 : std_logic_vector(8 downto 0);
signal zoom_h_1 : std_logic_vector(8 downto 0);
signal zoom_v_1 : std_logic_vector(8 downto 0);
signal circle_1 : std_logic_vector(8 downto 0);
signal gear_1 : std_logic_vector(8 downto 0);
signal lantern_1 : std_logic_vector(8 downto 0);
signal fizz_1 : std_logic_vector(8 downto 0);
signal pos_h_2 : std_logic_vector(8 downto 0);
signal pos_v_2 : std_logic_vector(8 downto 0);
signal zoom_h_2 : std_logic_vector(8 downto 0);
signal zoom_v_2 : std_logic_vector(8 downto 0);
signal circle_2 : std_logic_vector(8 downto 0);
signal gear_2 : std_logic_vector(8 downto 0);
signal lantern_2 : std_logic_vector(8 downto 0);
signal fizz_2 : std_logic_vector(8 downto 0);
signal noise_freq : std_logic_vector(9 downto 0);
signal slew_in : std_logic_vector(2 downto 0);
signal cycle_recycle : std_logic;
signal sync_sel_osc1 : std_logic_vector(1 downto 0);
signal osc_1_freq : std_logic_vector(9 downto 0);
signal osc_1_derv : std_logic_vector(9 downto 0);
signal sync_sel_osc2 : std_logic_vector(1 downto 0);
signal osc_2_freq : std_logic_vector(9 downto 0);
signal osc_2_derv : std_logic_vector(9 downto 0);
signal y_level : std_logic_vector(11 downto 0);
signal cr_level : std_logic_vector(11 downto 0);
signal cb_level : std_logic_vector(11 downto 0);
signal video_active_o : std_logic;

-- Digital Side
-- output video
 signal   YCRCB   : std_logic_vector (23 downto 0);
    -- inputs form analoge side
  signal  osc1_sqr :  std_logic;
  signal  osc2_sqr :  std_logic;
signal    random1  :  std_logic;
 signal   random2  :  std_logic;
 signal   audio_T  :  std_logic;
signal    audio_B  :  std_logic;
 signal   extinput :  std_logic;
   -- outputs to analoge side
signal    shape_a_analog :  std_logic_vector(7 downto 0);
 signal   shape_b_analog :  std_logic_vector(7 downto 0);
signal    acm_out1_o :  std_logic;
 signal   acm_out2_o :  std_logic;
 
 -- Video out
 
 signal        y  :  std_logic_vector(7 downto 0);
  signal      cb :  std_logic_vector(7 downto 0);
  signal      cr :  std_logic_vector(7 downto 0);
 signal       r  :  std_logic_vector(7 downto 0);
   signal     g  :  std_logic_vector(7 downto 0);
   signal     b  :  std_logic_vector(7 downto 0);

--DEBUG
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
    clk                 => sys_clk,
    rst                 => sys_rst,
    clk_100_o => clk_100,
    clk_40_out => clk_40,
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
  clk_25mhz => clk_40, -- better name, curently this si the pixel clk
  -- add reset
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
  sys_clk        => clk_100,
  clk_x          => '1',-- needs to be the programible devided pixel clk,
  clk_y          => h_sync,-- needs to be the programible devided Hsync,
  clk_25_in      => clk_40,
  rst            => sys_rst,-- need to make syncro to 40clk
  YCRCB          => YCRCB,
  matrix_in_addr => matrix_out_addr,
  matrix_load    => matrix_load,
  matrix_mask_in => matrix_mask_out,
  invert_matrix  => invert_matrix,
  vid_span       => vid_span,
  clk_x_out      => open,--clk_x_out,
  clk_y_out      => open,--clk_y_out,
  video_on       => open,
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
  port
  map (
  clk            => clk_100,
  rst            => sys_rst, -- make syncro with clk 100
  wr             => anna_matrix_wr,
  vsync          => v_sync,
  hsync          => h_sync,
  out_addr       => out_addr,
  ch_addr        => ch_addr,
  gain_in        => gain_in,
  pos_h_1        => pos_h_1,
  pos_v_1        => pos_v_1,
  zoom_h_1       => zoom_h_1,
  zoom_v_1       => zoom_v_1,
  circle_1       => circle_1,
  gear_1         => gear_1,
  lantern_1      => lantern_1,
  fizz_1         => fizz_1,
  pos_h_2        => pos_h_2,
  pos_v_2        => pos_v_2,
  zoom_h_2       => zoom_h_2,
  zoom_v_2       => zoom_v_2,
  circle_2       => circle_2,
  gear_2         => gear_2,
  lantern_2      => lantern_2,
  fizz_2         => fizz_2,
  noise_freq     => noise_freq,
  slew_in        => slew_in,
  cycle_recycle  => cycle_recycle,
  YUV_in         => open,--YUV_in,
  y_alpha        => open,--y_alpha,
  u_alpha        => open,--u_alpha,
  v_alpha        => open,--v_alpha,
  audio_in_t     => open,--audio_in_t,
  audio_in_b     => open,--audio_in_b,
  audio_in_sig   => open,--audio_in_sig,
  sync_sel_osc1  => sync_sel_osc1,
  osc_1_freq     => osc_1_freq,
  osc_1_derv     => osc_1_derv,
  sync_sel_osc2  => sync_sel_osc2,
  osc_2_freq     => osc_2_freq,
  osc_2_derv     => osc_2_derv,
  audio_in_sig_i => open,--audio_in_sig_i,
  dsm_hi_i       => acm_out1_o,
  dsm_lo_i       => acm_out2_o,
  vid_span       => vid_span,
  y_out          => y_out,
  u_out          => u_out,
  v_out          => v_out
  );
------------------------------------------------
-- VIDEO OUT WRAPPER
------------------------------------------------
--ycbcr2rgb_inst : entity ycbcr2rgb_simple 
--  Port map( 
--        y  => ,
--        cb => ,
--        cr => ,
--        r  => ,
--        g  => ,
--        b  => 
--        );
-- DVI generator (CLK MUX x10)

------------------------------------------------
-- DEBUG
------------------------------------------------
freq_cnt_inst : entity work.freq_cnt
  port
  map (
  clk_25mhz       => clk_25mhz,-- need 25mhz clk form cpu wrapper also
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
