library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ycrcb2rgb_mux is
    Port (
        -- Inputs
        y_in   : in std_logic_vector(7 downto 0);
        cb_in  : in std_logic_vector(7 downto 0);
        cr_in  : in std_logic_vector(7 downto 0);
        r_in   : in std_logic_vector(7 downto 0);
        g_in  : in std_logic_vector(7 downto 0);
        b_in  : in std_logic_vector(7 downto 0);
        
        sel    : in std_logic := '0'; --bypasses the colourconverter when =1
        
        -- Outputs
        y_out  : out std_logic_vector(7 downto 0);
        cb_out : out std_logic_vector(7 downto 0);
        cr_out : out std_logic_vector(7 downto 0);
        r_out  : out std_logic_vector(7 downto 0);
        g_out  : out std_logic_vector(7 downto 0);
        b_out  : out std_logic_vector(7 downto 0)
    );
end ycrcb2rgb_mux;

architecture Behavioral of ycrcb2rgb_mux is
begin
    process(y_in, cb_in, cr_in, sel)
    begin
        if sel = '0' then
             -- module mode , the incoming Ycbcr is converter to rgb before bing passed out
            r_out  <= r_in;
            g_out  <= g_in;
            b_out  <= b_in;
        else
            -- Bypass mode , the incoming Ycbcr is directly fed to the rgb encoders
            r_out  <= y_in;
            g_out  <= cb_in;
            b_out  <= cr_in;
        end if;
    end process;
    
    --video in is alway passwd to color spce converter
    y_out  <= y_in;
    cb_out <= cb_in;
    cr_out <= cr_in;
end Behavioral;
