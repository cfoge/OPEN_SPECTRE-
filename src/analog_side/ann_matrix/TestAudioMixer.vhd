library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
library work;
use work.array_pck.all;

entity TestAudioMixer is
end TestAudioMixer;

architecture sim of TestAudioMixer is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal inputs : array_12(9 downto 0);
    signal gains : array_4(9 downto 0);
    signal output : STD_LOGIC_VECTOR(11 downto 0);
    constant CLOCK_PERIOD : time := 10 ns;
    
    -- Helper function to convert an integer to an array_12
    function to_array_12(value : integer) return array_12 is
    begin
        return (others => to_unsigned(value, 12));
    end function;

begin
    -- Instantiate the DUT (Design Under Test)
    uut : entity work.AudioMixer
        Port Map (
            clk => clk,
            reset => reset,
            inputs => inputs,
            gains => gains,
            output => output
        );

    -- Clock process
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_process : process
    begin
        wait for 20 ns; -- Wait for initial stability

        -- Test 1: All inputs at maximum, no gains
        inputs <= (others => "111111111111");
        gains <= (others => "0000");
        reset <= '0';
        wait for 10 ns;
        assert output = "000000000001" report "Test 1 failed" severity error;

        -- Test 2: All inputs at maximum, all gains at maximum
        gains <= (others => "1111");
        wait for 10 ns;
        assert output = "011111111111" report "Test 2 failed" severity error;

        -- Test 3: Varying inputs and gains
        inputs <= to_array_12(50);  -- Input 0 set to 50
        gains <= (others => "0010"); -- Gain 0 set to 2
        wait for 10 ns;
        assert output = "000001100000" report "Test 3 failed" severity error;

        -- You can add more tests here
        
        -- Finish the simulation
        wait;
    end process;
end sim;
