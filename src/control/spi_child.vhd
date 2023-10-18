library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_child is
generic(
  N                     : integer := 8;      -- number of bit to serialize
  CPOL                  : std_logic := '0' );  -- clock polarity
 port (
  o_busy                      : out std_logic;  -- receiving data if '1'
  i_data_parallel             : in  std_logic_vector(N-1 downto 0);  -- data to sent
  o_data_parallel             : out std_logic_vector(N-1 downto 0);  -- received data
  i_sclk                      : in  std_logic;
  i_ss                        : in  std_logic;
  i_mosi                      : in  std_logic;
  o_miso                      : out std_logic);
end spi_child;

architecture rtl of spi_child is

signal r_shift_ena                           : std_logic;
signal r_tx_data                             : std_logic_vector(N-2 downto 0);  -- data to sent
signal r_rx_data                             : std_logic_vector(N-1 downto 0);  -- received data

begin
o_data_parallel  <= r_rx_data;
o_busy           <= r_shift_ena;

p_spi_slave_input : process(i_sclk)
begin
  if(i_sclk'event and i_sclk=CPOL) then -- CPOL='0' => falling edge; CPOL='1' => risinge edge
    if(i_ss='0') then
      r_rx_data              <= r_rx_data(N-2 downto 0)&i_mosi;
    end if;
  end if;
end process p_spi_slave_input;

p_spi_slave_output : process(i_sclk,i_ss)
begin
  if(i_ss='1') then
    r_shift_ena            <= '0';
  elsif(i_sclk'event and i_sclk= not CPOL) then -- CPOL='0' => falling edge; CPOL='1' => risinge edge
    r_shift_ena            <= '1';
    if(r_shift_ena='0') then
      o_miso                 <= i_data_parallel(N-1);
      r_tx_data              <= i_data_parallel(N-2 downto 0);
    else
      o_miso                 <= r_tx_data(N-2);
      r_tx_data              <= r_tx_data(N-3 downto 0)&'0';
    end if;
  end if;
end process p_spi_slave_output;

end rtl;