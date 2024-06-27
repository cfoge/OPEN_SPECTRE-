--Auto generated VHDL Wrapper
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;


entity cpu_reg_wrapper is
  port
  (
    clk : in std_logic;
    rst : in std_logic;
    -- Register Interface
    regs_en      : in std_logic;
    regs_wen     : in std_logic_vector(3 downto 0);
    regs_addr    : in std_logic_vector(12 downto 0);
    regs_wr_data : in std_logic_vector(31 downto 0);
    regs_rd_data : out std_logic_vector(31 downto 0);

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
    video_active_o : out std_logic

  )
end cpu_reg_wrapper;

architecture rtl of cpu_reg_wrapper is
begin

  signal read_sniiffer  : std_logic;
  signal sniff_rom_addr : std_logic_vector(7 downto 0) := others => 0;
  signal sniff_rom_data : std_logic_vector(63 downto 0);
 
  signal debug            : std_logic_vector(127 downto 0);
  signal exception_addr_o : std_logic;
  signal read_ram         : std_logic                    := 0;
  signal read_address     : std_logic_vector(7 downto 0) := others => 0;
  signal ram_data_out     : std_logic_vector(63 downto 0);


  digital_reg_file_i : entity work.digital_reg_file
    generic
    map (
    fpga_rev_id => fpga_rev_id
    );
  port map
  (
    regs_clk            => clk,
    regs_rst            => rst,
    regs_en             => regs_en,
    regs_wen            => regs_wen,
    regs_addr           => regs_addr,
    regs_wr_data        => regs_wr_data,
    regs_rd_data        => regs_rd_data,
    read_sniiffer       => read_sniiffer,
    sniff_rom_addr      => sniff_rom_addr,
    sniff_rom_data      => sniff_rom_data,
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
    matrix_out_addr     => matrix_out_addr,
    matrix_mask_out     => matrix_mask_out,
    matrix_load         => matrix_load,
    invert_matrix       => invert_matrix,
    vid_span            => vid_span,
    out_addr            => out_addr,
    ch_addr             => ch_addr,
    gain_in             => gain_in,
    anna_matrix_wr      => anna_matrix_wr,
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
    video_active_o      => video_active_o,
    debug               => debug,
    exception_addr_o    => exception_addr_o
  );

  reg_sniffer_i : entity work.reg_sniffer
    port
    map (
    clk             => clk,
    rst             => rst,
    read_ram        => read_ram,
    read_address    => read_address,
    ram_data_out    => ram_data_out,
    matrix_out_addr => matrix_out_addr,
    matrix_mask_out => matrix_mask_out,
    matrix_load     => matrix_load,
    out_addr        => out_addr,
    ch_addr         => ch_addr,
    gain_in         => gain_in,
    anna_matrix_wr  => anna_matrix_wr
    );

end rtl;