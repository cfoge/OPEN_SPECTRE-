-- 18 parallel XOR gates, with the output inverted
--XY inverter logic !!!NEEDS THE INVERTERS added

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xor18 is
    port (
        -- inputs
        a: in std_logic_vector(17 downto 0);  -- first inputs
        b: in std_logic_vector(17 downto 0);  -- second inputs

        -- outputs
        y: out std_logic_vector(17 downto 0)  -- outputs
    );
end entity;

architecture behavioral of xor18 is
begin
    -- implement the XOR gates
    y(0) <= a(0) xor b(0);
    y(1) <= a(1) xor b(1);
    y(2) <= a(2) xor b(2);
    y(3) <= a(3) xor b(3);
    y(4) <= a(4) xor b(4);
    y(5) <= a(5) xor b(5);
    y(6) <= a(6) xor b(6);
    y(7) <= a(7) xor b(7);
    y(8) <= a(8) xor b(8);
    y(9) <= a(9) xor b(9);
    y(10) <= a(10) xor b(10);
    y(11) <= a(11) xor b(11);
    y(12) <= a(12) xor b(12);
    y(13) <= a(13) xor b(13);
    y(14) <= a(14) xor b(14);
    y(15) <= a(15) xor b(15);
    y(16) <= a(16) xor b(16);
    y(17) <= a(17) xor b(17);
end architecture;
