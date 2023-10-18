library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spi_breakout is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           addr : out STD_LOGIC_VECTOR (7 downto 0);
           valid : in STD_LOGIC;
           data_write : out STD_LOGIC_VECTOR (31 downto 0);
           data_read : out STD_LOGIC_VECTOR (31 downto 0);
           write_out : out STD_LOGIC;
           read_out : out STD_LOGIC);
end spi_breakout;

architecture Behavioral of spi_breakout is
    type state_type is (idle, wait_for_first_byte, func_byte, first_byte, second_byte, third_byte, fourth_byte, write_cmd, sixth_byte);
    signal state : state_type := idle;
    signal addr_i : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal function_i : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_write_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal func_write : STD_LOGIC := '0';
    signal write_out_i : STD_LOGIC := '0';
    signal func_read : STD_LOGIC := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= idle;
            addr_i <= (others => '0');
            function_i <= (others => '0');
            data_write_i <= (others => '0');
            func_write <= '0';
            func_read <= '0';
            write_out_i <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when idle =>
                    state <= wait_for_first_byte;
                    
                when wait_for_first_byte =>
                    if valid = '1' then
                        addr_i <= data_in;
                        state <= func_byte;
                    end if;
                    
                when func_byte =>
                    if valid = '1' then
                        function_i <= data_in;
                        state <= first_byte;
                        
                        if data_in = "00000000" then --read command
                            func_read <= '1';
                        elsif data_in = "00000001" then --write comand
                            func_write <= '1';
                        end if;
                    end if;
                    
                when first_byte =>
                    if valid = '1' then
                        data_write_i(7 downto 0) <= data_in;
                        state <= second_byte;
                    end if;
                    
                when second_byte =>
                    if valid = '1' then
                        data_write_i(15 downto 8) <= data_in;
                        state <= third_byte;
                    end if;
                    
                when third_byte =>
                    if valid = '1' then
                        data_write_i(23 downto 16) <= data_in;
                        state <= fourth_byte;
                    end if;
                    
                when fourth_byte =>
                    if valid = '1' then
                        data_write_i(31 downto 24) <= data_in;
                        if func_write = '1' then
                            state <= write_cmd;
                        end if;
                    end if;
                    
               when write_cmd =>
                    write_out_i <= '1';
                    state <= idle;
                  

            end case;
        end if;
    end process;

    addr <= addr_i;
    data_write <= data_write_i;
            write_out <= write_out_i;
           read_out <= func_read;

end Behavioral;
