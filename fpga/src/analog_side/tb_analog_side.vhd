library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.array_pck.all;


entity tb_analog_side is
end tb_analog_side;

architecture SIM of tb_analog_side is

  -- Constants
  constant CLK_PERIOD : time := 10 ns; -- Adjust the clock period as needed

  -- Signals
  signal clk            : std_logic := '0';
  signal rst            : std_logic := '0';
  signal wr             : std_logic := '0';
  signal out_addr       : std_logic_vector(7 downto 0) := (others => '0');
  signal ch_addr        : std_logic_vector(7 downto 0) := (others => '0');
  signal gain_in        : std_logic_vector(4 downto 0) := (others => '0');
  signal pos_h_1        : std_logic_vector(8 downto 0) := (others => '0');
  signal pos_v_1        : std_logic_vector(8 downto 0) := (others => '0');
  signal zoom_h_1       : std_logic_vector(8 downto 0) := (others => '0');
  signal zoom_v_1       : std_logic_vector(8 downto 0) := (others => '0');
  signal circle_1       : std_logic_vector(8 downto 0) := (others => '0');
  signal gear_1         : std_logic_vector(8 downto 0) := (others => '0');
  signal lantern_1      : std_logic_vector(8 downto 0) := (others => '0');
  signal fizz_1         : std_logic_vector(8 downto 0) := (others => '0');
  signal pos_h_2        : std_logic_vector(8 downto 0) := (others => '0');
  signal pos_v_2        : std_logic_vector(8 downto 0) := (others => '0');
  signal zoom_h_2       : std_logic_vector(8 downto 0) := (others => '0');
  signal zoom_v_2       : std_logic_vector(8 downto 0) := (others => '0');
  signal circle_2       : std_logic_vector(8 downto 0) := (others => '0');
  signal gear_2         : std_logic_vector(8 downto 0) := (others => '0');
  signal lantern_2      : std_logic_vector(8 downto 0) := (others => '0');
  signal fizz_2         : std_logic_vector(8 downto 0) := (others => '0');
  signal noise_freq     : std_logic_vector(9 downto 0) := (others => '0');
  signal slew_in        : std_logic_vector(2 downto 0) := (others => '0');
  signal cycle_recycle  : std_logic := '0';
  signal y_alpha        : std_logic_vector(11 downto 0) := (others => '0');
  signal u_alpha        : std_logic_vector(11 downto 0) := (others => '0');
  signal v_alpha        : std_logic_vector(11 downto 0) := (others => '0');
  signal audio_in_t     : std_logic_vector(9 downto 0) := (others => '0');
  signal audio_in_b     : std_logic_vector(9 downto 0) := (others => '0');
  signal audio_in_sig   : std_logic_vector(9 downto 0) := (others => '0');
  signal audio_in_sig_i : std_logic_vector(9 downto 0) := (others => '0');
  signal dsm_hi_i       : std_logic_vector(9 downto 0) := (others => '0');
  signal dsm_lo_i       : std_logic_vector(9 downto 0) := (others => '0');
  signal y_digital      : std_logic_vector(11 downto 0) := (others => '0');
  signal u_digital      : std_logic_vector(11 downto 0) := (others => '0');
  signal v_digital      : std_logic_vector(11 downto 0) := (others => '0');
  signal vid_span       : std_logic_vector(11 downto 0) := (others => '0');
  signal y_out          : std_logic_vector(11 downto 0) := (others => '0');
  signal u_out          : std_logic_vector(11 downto 0) := (others => '0');
  signal v_out          : std_logic_vector(11 downto 0) := (others => '0');
  signal outputs_o      : array_12(19 downto 0) := (others => (others => '0')); -- Initialize outputs

  -- Instantiate UUT
  component analog_side
    port
    (
      clk      : in std_logic;
      rst      : in std_logic;
      wr       : in std_logic;
      out_addr : in std_logic_vector(7 downto 0);
      ch_addr  : in std_logic_vector(7 downto 0);
      gain_in  : in std_logic_vector(4 downto 0);
      pos_h_1  : in std_logic_vector(8 downto 0);
      pos_v_1  : in std_logic_vector(8 downto 0);
      zoom_h_1 : in std_logic_vector(8 downto 0);
      zoom_v_1 : in std_logic_vector(8 downto 0);
      circle_1 : in std_logic_vector(8 downto 0);
      gear_1   : in std_logic_vector(8 downto 0);
      lantern_1 : in std_logic_vector(8 downto 0);
      fizz_1   : in std_logic_vector(8 downto 0);
      pos_h_2  : in std_logic_vector(8 downto 0);
      pos_v_2  : in std_logic_vector(8 downto 0);
      zoom_h_2 : in std_logic_vector(8 downto 0);
      zoom_v_2 : in std_logic_vector(8 downto 0);
      circle_2 : in std_logic_vector(8 downto 0);
      gear_2   : in std_logic_vector(8 downto 0);
      lantern_2 : in std_logic_vector(8 downto 0);
      fizz_2   : in std_logic_vector(8 downto 0);
      noise_freq : in std_logic_vector(9 downto 0);
      slew_in    : in std_logic_vector(2 downto 0);
      cycle_recycle : in std_logic;
      y_alpha    : in std_logic_vector(11 downto 0);
      u_alpha    : in std_logic_vector(11 downto 0);
      v_alpha    : in std_logic_vector(11 downto 0);
      audio_in_t   : in std_logic_vector(9 downto 0);
      audio_in_b   : in std_logic_vector(9 downto 0);
      audio_in_sig : in std_logic_vector(9 downto 0);
      audio_in_sig_i : in std_logic_vector(9 downto 0);
      dsm_hi_i       : in std_logic_vector(9 downto 0);
      dsm_lo_i       : in std_logic_vector(9 downto 0);
      y_digital      : in std_logic_vector(11 downto 0);
      u_digital      : in std_logic_vector(11 downto 0);
      v_digital      : in std_logic_vector(11 downto 0);
      vid_span : out std_logic_vector(11 downto 0);
      y_out    : out std_logic_vector(11 downto 0);
      u_out    : out std_logic_vector(11 downto 0);
      v_out    : out std_logic_vector(11 downto 0)
--      outputs_o      : out array_12(19 downto 0)
    );
  end component;

begin

  -- Instantiate the UUT
  UUT: analog_side
    port map
    (
      clk      => clk,
      rst      => rst,
      wr       => wr,
      out_addr => out_addr,
      ch_addr  => ch_addr,
      gain_in  => gain_in,
      pos_h_1  => pos_h_1,
      pos_v_1  => pos_v_1,
      zoom_h_1 => zoom_h_1,
      zoom_v_1 => zoom_v_1,
      circle_1 => circle_1,
      gear_1   => gear_1,
      lantern_1 => lantern_1,
      fizz_1   => fizz_1,
      pos_h_2  => pos_h_2,
      pos_v_2  => pos_v_2,
      zoom_h_2 => zoom_h_2,
      zoom_v_2 => zoom_v_2,
      circle_2 => circle_2,
      gear_2   => gear_2,
      lantern_2 => lantern_2,
      fizz_2   => fizz_2,
      noise_freq => noise_freq,
      slew_in    => slew_in,
      cycle_recycle => cycle_recycle,
      y_alpha    => y_alpha,
      u_alpha    => u_alpha,
      v_alpha    => v_alpha,
      audio_in_t   => audio_in_t,
      audio_in_b   => audio_in_b,
      audio_in_sig => audio_in_sig,
      audio_in_sig_i => audio_in_sig_i,
      dsm_hi_i       => dsm_hi_i,
      dsm_lo_i       => dsm_lo_i,
      y_digital      => y_digital,
      u_digital      => u_digital,
      v_digital      => v_digital,
      vid_span => vid_span,
      y_out    => y_out,
      u_out    => u_out,
      v_out    => v_out
--      outputs_o      => outputs_o
    );

  -- Clock process
  process
  begin
    while true loop
      clk <= not clk;
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  -- Stimulus process
  process
  begin
    -- Apply reset
    rst <= '1';
    wait for CLK_PERIOD * 2;
    rst <= '0';

    -- Add your test cases here
         
      out_addr <= "00010010";
      ch_addr  <= "00000100";
      gain_in  <= "00001";
      wait for CLK_PERIOD * 2;
       wr       <= '1';
       wait for CLK_PERIOD * 2;
       wr       <= '0';

    wait;
  end process;

end SIM;
