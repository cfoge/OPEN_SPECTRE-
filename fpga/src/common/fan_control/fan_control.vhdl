-- Fan controller for Spectre
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity fan_control is
  generic
  (
    LOGIC_CLOCK_SPEED_KHZ : integer := 25000
  );
  port
  (
    clk_i              : in std_logic;
    rst_i              : in std_logic;
    clk_sys_10ms_stb_i : in std_logic;
    -- Fan Control Pads
    fan_sens_i : in std_logic; -- this should have a cdc to the logic clock domain, maybe 4 ff to stabilise it
    fan_ctrl_o : out std_logic;
    -- Fan Control Registers
    reg_fan_pwm       : in std_logic_vector(31 downto 0);
    reg_rd_fan_tach_o : out std_logic_vector(31 downto 0)
  );
end fan_control;

architecture rtl of fan_control_wrapper is

  ---------------------------------------------------------------------------
  --  Signals
  ---------------------------------------------------------------------------
  --fan signals
  signal pwm_counter : std_logic_vector(9 downto 0);

  signal fan_ctrl         : std_logic;
  signal fan_tacho        : std_logic_vector(7 downto 0);
  signal fan_pwm          : std_logic_vector(9 downto 0);
  signal fan_sens_clk_sys : std_logic;

  signal dbg_tacho : std_logic_vector(127 downto 0);

  -- tacho signals
  constant RPM_BINS   : integer := 100;   -- = 1 second worth of 10ms strobe signals

  signal tac_edge_debounce : std_logic_vector(3 downto 0);
  signal tac_edge          : std_logic;
  signal fan_debounce_cntr : unsigned(19 downto 0) := (others => '0');
  signal tach_blip    : std_logic             := '0';
  signal tach_blip_d1 : std_logic             := '0';

  signal rpm_bin_ramp   : unsigned(8 downto 0); --  size depends on RPM_BINS
  signal rpm_bin_spikes : unsigned(8 downto 0); --  size depends on RPM_BINS

  signal tacho_clk_i : std_logic;

begin
  ------------------------------------------------------
  -- Fan  Regs
  ------------------------------------------------------
  fan_pwm <= reg_fan_pwm(11 downto 2);

  reg_rd_fan_tach_o(31 downto 8) <= (others => '0');
  reg_rd_fan_tach_o(7 downto 0)  <= fan_tacho;

  ------------------------------------------------------
  -- Fan Control 
  ------------------------------------------------------  
  fan_pwm_p : process (clk_i) -- makes a pwm signal using the register value
  begin
    if rising_edge(clk_i) then
      pwm_counter <= (pwm_counter + 1);
      if (pwm_counter < fan_pwm) then
        fan_ctrl <= '0';
      else
        fan_ctrl <= '1';
      end if;

    end if;
  end process pwm_gen_p;
  ------------------------------------------------------
  -- Tacho 
  ------------------------------------------------------  
  tach : process (clk_i) is
  begin
    if rising_edge(clk_i) then
      -- Debounce tachometer incoming and look for the edge
      tac_edge_debounce <= tac_edge_debounce(2 downto 0) & tacho_clk_i;

      if tac_edge_debounce(1) /= tac_edge_debounce(0) then
        tac_edge <= '1';
      else
        tac_edge <= '0';
      end if;

      if tac_edge = '1' then -- if you find an edge, start counting clocks
        fan_debounce_cntr <= (others => '0');
      else
        if fan_debounce_cntr /= LOGIC_CLOCK_SPEED_KHZ then
          fan_debounce_cntr <= fan_debounce_cntr + 1; -- counts clocks after edge untill 1sec has passed
        end if;
      end if;

      -- when 1 second has passed latch the latest tacho reading
      if fan_debounce_cntr = LOGIC_CLOCK_SPEED_KHZ then
        tach_blip    <= tac_edge_debounce(3);
        tach_blip_d1 <= tach_blip; -- create delay for edge detect
      end if;

      -- Convert Blips to RPM
      if tach_blip = '0' and tach_blip_d1 = '1' then -- detect falling edge
        rpm_bin_spikes <= rpm_bin_spikes + 1;
      end if;

      if clk_i_10ms_stb_i = '1' then -- every 10ms 
        rpm_bin_ramp <= rpm_bin_ramp + 1;
        if rpm_bin_ramp = RPM_BINS then
          rpm_bin_ramp   <= (others => '0');
          fan_revs_o     <= std_logic_vector(rpm_bin_spikes(8 downto 1)); -- 2 falling edges per cycle
          rpm_bin_spikes <= (others => '0');
        end if;
      end if;

    end if;
  end process;

  ------------------------------------------------------
  -- Output
  ------------------------------------------------------
  fan_ctrl_o <= fan_ctrl;
end architecture rtl;