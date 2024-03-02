----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2023 16:38:47
-- Design Name: 
-- Module Name: slow_counter - Behavioral
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

entity slow_counter is
    Port ( clk : in STD_LOGIC;
           enable: in std_logic;    -- enable input
           hz6 : out STD_LOGIC;
           hz3 : out STD_LOGIC;
           hz1_5 : out STD_LOGIC;
           hz_6 : out STD_LOGIC;
           hz_4 : out STD_LOGIC;
           hz_2 : out STD_LOGIC);
end slow_counter;

architecture Behavioral of slow_counter is

begin

hz6_counter : entity work.pulse_generator
    generic map(
        toggle_period => 4_166_666
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz6
    );
    
hz3_counter : entity work.pulse_generator
    generic map(
        toggle_period => 8_333_333 
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz3
    );

hz1_5_counter : entity work.pulse_generator
    generic map(
        toggle_period => 16_666_666 
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz1_5
    );

hz_6_counter : entity work.pulse_generator
    generic map(
        toggle_period => 41_666_666
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz_6
    );
    
hz_4_counter : entity work.pulse_generator
    generic map(
        toggle_period =>  62_500_000
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz_4
    );

hz_2_counter : entity work.pulse_generator
    generic map(
        toggle_period =>   125_000_000 
    )
    port map(
        clk => clk,
        enable => enable,
        output => hz_2
    );

end Behavioral;
