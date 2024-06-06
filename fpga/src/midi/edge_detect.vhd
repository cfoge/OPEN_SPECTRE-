library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is
  port (async_sig : in std_logic;
        clk       : in std_logic;
        --rise      : out std_logic);
        fall      : out std_logic);
end;

architecture RTL of edge_detect is
begin
  process
    variable sr : std_logic_vector (3 downto 0) := "0000";
  begin
    wait until rising_edge(clk);
    -- Flanken erkennen
    --rise <= not sr(3) and sr(2);
    fall <= not sr(2) and sr(3);
    -- Eingang in Schieberegister einlesen
    sr := sr(2 downto 0) & async_sig;
  end process;
end architecture;

