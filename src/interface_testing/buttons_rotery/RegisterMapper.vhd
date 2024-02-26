library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterMapper is
    generic (
        REG_WIDTH   : integer := 18;  -- Width of input registers
        REG_COUNT   : integer := 4;   -- Number of input registers
        ADDR_WIDTH  : integer := 5    -- Address width for 32 registers (2^5 = 32)
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        wr_enable   : in  std_logic_vector(REG_COUNT - 1 downto 0);  -- Write enable for each input register
        input_data  : in  std_logic_vector(REG_COUNT * REG_WIDTH - 1 downto 0);
        input_addr  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);  -- Address for each input register
        output_regs : out std_logic_vector(31 downto 0 * (REG_WIDTH + 1) - 1 downto 0)
    );
end entity RegisterMapper;

architecture Behavioral of RegisterMapper is
    type register_array is array (0 to 31) of std_logic_vector(REG_WIDTH - 1 downto 0);  -- Array of 32 18-bit registers
    signal registers : register_array;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset all registers
            for i in registers'range loop
                registers(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            -- Update registers based on write enables and input data
            for i in 0 to REG_COUNT - 1 loop
                if wr_enable(i) = '1' then
                    registers(to_integer(unsigned(input_addr))) <= input_data(REG_WIDTH * (i + 1) - 1 downto REG_WIDTH * i);
                end if;
            end loop;
        end if;
    end process;

    -- Output register assignment
    output_regs <= registers(to_integer(unsigned(input_addr)));
end architecture Behavioral;
