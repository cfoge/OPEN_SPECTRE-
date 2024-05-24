library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
library work;
use work.all;

entity midi is port(
   clk       : in  std_logic;
   midi_in   : in  std_logic;
   midi_new  : out std_logic := '0';
   midi_ch   : out std_logic_vector(3 downto 0) := "0000";
   midi_note : out std_logic_vector(6 downto 0) := "0000000";
   midi_velo : out std_logic_vector(6 downto 0) := "0000000"
   );
end midi;

architecture rtl of midi is
type midi_state_type is (status,note_off,note_on,velocity);
signal uart_busy       : std_logic;
signal midi_data       : std_logic_vector(7 downto 0);
signal midi_state      : midi_state_type := status;
signal next_midi_state : midi_state_type := status;
signal falling         : std_logic := '0';
signal off             : std_logic := '0';

begin

uart1: entity work.RS232 port map(midi_in,midi_data,uart_busy,open,"00000000",'0',open,clk);
uart_edge: entity work.edge_detect port map(uart_busy,clk,falling);

process begin
   wait until rising_edge(clk);
   midi_new <= '0';
   if(falling = '1') then
      if(not (midi_data = "11111110" or midi_data = "11111000")) then --active sense or clock
         case midi_state is
            when status =>
               --midi_new <= '0';
               if(midi_data(7 downto 4) = "1000") then    --note off
                  midi_state <= note_off;
                  midi_ch    <= midi_data(3 downto 0);
                  midi_velo  <= "0000000";
                  off <= '1';
               elsif(midi_data(7 downto 4) = "1001") then --note on
                  midi_state <= note_on;
                  midi_ch    <= midi_data(3 downto 0);
                  off <= '0';
               end if;
            when note_on =>
               if(midi_data(7) = '0') then
                  midi_note  <= midi_data(6 downto 0);
                  midi_state <= velocity;
               else
                  midi_state <= status;
               end if;
            when note_off =>
               if(midi_data(7) = '0') then
                  midi_note  <= midi_data(6 downto 0);
                  midi_state <= velocity;
               else
                  midi_state <= status;
               end if;
            when velocity =>
               if(midi_data(7) = '0') then
                  if(off = '0') then
                  midi_velo <= midi_data(6 downto 0);
                  else
                  midi_velo <= "0000000";
                  end if;
                  midi_state <= status;
                  midi_new   <= '1'; 
               else
                  midi_state <= status;
               end if;
         end case;
      end if;
   end if;
end process;
end rtl;

