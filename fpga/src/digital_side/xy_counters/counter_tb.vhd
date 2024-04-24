library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter_tb is
end entity;

architecture behavioral of counter_tb is
    -- instantiate the counter
    component counter is
        generic (
            width: integer := 9  -- width of the counter
        );
        port (
            clk: in std_logic;       -- clock input
            rst: in std_logic;       -- reset input
            enable: in std_logic;    -- enable input
            count: out std_logic_vector(width-1 downto 0)  -- count output
        );
    end component;

    -- test input signals
    signal clk: std_logic;
    signal rst: std_logic;
    signal enable: std_logic;

    -- test output signals
    signal count: std_logic_vector(8 downto 0);
    
    -- flag to keep track of any errors that occur during the testbench
    signal flag: boolean := false;

begin
    -- instantiate the counter
    UUT: counter
        generic map (
            width => 9
        )
        port map (
            clk => clk,
            rst => rst,
            enable => enable,
            count => count
        );

    -- test stimulus process
    stim_proc: process
    begin

        
        -- set the inputs and wait for the output to be stable
        clk <= '0';
        rst <= '1';
        enable <= '0';
        wait for 10 ns;

        rst <= '0';
        assert count = "000000000" report "Test 1 Output value after reset is not as expected" severity error;
        if count /= "000000000" then
            flag <= true;
        end if;
        wait for 10 ns;

        enable <= '1';
        assert count = "000000000" report "Test 2 Output value after enabling is not as expected" severity error;
        if count /= "000000000" then
            flag <= true;
        end if;
        wait for 10 ns;

        -- toggle the clock and wait for the output to be stable
        for i in 1 to 10 loop
            clk <= not clk;
            wait for 10 ns;
        end loop;
        
        assert count /= "000001010" report "Test 3 Output value during clock toggle is not as expected" severity error;
            if count = "000001010" then
                flag <= true;
            end if;
        
            -- report that the testbench passed if no errors occurred
        if flag = false then
            report "TB PASSED!";
        end if;

        -- end the test
        wait;
    end process;
    

end architecture;
