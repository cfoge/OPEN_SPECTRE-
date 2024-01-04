library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity osc_wrapper is
  port
  (
    clk        : in std_logic;
    reset      : in std_logic;
    freq       : in std_logic_vector(9 downto 0);
    sync_sel   : in std_logic_vector(1 downto 0);
    sync_plus  : in std_logic;
    sync_minus : in std_logic;
    dev_lv     : in std_logic_vector(11 downto 0) := (others => '1');
    sin_out    : out std_logic_vector(11 downto 0);
    square_out : out std_logic
  );
end osc_wrapper;

architecture Behavioral of osc_wrapper is

  signal sin_out_main, sin_out_i, sin_1, sin_dev, sin_dev_d, sin_dev_d2, sin_dev_mix : std_logic_vector(11 downto 0);
  signal freq_dev                                                       : std_logic_vector(9 downto 0);
  signal square_i                                                       : std_logic := '0';

begin

  freq_dev <= freq + 4;
  SinWaveGenerator : entity work.SinWaveGenerator
    port map
    (
      clk        => clk,
      reset      => reset,
      freq       => freq,
      sync_sel   => sync_sel,
      sync_plus  => sync_plus,
      sync_minus => sync_minus,
      sin_out    => sin_out_main,
      square_out => square_out
    );

  SinWaveGenerator_dev : entity work.SinWaveGenerator
    port
    map (
    clk        => clk,
    reset      => reset,
    freq       => freq,
    sync_sel   => sync_sel,
    sync_plus  => sync_plus,
    sync_minus => sync_minus,
    sin_out    => sin_dev,
    square_out => square_out
    );

  process (clk) -- delay deviation oscilator mean that dev osc wont begin in phase with main osc
  begin
    if rising_edge(clk) then
      sin_dev_d  <= sin_dev;
      sin_dev_d2 <= sin_dev_d;
    end if;
  end process;

    level_dev : entity work.AlphaBlend
    port
    map (signal1 => (others => '0'),
    signal2 => sin_dev_d2,
    alpha   => dev_lv,
    result  => sin_dev_mix);

    Adder_12bit_NoOverflow_inst : entity work.Adder_12bit_NoOverflow
      port
      map (
      A        => sin_out_main,
      B        => sin_dev_mix,
      Sum      => sin_out_i,
      Overflow => open
      );
    sin_out    <= sin_out_i;
    square_out <= square_i;

  end Behavioral;