library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RS232 is
    Generic ( Quarz_Taktfrequenz : integer   := 100000000;  -- Hertz 
              Baudrate           : integer   :=  31250      -- Bits/Sec
             ); 
    Port ( RXD      : in   STD_LOGIC;
           RX_Data  : out  STD_LOGIC_VECTOR (7 downto 0);
           RX_Busy  : out  STD_LOGIC;
           TXD      : out  STD_LOGIC;
           TX_Data  : in   STD_LOGIC_VECTOR (7 downto 0);
           TX_Start : in   STD_LOGIC;
           TX_Busy  : out  STD_LOGIC;
           CLK      : in   STD_LOGIC
           );
end RS232;

architecture Behavioral of RS232 is
signal txstart : std_logic := '0';
signal txsr    : std_logic_vector  (9 downto 0) := "1111111111";  -- Startbit, 8 Datenbits, Stopbit
signal txbitcnt : integer range 0 to 10 := 10;
signal txcnt    : integer range 0 to (Quarz_Taktfrequenz/Baudrate)-1;

signal rxd_sr  : std_logic_vector (3 downto 0) := "1111";         -- Flankenerkennung und Eintakten
signal rxsr    : std_logic_vector (7 downto 0) := "00000000";     -- 8 Datenbits
signal rxbitcnt : integer range 0 to 9 := 9;
signal rxcnt   : integer range 0 to (Quarz_Taktfrequenz/Baudrate)-1; 

begin
   -- Senden
   process begin
      wait until rising_edge(CLK);
      txstart <= TX_Start;
      if (TX_Start='1' and txstart='0') then -- steigende Flanke, los gehts
         txcnt    <= 0;                      -- Zähler initialisieren
         txbitcnt <= 0;                      
         txsr     <= '1' & TX_Data & '0';    -- Stopbit, 8 Datenbits, Startbit, rechts gehts los
      else
         if(txcnt<(Quarz_Taktfrequenz/Baudrate)-1) then
            txcnt <= txcnt+1;
         else  -- nächstes Bit ausgeben  
            if (txbitcnt<10) then
              txcnt    <= 0;
              txbitcnt <= txbitcnt+1;
              txsr     <= '1' & txsr(txsr'left downto 1);
            end if;
         end if;
      end if;
   end process;
   TXD     <= txsr(0);  -- LSB first
   TX_Busy <= '1' when (TX_Start='1' or txbitcnt<10) else '0';
   
   -- Empfangen
   process begin
      wait until rising_edge(CLK);
      rxd_sr <= rxd_sr(rxd_sr'left-1 downto 0) & RXD;
      if (rxbitcnt<9) then    -- Empfang läuft
         if(rxcnt<(Quarz_Taktfrequenz/Baudrate)-1) then 
            rxcnt    <= rxcnt+1;
         else
            rxcnt    <= 0; 
            rxbitcnt <= rxbitcnt+1;
            rxsr     <= rxd_sr(rxd_sr'left-1) & rxsr(rxsr'left downto 1); -- rechts schieben, weil LSB first         end if;
         end if;
      else -- warten auf Startbit
         if (rxd_sr(3 downto 2) = "10") then                 -- fallende Flanke Startbit
            rxcnt    <= ((Quarz_Taktfrequenz/Baudrate)-1)/2; -- erst mal nur halbe Bitzeit abwarten
            rxbitcnt <= 0;
         end if;
      end if;
   end process;
   RX_Data <= rxsr;
   RX_Busy <= '1' when (rxbitcnt<9) else '0';

end Behavioral;
