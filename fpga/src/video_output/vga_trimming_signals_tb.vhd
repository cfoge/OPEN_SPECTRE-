library ieee;
use ieee.std_logic_1164.all;

entity vga_trimming_signals_tb is
end vga_trimming_signals_tb;

architecture tb_arch of vga_trimming_signals_tb is
    -- Component declaration for the module under test
    component vga_trimming_signals
        port (
            clk_25mhz    : in  std_logic;
            h_sync       : out std_logic;
            v_sync       : out std_logic;
            video_on     : out std_logic
        );
    end component;

    -- Test signals
    signal clk_25mhz : std_logic := '0';
    signal h_sync    : std_logic;
    signal v_sync    : std_logic;
    signal video_on  : std_logic;

begin
    -- Instantiate the module under test
    dut : vga_trimming_signals
        port map (
            clk_25mhz => clk_25mhz,
            h_sync    => h_sync,
            v_sync    => v_sync,
            video_on  => video_on
        );

    -- Clock generator
    clk_gen : process
    begin
        while now < 100000 ns loop
            clk_25mhz <= '0';
            wait for 20 ns;
            clk_25mhz <= '1';
            wait for 20 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Wait for a few cycles to ensure the VGA signals stabilize
        wait for 100 ns;

        -- Check the trimming signals during the first few horizontal and vertical lines
        for i in 0 to 20 loop
            assert h_sync = '0' report "Unexpected h_sync value at line " & integer'image(i) severity error;
            assert v_sync = '0' report "Unexpected v_sync value at line " & integer'image(i) severity error;
            assert video_on = '0' report "Unexpected video_on value at line " & integer'image(i) severity error;
            wait for 25 ns;
        end loop;

        -- Check the trimming signals during the active video area
        for i in 21 to 500 loop
            assert h_sync = '1' report "Unexpected h_sync value at line " & integer'image(i) severity error;
            assert v_sync = '1' report "Unexpected v_sync value at line " & integer'image(i) severity error;
            assert video_on = '1' report "Unexpected video_on value at line " & integer'image(i) severity error;
            wait for 25 ns;
        end loop;

        -- Check the trimming signals during the last few horizontal and vertical lines
        for i in 501 to 525 loop
            assert h_sync = '0' report "Unexpected h_sync value at line " & integer'image(i) severity error;
            assert v_sync = '0' report "Unexpected v_sync value at line " & integer'image(i) severity error;
            assert video_on = '0' report "Unexpected video_on value at line " & integer'image(i) severity error;
            wait for 25 ns;
        end loop;

        -- Wait for a few cycles to ensure the VGA signals stabilize
        wait for 100 ns;

        -- Stop the simulation
        wait;
    end process;

end tb_arch;
