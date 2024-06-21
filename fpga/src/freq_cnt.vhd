-- Frequency Counter
-- 25 MHz Clock Input

---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_cnt is
    port (
        clk_25mhz       : in  std_logic;                    -- 25 MHz clock input

        clk_input_0     : in  std_logic;                    -- Input clock 0
        clk_input_1     : in  std_logic;                    -- Input clock 1
        clk_input_2     : in  std_logic;                    -- Input clock 2
        clk_input_3     : in  std_logic;                    -- Input clock 3
        clk_input_4     : in  std_logic;                    -- Input clock 4
        clk_input_5     : in  std_logic;                    -- Input clock 5
        clk_input_6     : in  std_logic;                    -- Input clock 6
        clk_input_7     : in  std_logic;                    -- Input clock 7

        clk_selected    : out std_logic_vector(3 downto 0); -- Clock select output
        new_sample_flag : out std_logic;                    -- New sample flag

        frequency       : out std_logic_vector(23 downto 0) -- Measured frequency output
    );
end freq_cnt;

architecture rtl of freq_cnt is

  type unsigned_array_5 is array (natural range <>) of unsigned(4 downto 0);

  constant NUM_CHANNELS   : integer := 8;

  signal clk_inputs       : std_logic_vector(NUM_CHANNELS-1 downto 0);
  signal prescaler_count  : unsigned_array_5(NUM_CHANNELS-1 downto 0);
  signal prescaled_clk    : std_logic_vector(NUM_CHANNELS-1 downto 0);
  signal clk_toggle       : std_logic_vector(NUM_CHANNELS-1 downto 0);
  signal meta_sync        : std_logic_vector(NUM_CHANNELS-1 downto 0);
  signal resync           : std_logic_vector(NUM_CHANNELS-1 downto 0);

  signal ref_counter      : unsigned(23 downto 0);
  signal freq_counter     : unsigned(23 downto 0);
  signal prescaler        : std_logic;
  signal prescaler_pulse  : std_logic;
  signal reg1, reg2       : std_logic;
  signal start_counter    : std_logic;
  signal sync1, sync2, sync3, sync4 : std_logic;
  signal stop_counter     : std_logic;
  signal channel_index    : integer range 0 to NUM_CHANNELS-1;

  attribute TIG           : string;
  attribute SHREG_EXTRACT : string;
  
  attribute SHREG_EXTRACT of meta_sync    : signal is "NO";
  attribute SHREG_EXTRACT of resync       : signal is "NO";
  attribute TIG of meta_sync              : signal is "YES";
  
begin

---------------------------------------------------------------------------
-- Array the inputs and outputs
---------------------------------------------------------------------------
  clk_inputs(0)  <= clk_input_0;
  clk_inputs(1)  <= clk_input_1;
  clk_inputs(2)  <= clk_input_2;
  clk_inputs(3)  <= clk_input_3;
  clk_inputs(4)  <= clk_input_4;
  clk_inputs(5)  <= clk_input_5;
  clk_inputs(6)  <= clk_input_6;
  clk_inputs(7)  <= clk_input_7;

---------------------------------------------------------------------------
-- Generate statement to handle generic number of frequency counters
---------------------------------------------------------------------------
  pre_gen : for chan in 0 to NUM_CHANNELS-1 generate

    process (clk_inputs(chan)) is
    begin
      if rising_edge(clk_inputs(chan)) then
        prescaler_count(chan) <= prescaler_count(chan) + 1;
        clk_toggle(chan)      <= not clk_toggle(chan);
      end if;
    end process;

    prescaled_clk(chan) <= prescaler_count(chan)(4); -- Divide incoming clock by 16

  end generate;

---------------------------------------------------------------------------
-- Synchronize the prescaled clocks to the 25 MHz domain
---------------------------------------------------------------------------
  process (clk_25mhz) is
  begin
    if rising_edge(clk_25mhz) then
      resync     <= meta_sync;
      meta_sync  <= prescaled_clk;
    end if;
  end process;

---------------------------------------------------------------------------
-- Select the incoming clock to measure
---------------------------------------------------------------------------
  prescaler <= resync(channel_index);

  process (clk_25mhz) is
  begin
    if rising_edge(clk_25mhz) then
      reg1 <= prescaler;
      reg2 <= reg1;
      if ((reg2 xor reg1) = '1') then
        prescaler_pulse <= '1';
      else
        prescaler_pulse <= '0';
      end if;
    end if;
  end process;

---------------------------------------------------------------------------
-- Count reference period
---------------------------------------------------------------------------
  process (clk_25mhz) is
  begin
    if rising_edge(clk_25mhz) then
      if (start_counter = '1') then
        ref_counter <= (others => '0');
      else
        ref_counter <= ref_counter + 1;
      end if;

      if ref_counter = to_unsigned((25000*160)-1, 24) then -- 160 ms period
        stop_counter <= '1';
      else
        stop_counter <= '0';
      end if;

      sync1 <= stop_counter;
      sync2 <= sync1;
      sync3 <= sync2;
      sync4 <= sync3;
      start_counter <= sync4; -- Delay 5 clock cycles for safety
    end if;
  end process;

---------------------------------------------------------------------------
-- Iterate through channels
---------------------------------------------------------------------------
  process (clk_25mhz) is
  begin
    if rising_edge(clk_25mhz) then
      if (sync1 = '1') then
        channel_index <= channel_index + 1;
      end if;
    end if;
  end process;

---------------------------------------------------------------------------
-- Output Counts sequentially to use only 1 register to read the clock frequencies
---------------------------------------------------------------------------
  process (clk_25mhz) is
  begin
    if rising_edge(clk_25mhz) then
      new_sample_flag <= '0';

      if start_counter = '1' then
        freq_counter <= x"000000";
      elsif stop_counter = '1' then
        frequency      <= std_logic_vector(freq_counter);
        new_sample_flag <= '1';
        clk_selected  <= std_logic_vector(to_unsigned(channel_index, 4));
      elsif prescaler_pulse = '1' then
        freq_counter <= freq_counter + 1;
      end if;
    end if;
  end process;

end architecture rtl;
