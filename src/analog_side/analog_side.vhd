----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.09.2023 16:43:19
-- Design Name: 
-- Module Name: analog_side - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library work;
use work.array_pck.all;

entity analog_side is
  port
  (

    clk      : in std_logic;
    rst      : in std_logic;
    wr       : in std_logic;
    out_addr : in std_logic_vector(3 downto 0);
    ch_addr  : in std_logic_vector(3 downto 0);
    gain_in  : in std_logic_vector(4 downto 0);
    --analoge controls from reg file -- these should be added ot the matrix outputs so that you always have cxontroll of these things, these ins act as an offset
    pos_h_1       : in std_logic_vector(8 downto 0);
    pos_v_1       : in std_logic_vector(8 downto 0);
    zoom_h_1      : in std_logic_vector(8 downto 0);
    zoom_v_1      : in std_logic_vector(8 downto 0);
    circle_1      : in std_logic_vector(8 downto 0);
    gear_1        : in std_logic_vector(8 downto 0);
    lantern_1     : in std_logic_vector(8 downto 0);
    fizz_1        : in std_logic_vector(8 downto 0);
    pos_h_2       : in std_logic_vector(8 downto 0);
    pos_v_2       : in std_logic_vector(8 downto 0);
    zoom_h_2      : in std_logic_vector(8 downto 0);
    zoom_v_2      : in std_logic_vector(8 downto 0);
    circle_2      : in std_logic_vector(8 downto 0);
    gear_2        : in std_logic_vector(8 downto 0);
    lantern_2     : in std_logic_vector(8 downto 0);
    fizz_2        : in std_logic_vector(8 downto 0);
    noise_freq    : in std_logic_vector(9 downto 0);
    slew_in       : in std_logic_vector(2 downto 0);
    cycle_recycle : in std_logic;
    y_alpha       : in std_logic_vector(11 downto 0);
    u_alpha       : in std_logic_vector(11 downto 0);
    v_alpha       : in std_logic_vector(11 downto 0);

    --signals from the digital side
    audio_in_sig_i : in std_logic_vector(9 downto 0);
    dsm_hi_i       : in std_logic_vector(9 downto 0);
    dsm_lo_i       : in std_logic_vector(9 downto 0);
    y_digital      : in std_logic_vector(11 downto 0);
    u_digital      : in std_logic_vector(11 downto 0);
    v_digital      : in std_logic_vector(11 downto 0);

    -- signals to the digital side
    vid_span : out std_logic_vector(11 downto 0);
    y_out    : out std_logic_vector(11 downto 0);
    u_out    : out std_logic_vector(11 downto 0);
    v_out    : out std_logic_vector(11 downto 0)

  );
end analog_side;

architecture Behavioral of analog_side is

  signal mixer_inputs : array_12(10 downto 0);
  signal outputs      : array_12(19 downto 0); -- 12-bit wide outputs

  signal out_addr_int : integer;
  signal ch_addr_int  : integer;

  --matrix inputs
  signal osc1_out_sq  : std_logic_vector(9 downto 0);
  signal osc1_out_sin : std_logic_vector(9 downto 0);
  signal osc2_out_sq  : std_logic_vector(9 downto 0);
  signal osc2_out_sin : std_logic_vector(9 downto 0);
  signal noise_1      : std_logic_vector(9 downto 0);
  signal noise_2      : std_logic_vector(9 downto 0);
  signal audio_in_t   : std_logic_vector(9 downto 0);
  signal audio_in_b   : std_logic_vector(9 downto 0);
  signal audio_in_sig : std_logic_vector(9 downto 0);
  signal dsm_hi       : std_logic_vector(9 downto 0);
  signal dsm_lo       : std_logic_vector(9 downto 0);

  -- analoge matrix yuv out
  signal y_anna : std_logic_vector(11 downto 0);
  signal u_anna : std_logic_vector(11 downto 0);
  signal v_anna : std_logic_vector(11 downto 0);

  signal y_signal1 : std_logic_vector(11 downto 0);
  signal u_signal1 : std_logic_vector(11 downto 0);
  signal v_signal1 : std_logic_vector(11 downto 0);
  signal y_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal u_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal v_signal2 : std_logic_vector(11 downto 0) := (others => '0');
  signal y_result : std_logic_vector(11 downto 0) := (others => '0');
  signal u_result : std_logic_vector(11 downto 0) := (others => '0');
  signal v_result : std_logic_vector(11 downto 0) := (others => '0');

  --shape gen matrix output
  signal matrix_pos_h_1   : std_logic_vector(8 downto 0);
  signal matrix_pos_v_1   : std_logic_vector(8 downto 0);
  signal matrix_zoom_h_1  : std_logic_vector(8 downto 0);
  signal matrix_zoom_v_1  : std_logic_vector(8 downto 0);
  signal matrix_circle_1  : std_logic_vector(8 downto 0);
  signal matrix_gear_1    : std_logic_vector(8 downto 0);
  signal matrix_lantern_1 : std_logic_vector(8 downto 0);
  signal matrix_fizz_1    : std_logic_vector(8 downto 0);
  signal matrix_pos_h_2   : std_logic_vector(8 downto 0);
  signal matrix_pos_v_2   : std_logic_vector(8 downto 0);
  signal matrix_zoom_h_2  : std_logic_vector(8 downto 0);
  signal matrix_zoom_v_2  : std_logic_vector(8 downto 0);
  signal matrix_circle_2  : std_logic_vector(8 downto 0);
  signal matrix_gear_2    : std_logic_vector(8 downto 0);
  signal matrix_lantern_2 : std_logic_vector(8 downto 0);
  signal matrix_fizz_2    : std_logic_vector(8 downto 0);
  --shape gen mixed with register file inputs
  signal mixed_pos_h_1   : std_logic_vector(8 downto 0);
  signal mixed_pos_v_1   : std_logic_vector(8 downto 0);
  signal mixed_zoom_h_1  : std_logic_vector(8 downto 0);
  signal mixed_zoom_v_1  : std_logic_vector(8 downto 0);
  signal mixed_circle_1  : std_logic_vector(8 downto 0);
  signal mixed_gear_1    : std_logic_vector(8 downto 0);
  signal mixed_lantern_1 : std_logic_vector(8 downto 0);
  signal mixed_fizz_1    : std_logic_vector(8 downto 0);
  signal mixed_pos_h_2   : std_logic_vector(8 downto 0);
  signal mixed_pos_v_2   : std_logic_vector(8 downto 0);
  signal mixed_zoom_h_2  : std_logic_vector(8 downto 0);
  signal mixed_zoom_v_2  : std_logic_vector(8 downto 0);
  signal mixed_circle_2  : std_logic_vector(8 downto 0);
  signal mixed_gear_2    : std_logic_vector(8 downto 0);
  signal mixed_lantern_2 : std_logic_vector(8 downto 0);
  signal mixed_fizz_2    : std_logic_vector(8 downto 0);

begin

  out_addr_int <= to_integer(unsigned(out_addr));
  ch_addr_int  <= to_integer(unsigned(ch_addr));

  --analoge matrix inputs
  mixer_inputs(0)  <= osc1_out_sq  & "00";
  mixer_inputs(1)  <= osc1_out_sin & "00";
  mixer_inputs(2)  <= osc2_out_sq  & "00";
  mixer_inputs(3)  <= osc2_out_sin & "00";
  mixer_inputs(4)  <= noise_1     & "00";
  mixer_inputs(5)  <= noise_2     & "00";
  mixer_inputs(6)  <= audio_in_t   & "00";
  mixer_inputs(7)  <= audio_in_b  & "00";
  mixer_inputs(8)  <= audio_in_sig & "00";
  mixer_inputs(9)  <= dsm_hi       & "00";
  mixer_inputs(10) <= dsm_lo     & "00";

  --analoge matrix outputs
  matrix_pos_h_1   <= outputs(0)(11 downto 3);
  matrix_pos_v_1   <= outputs(1)(11 downto 3);
  matrix_zoom_h_1  <= outputs(2)(11 downto 3);
  matrix_zoom_v_1  <= outputs(3)(11 downto 3);
  matrix_circle_1  <= outputs(4)(11 downto 3);
  matrix_gear_1    <= outputs(5)(11 downto 3);
  matrix_lantern_1 <= outputs(6)(11 downto 3);
  matrix_fizz_1    <= outputs(7)(11 downto 3);
  matrix_pos_h_2   <= outputs(8)(11 downto 3);
  matrix_pos_v_2   <= outputs(9)(11 downto 3);
  matrix_zoom_h_2  <= outputs(10)(11 downto 3);
  matrix_zoom_v_2  <= outputs(11)(11 downto 3);
  matrix_circle_2  <= outputs(12)(11 downto 3);
  matrix_gear_2    <= outputs(13)(11 downto 3);
  matrix_lantern_2 <= outputs(14)(11 downto 3);
  matrix_fizz_2    <= outputs(15)(11 downto 3);
  y_anna           <= outputs(16);
  u_anna           <= outputs(17);
  v_anna           <= outputs(18);
  vid_span         <= outputs(19);

  analox_matrix : entity work.mixer_interface
    port map
    (
      clk          => clk,
      rst          => rst,
      wr           => wr,
      out_addr     => out_addr_int,
      ch_addr      => ch_addr_int,
      gain_in      => gain_in,
      mixer_inputs => mixer_inputs,
      outputs      => outputs
    );

--    osc1: entity work.osc
--    port
--    map (
--    Clock      => clk,
--    rst        => rst,
--    freq    => ,
--    deviation  => ,
--    sync    => ,
--    sqr_out    => osc1_out_sq,
--    sin_out    => osc1_out_sin,
--    );

--    osc2: entity work.osc
--    port
--    map (
--    Clock      => clk,
--    rst        => rst,
--    freq    => ,
--    deviation  => ,
--    sync    => ,
--    sqr_out    => osc2_out_sq,
--    sin_out    => osc2_out_sin,
--    );


  random_1 : entity work.random_voltage
    port map (
    Clock      => clk,
    rst        => rst,
    recycle    => cycle_recycle,
    noise_freq => noise_freq,
    slew_in    => slew_in,
    noise_1    => noise_1,
    noise_2    => noise_2
    );

  -- yuv mixer , mixes the digital and analoge sides together with clamping

  YUV_out_levels : entity work.YUV_levels
    port
    map(
    y_signal1 => y_signal1,
    y_signal2 => y_signal2,
    y_alpha   => y_alpha,
    y_result  => y_result,
    u_signal1 => u_signal1,
    u_signal2 => u_signal2,
    u_alpha   => u_alpha,
    u_result  => u_result,
    v_signal1 => v_signal1,
    v_signal2 => v_signal2,
    v_alpha   => v_alpha,
    v_result  => v_result
    );

  y_out <= y_result;
  u_out <= u_result;
  v_out <= v_result;

end Behavioral;