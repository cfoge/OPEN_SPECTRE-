--http://tinyvga.com/vga-timing/800x600@60Hz
library ieee;
use ieee.std_logic_1164.all;

entity vga_trimming_signals is
    port (
        clk_25mhz    : in  std_logic;    -- 40mhz clock input SVGA 800x600
        h_sync       : out std_logic;    -- horizontal sync output
        v_sync       : out std_logic;    -- vertical sync output
        video_on     : out std_logic     -- video on/off output
    );
end vga_trimming_signals;

architecture rtl of vga_trimming_signals is


    -- VGA timings 800x600 40mhz
    constant h_front_porch : integer := 40;
    constant h_sync_width  : integer := 128;
    constant h_back_porch  : integer := 88;
    constant h_total       : integer := 1056;
    constant v_front_porch : integer := 1;
    constant v_sync_width  : integer := 4;
    constant v_back_porch  : integer := 23;
    constant v_total       : integer := 628;
    
    -- Internal counters
    signal h_count : integer range 0 to h_total - 1 := 0;
    signal v_count : integer range 0 to v_total - 1 := 0;
    
begin

    process (clk_25mhz)
    begin
        if rising_edge(clk_25mhz) then
            -- Horizontal counter
            if h_count = h_total - 1 then
                h_count <= 0;
                -- Vertical counter
                if v_count = v_total - 1 then
                    v_count <= 0;
                    video_on <= '1';
                else
                    v_count <= v_count + 1;
                    video_on <= '0';
                end if;
            else
                h_count <= h_count + 1;
                video_on <= '0';
            end if;
            
            -- Horizontal sync
            if h_count < h_sync_width + h_front_porch then
                h_sync <= '1';
            else
                h_sync <= '0';
            end if;
            
            -- Vertical sync
            if v_count < v_sync_width + v_front_porch then
                v_sync <= '1';
            else
                v_sync <= '0';
            end if;
        end if;
    end process;

end rtl;
