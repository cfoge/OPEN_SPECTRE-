----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 15:01:37
-- Design Name: 
-- Module Name: mux2_1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
    port (
        sel: in std_logic;
        a: in std_logic;
        b: in std_logic;
        c: out std_logic
    );
end mux2_1;

architecture beh of mux2_1 is
begin
    c <= a when sel='0' else b;
end beh;
