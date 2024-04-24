library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_1_to_8 is
    Port (
        data: in std_logic;
        sel: in  std_logic_vector(2 downto 0);
        demux_out: out  std_logic_vector(7 downto 0)
    );
end demux_1_to_8;

architecture Behavioral of demux_1_to_8 is
begin
    demux_out <= (data & "0000000") when (sel="000") else
            ('0' & data & "000000") when (sel="001") else
            ("00" & data & "00000") when (sel="010") else
            ("000" & data & "0000") when (sel="011") else
            ("0000" & data & "000") when (sel="100") else
            ("00000" & data & "00") when (sel="101") else
            ("000000" & data & '0') when (sel="110") else
            ("0000000" & data) ;
end Behavioral;
