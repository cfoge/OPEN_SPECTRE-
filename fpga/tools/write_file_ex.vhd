
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: write_file_ex by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing std_logic etc.

entity write_file_ex is
   port (
        clk    : in  std_logic;   
        hs    : in  std_logic;   
        vs    : in  std_logic;   
        r    : in  std_logic_vector(7 downto 0);  
        g    : in  std_logic_vector(7 downto 0);   
        b    : in  std_logic_vector(7 downto 0)   

    );
end write_file_ex;

architecture tb of write_file_ex is
    signal a : std_logic;

    file output_buf : text;  -- text is keyword
begin     

    tb1 : process
        variable write_col_to_output_buf : line; -- line is keyword
        begin
            file_open(output_buf, "frame_out.txt",  write_mode); 
            write(write_col_to_output_buf, string'("clk, hs, vs , r, g, b"));
            writeline(output_buf, write_col_to_output_buf);  -- write in line 1
            
            wait until vs = '0';
            while vs = '0' loop
                wait for 10 ns;
                if (clk = '1') then
                    write(write_col_to_output_buf, clk);
                    write(write_col_to_output_buf, string'(","));
                    write(write_col_to_output_buf, hs);
                    write(write_col_to_output_buf, string'(","));
                    write(write_col_to_output_buf, vs);
                    write(write_col_to_output_buf, string'(","));
                    write(write_col_to_output_buf, r);
                    write(write_col_to_output_buf, string'(","));
                    write(write_col_to_output_buf, g);
                    write(write_col_to_output_buf, string'(","));
                    write(write_col_to_output_buf, b);
                    writeline(output_buf, write_col_to_output_buf);    -- write in new line 2
                end if;
            end loop;

--            write(write_col_to_output_buf, string'("Thank you"));
--            writeline(output_buf, write_col_to_output_buf);   -- write in new line 3

            file_close(output_buf);
            wait; -- indefinitely suspend process
        end process;
end tb ; -- tb
