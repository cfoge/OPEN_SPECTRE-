-- CPU WRAPPER

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_wrapper is
  port
  (
    clk : in std_logic;
    rst : in std_logic;
    clk_100_o : out std_logic;
    clk_40_out : out std_logic;
    --------------------------------------------
    -- MICROBLAZE INTERFACE
    --------------------------------------------
    mb_int0  : in std_logic;
    mb_int1  : in std_logic;
    mb_int3  : in std_logic;
    vert_int : in std_logic;
    --------------------------------------------
    -- REGISTER INTERFACE
    --------------------------------------------
    -- Digital Matrix Control
    matrix_out_addr : out std_logic_vector(5 downto 0);
    matrix_mask_out : out std_logic_vector(63 downto 0);
    matrix_load     : out std_logic;
    invert_matrix   : out std_logic_vector(63 downto 0);
    -- Video Input Control
    vid_span : out std_logic_vector(7 downto 0);
    -- Analoge Matrix Control
    out_addr       : out std_logic_vector(7 downto 0);
    ch_addr        : out std_logic_vector(7 downto 0);
    gain_in        : out std_logic_vector(4 downto 0);
    anna_matrix_wr : out std_logic;

    -- rotery encoders
    rotery_addr_mux     : out std_logic_vector(3 downto 0);
    rotery_enc_0        : in std_logic_vector(31 downto 0);
    rotery_enc_1        : in std_logic_vector(31 downto 0);
    rotery_enc_2        : in std_logic_vector(31 downto 0);
    rotery_enc_3        : in std_logic_vector(31 downto 0);
    rotery_enc_4        : in std_logic_vector(31 downto 0);
    rotery_enc_preset_w : out std_logic;
    rotery_enc_0_preset : out std_logic_vector(31 downto 0);
    rotery_enc_1_preset : out std_logic_vector(31 downto 0);
    rotery_enc_2_preset : out std_logic_vector(31 downto 0);
    rotery_enc_3_preset : out std_logic_vector(31 downto 0);
    rotery_enc_4_preset : out std_logic_vector(31 downto 0);
    -- buttons
    button_matrix : in std_logic_vector(31 downto 0);
    -- leds
    led_output     : out std_logic_vector(31 downto 0);
    led_global_pwm : out std_logic_vector(31 downto 0);
    lcd_backligh   : out std_logic;
    -- fans
    fan_pwm : out std_logic_vector(31 downto 0);
    fan_rpm : in std_logic_vector(31 downto 0);

    -- Shape gen
    pos_h_1   : out std_logic_vector(8 downto 0);
    pos_v_1   : out std_logic_vector(8 downto 0);
    zoom_h_1  : out std_logic_vector(8 downto 0);
    zoom_v_1  : out std_logic_vector(8 downto 0);
    circle_1  : out std_logic_vector(8 downto 0);
    gear_1    : out std_logic_vector(8 downto 0);
    lantern_1 : out std_logic_vector(8 downto 0);
    fizz_1    : out std_logic_vector(8 downto 0);
    pos_h_2   : out std_logic_vector(8 downto 0);
    pos_v_2   : out std_logic_vector(8 downto 0);
    zoom_h_2  : out std_logic_vector(8 downto 0);
    zoom_v_2  : out std_logic_vector(8 downto 0);
    circle_2  : out std_logic_vector(8 downto 0);
    gear_2    : out std_logic_vector(8 downto 0);
    lantern_2 : out std_logic_vector(8 downto 0);
    fizz_2    : out std_logic_vector(8 downto 0);
    -- noise gen
    noise_freq    : out std_logic_vector(9 downto 0);
    slew_in       : out std_logic_vector(2 downto 0);
    cycle_recycle : out std_logic;
    -- osc 1 & 2
    sync_sel_osc1 : out std_logic_vector(1 downto 0);
    osc_1_freq    : out std_logic_vector(9 downto 0);
    osc_1_derv    : out std_logic_vector(9 downto 0);
    sync_sel_osc2 : out std_logic_vector(1 downto 0);
    osc_2_freq    : out std_logic_vector(9 downto 0);
    osc_2_derv    : out std_logic_vector(9 downto 0);
    -- Output Levels & output Active
    y_level        : out std_logic_vector(11 downto 0);
    cr_level       : out std_logic_vector(11 downto 0);
    cb_level       : out std_logic_vector(11 downto 0);
    video_active_o : out std_logic --a signal designed to black the video output under SW control


    --------------------------------------------
    -- VIDEO CANVAS???? BRAM INTERFACE?
    --------------------------------------------

  );

  end cpu_wrapper;

  architecture rtl of cpu_wrapper is

    signal sys_reg_clk : std_logic;
    signal sys_reg_rst : std_logic;
    signal sys_reg_en : std_logic;
    signal sys_reg_we : std_logic_vector(3 downto 0);
    signal sys_reg_addr : std_logic_vector(12 downto 0);
    signal sys_reg_dout : std_logic_vector(31 downto 0);
    signal sys_reg_din : std_logic_vector(31 downto 0);
    
    signal clk_100 : std_logic;
    signal clk_40 : std_logic;
  
  begin

  -- Microblaze Design Wrapper
  MB_CPU : entity design_1_wrapper
    port map
    (
      mb_int0         => mb_int0,
      mb_int1         => mb_int1,
      mb_int3         => mb_int3,
      sys_clk         => clk,
      clk_100_o        => clk_100,
      clk_40_0          => clk_40,
      sys_reg_addr    => sys_reg_addr,
      sys_reg_clk     => sys_reg_clk,
      sys_reg_din     => sys_reg_din,
      sys_reg_dout    => sys_reg_dout,
      sys_reg_en      => sys_reg_en,
      sys_reg_rst     => sys_reg_rst, -- what is this for??
      sys_reg_we      => sys_reg_we,
      sys_rst_n       => not rst, -- check that is correct
      vert_int        => vert_int,
      vid_canvas_addr => open, --vid_canvas_addr,
      vid_canvas_clk  => open, --vid_canvas_clk,
      vid_canvas_din  => open, --vid_canvas_din,
      vid_canvas_dout => open, --vid_canvas_dout,
      vid_canvas_en   => open, --vid_canvas_en,
      vid_canvas_rst  => open, --vid_canvas_rst,
      vid_canvas_we   => open--vid_canvas_we
    );

  -- CPU SYS REG
  cpu_reg_wrapper_inst : entity work.cpu_reg_wrapper
    port
    map (
    clk                 => sys_reg_clk,
    rst                 => rst,
    regs_en             => sys_reg_en,
    regs_wen            => sys_reg_we,
    regs_addr           => sys_reg_addr,
    regs_wr_data        => sys_reg_dout,
    regs_rd_data        => sys_reg_din,
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
    
    clk_40_out <= clk_40;

    end rtl;
