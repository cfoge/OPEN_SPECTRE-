library ieee;
use ieee.std_logic_1164.all;

entity spi_wrapper is
  generic (
    N                     : integer := 8;      -- number of bits to serialize
    CPOL                  : std_logic := '0'   -- clock polarity
  );
  port (
    -- Ports for spi_child
    o_busy_child             : out std_logic;  
    i_data_parallel_child    : in  std_logic_vector(N-1 downto 0);  
    o_data_parallel_child    : out std_logic_vector(N-1 downto 0);  
    i_sclk_child             : in  std_logic;
    i_ss_child               : in  std_logic;
    i_mosi_child             : in  std_logic;
    o_miso_child             : out std_logic;

    -- Ports for spi_breakout
    clk_breakout            : in  std_logic;
    rst_breakout            : in  std_logic;
    data_in_breakout        : in  std_logic_vector(7 downto 0);
    addr_breakout           : out std_logic_vector(7 downto 0);
    valid_breakout          : in  std_logic;
    data_write_breakout     : out std_logic_vector(31 downto 0);
    data_read_breakout      : out std_logic_vector(31 downto 0);
    write_out_breakout      : out std_logic;
    read_out_breakout       : out std_logic
  );
end spi_wrapper;

architecture Behavioral of spi_wrapper is
  signal o_busy_wrapped    : std_logic;
  signal i_data_parallel_wrapped : std_logic_vector(N-1 downto 0);
  signal o_data_parallel_wrapped : std_logic_vector(N-1 downto 0);
  signal i_sclk_wrapped    : std_logic;
  signal i_ss_wrapped      : std_logic;
  signal i_mosi_wrapped    : std_logic;
  signal o_miso_wrapped    : std_logic;

  signal clk_wrapped       : std_logic;
  signal rst_wrapped       : std_logic;
  signal data_in_wrapped   : std_logic_vector(7 downto 0);
  signal addr_wrapped      : std_logic_vector(7 downto 0);
  signal valid_wrapped     : std_logic;
  signal data_write_wrapped: std_logic_vector(31 downto 0);
  signal data_read_wrapped : std_logic_vector(31 downto 0);
  signal write_out_wrapped : std_logic;
  signal read_out_wrapped  : std_logic;
begin

  -- Instantiate spi_child
  spi_child_inst: entity work.spi_child
    generic map (
      N => N,
      CPOL => CPOL
    )
    port map (
      o_busy => o_busy_wrapped,
      i_data_parallel => i_data_parallel_wrapped,
      o_data_parallel => o_data_parallel_wrapped,
      i_sclk => i_sclk_wrapped,
      i_ss => i_ss_wrapped,
      i_mosi => i_mosi_wrapped,
      o_miso => o_miso_wrapped
    );

  -- Instantiate spi_breakout
  spi_breakout_inst: entity work.spi_breakout
    port map (
      clk => clk_wrapped,
      rst => rst_wrapped,
      data_in => data_in_wrapped,
      addr => addr_wrapped,
      valid => valid_wrapped,
      data_write => data_write_wrapped,
      data_read => data_read_wrapped,
      write_out => write_out_wrapped,
      read_out => read_out_wrapped
    );

  -- Connecting signals between spi_child and spi_breakout
  i_data_parallel_wrapped <= data_write_wrapped;  -- Assuming data_write from spi_breakout is connected to spi_child data input
  o_data_parallel_wrapped <= data_read_wrapped;   -- Assuming data_read from spi_breakout is connected to spi_child data output
  i_sclk_wrapped          <= clk_wrapped;         -- Assuming spi_child uses the same clock as spi_breakout
  i_ss_wrapped            <= not write_out_wrapped;  -- Assuming active-low SS in spi_child
  i_mosi_wrapped          <= write_out_wrapped and i_mosi_wrapped;  -- Assuming data transmission control

  -- Mapping breakout signals to wrapper signals
  clk_wrapped       <= clk_breakout;
  rst_wrapped       <= rst_breakout;
  data_in_wrapped   <= data_in_breakout;
  addr_breakout <= addr_wrapped ;
  valid_wrapped     <= valid_breakout;

end Behavioral;
