-- CPU WRAPPER

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_reg_wrapper is
    port
    (

    );

-- Microblaze Design Wrapper
MB_CPU : entity design_1_wrapper
 port map (
    mb_int0 => mb_int0,
    mb_int1 => mb_int1,
    mb_int3 => mb_int3,
    sys_clk => sys_clk,
    sys_reg_addr => sys_reg_addr,
    sys_reg_clk => sys_reg_clk,
    sys_reg_din => sys_reg_din,
    sys_reg_dout => sys_reg_dout,
    sys_reg_en => sys_reg_en,
    sys_reg_rst => sys_reg_rst,
    sys_reg_we => sys_reg_we,
    sys_rst_n => sys_rst_n,
    vert_int => vert_int,
    vid_canvas_addr => vid_canvas_addr,
    vid_canvas_clk => vid_canvas_clk,
    vid_canvas_din => vid_canvas_din,
    vid_canvas_dout => vid_canvas_dout,
    vid_canvas_en => vid_canvas_en,
    vid_canvas_rst => vid_canvas_rst,
    vid_canvas_we => vid_canvas_we
  );

-- CPU SYS REG
cpu_reg_wrapper_inst : entity work.cpu_reg_wrapper
  port map (
    clk => clk,
    rst => rst,
    regs_en => regs_en,
    regs_wen => regs_wen,
    regs_addr => regs_addr,
    regs_wr_data => regs_wr_data,
    regs_rd_data => regs_rd_data,
    matrix_out_addr => matrix_out_addr,
    matrix_mask_out => matrix_mask_out,
    matrix_load => matrix_load,
    invert_matrix => invert_matrix,
    vid_span => vid_span,
    out_addr => out_addr,
    ch_addr => ch_addr,
    gain_in => gain_in,
    anna_matrix_wr => anna_matrix_wr,
    rotery_addr_mux => rotery_addr_mux,
    rotery_enc_0 => rotery_enc_0,
    rotery_enc_1 => rotery_enc_1,
    rotery_enc_2 => rotery_enc_2,
    rotery_enc_3 => rotery_enc_3,
    rotery_enc_4 => rotery_enc_4,
    rotery_enc_preset_w => rotery_enc_preset_w,
    rotery_enc_0_preset => rotery_enc_0_preset,
    rotery_enc_1_preset => rotery_enc_1_preset,
    rotery_enc_2_preset => rotery_enc_2_preset,
    rotery_enc_3_preset => rotery_enc_3_preset,
    rotery_enc_4_preset => rotery_enc_4_preset,
    button_matrix => button_matrix,
    led_output => led_output,
    led_global_pwm => led_global_pwm,
    lcd_backligh => lcd_backligh,
    fan_pwm => fan_pwm,
    fan_rpm => fan_rpm,
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
    sync_sel_osc1 => sync_sel_osc1,
    osc_1_freq => osc_1_freq,
    osc_1_derv => osc_1_derv,
    sync_sel_osc2 => sync_sel_osc2,
    osc_2_freq => osc_2_freq,
    osc_2_derv => osc_2_derv,
    y_level => y_level,
    cr_level => cr_level,
    cb_level => cb_level,
    video_active_o => video_active_o
  );
