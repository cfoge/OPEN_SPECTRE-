library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco is
  port (
    i_clk         : in  std_logic;
    i_rstb        : in  std_logic;
    i_sync_reset  : in  std_logic;
    i_fcw         : in  std_logic_vector(8 downto 0);
    i_preload     : in  std_logic_vector(8 downto 0); -- New preload input
    o_nco         : out std_logic_vector(8 downto 0)
  );
end nco;

architecture rtl of nco is
  signal r_sync_reset  : std_logic;
  signal r_fcw         : unsigned(8 downto 0);
  signal r_nco         : unsigned(8 downto 0);

begin
  p_nco8 : process(i_clk, i_rstb)
  begin
    if(i_rstb = '1') then
      r_sync_reset <= '1';
      r_fcw        <= (others => '0');
      r_nco        <= unsigned(i_preload); -- Initialize with preload value
    elsif(rising_edge(i_clk)) then
--      r_sync_reset <= i_sync_reset;
      r_fcw        <= unsigned(i_fcw);

      if(i_sync_reset = '0') then
        r_nco <= unsigned(i_preload); -- Reset to preload value
      else
        r_nco <= r_nco + r_fcw;
      end if;
    end if;
  end process p_nco8;

  o_nco <= std_logic_vector(r_nco);

end rtl;
