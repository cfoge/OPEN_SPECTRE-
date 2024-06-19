library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SDRAM_Controller is
    Port (
        clk           : in  std_logic;
        rst           : in  std_logic;
        
        -- CPU Interface
        cpu_rd_req    : in  std_logic;
        cpu_wr_req    : in  std_logic;
        cpu_addr      : in  std_logic_vector(22 downto 0); -- 23-bit address for 4M x 4 banks x 16 bits
        cpu_wr_data   : in  std_logic_vector(15 downto 0);
        cpu_rd_data   : out std_logic_vector(15 downto 0);
        cpu_rd_valid  : out std_logic;
        cpu_wr_ack    : out std_logic;
        
        -- SDRAM Interface
        SDRAM_CKE     : out std_logic;
        SDRAM_CS_N    : out std_logic;
        SDRAM_RAS_N   : out std_logic;
        SDRAM_CAS_N   : out std_logic;
        SDRAM_WE_N    : out std_logic;
        SDRAM_BA      : out std_logic_vector(1 downto 0);
        SDRAM_A       : out std_logic_vector(12 downto 0);
        SDRAM_DQM     : out std_logic_vector(1 downto 0);
        SDRAM_DQ      : inout std_logic_vector(15 downto 0)
    );
end SDRAM_Controller;

architecture Behavioral of SDRAM_Controller is

    type state_type is (IDLE, INIT, ACTIVE, READ, WRITE, PRECHARGE, REFRESH);
    signal state, next_state : state_type;

    signal sdram_cmd : std_logic_vector(2 downto 0);
    signal addr_reg  : std_logic_vector(22 downto 0);
    signal data_out  : std_logic_vector(15 downto 0);
    signal data_in   : std_logic_vector(15 downto 0);
    signal rd_valid  : std_logic;
    signal wr_ack    : std_logic;
    signal oe        : std_logic;
    signal init_done : std_logic := '0';
    signal auto_refresh_counter : integer := 0;
    signal auto_refresh_trigger : std_logic := '0';

    constant CMD_LOADMODE  : std_logic_vector(2 downto 0) := "000";
    constant CMD_REFRESH   : std_logic_vector(2 downto 0) := "001";
    constant CMD_PRECHARGE : std_logic_vector(2 downto 0) := "010";
    constant CMD_ACTIVE    : std_logic_vector(2 downto 0) := "011";
    constant CMD_WRITE     : std_logic_vector(2 downto 0) := "100";
    constant CMD_READ      : std_logic_vector(2 downto 0) := "101";
    constant CMD_NOP       : std_logic_vector(2 downto 0) := "111";

    -- Initialization sequence states
    type init_state_type is (INIT_IDLE, PRECHARGE_ALL, AUTO_REFRESH_1, AUTO_REFRESH_2, LOAD_MODE_REGISTER, INIT_DONE);
    signal init_state : init_state_type := INIT_IDLE;

begin

    -- SDRAM Command Signals
    SDRAM_CKE <= '1';
    SDRAM_CS_N <= '0';
    SDRAM_RAS_N <= sdram_cmd(2);
    SDRAM_CAS_N <= sdram_cmd(1);
    SDRAM_WE_N <= sdram_cmd(0);

    -- SDRAM Address and Data Signals
    SDRAM_BA <= addr_reg(22 downto 21);
    SDRAM_A <= addr_reg(20 downto 8);
    SDRAM_DQM <= "00";
    SDRAM_DQ <= (others => 'Z') when oe = '0' else data_out;

    -- Auto-Refresh Timer
    process (clk, rst)
    begin
        if rst = '1' then
            auto_refresh_counter <= 0;
            auto_refresh_trigger <= '0';
        elsif rising_edge(clk) then
            if auto_refresh_counter >= 1562 then -- 15.625 us / 10 ns = 1562.5, rounded to 1562 cycles
                auto_refresh_counter <= 0;
                auto_refresh_trigger <= '1';
            else
                auto_refresh_counter <= auto_refresh_counter + 1;
                auto_refresh_trigger <= '0';
            end if;
        end if;
    end process;

    -- State Machine
    process (clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
            sdram_cmd <= CMD_NOP;
            oe <= '0';
            rd_valid <= '0';
            wr_ack <= '0';
            init_state <= INIT_IDLE;
            init_done <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if init_done = '0' then
                        next_state <= INIT;
                    elsif auto_refresh_trigger = '1' then
                        next_state <= REFRESH;
                    elsif cpu_rd_req = '1' then
                        addr_reg <= cpu_addr;
                        next_state <= ACTIVE;
                    elsif cpu_wr_req = '1' then
                        addr_reg <= cpu_addr;
                        next_state <= ACTIVE;
                    else
                        sdram_cmd <= CMD_NOP;
                        next_state <= IDLE;
                    end if;

                when INIT =>
                    case init_state is
                        when INIT_IDLE =>
                            sdram_cmd <= CMD_NOP;
                            init_state <= PRECHARGE_ALL;
                            
                        when PRECHARGE_ALL =>
                            sdram_cmd <= CMD_PRECHARGE;
                            SDRAM_A(10) <= '1'; -- Precharge all banks
                            init_state <= AUTO_REFRESH_1;
                            
                        when AUTO_REFRESH_1 =>
                            sdram_cmd <= CMD_REFRESH;
                            init_state <= AUTO_REFRESH_2;
                            
                        when AUTO_REFRESH_2 =>
                            sdram_cmd <= CMD_REFRESH;
                            init_state <= LOAD_MODE_REGISTER;
                            
                        when LOAD_MODE_REGISTER =>
                            sdram_cmd <= CMD_LOADMODE;
                            SDRAM_A <= "0000001100000"; -- Burst length = 1, CAS latency = 2
                            init_state <= INIT_DONE;
                            
                        when INIT_DONE =>
                            sdram_cmd <= CMD_NOP;
                            init_done <= '1';
                            next_state <= IDLE;
                    end case;

                when ACTIVE =>
                    sdram_cmd <= CMD_ACTIVE;
                    SDRAM_BA <= addr_reg(22 downto 21);
                    SDRAM_A <= addr_reg(20 downto 8);
                    if cpu_rd_req = '1' then
                        next_state <= READ;
                    else
                        next_state <= WRITE;
                    end if;

                when READ =>
                    sdram_cmd <= CMD_READ;
                    SDRAM_A(10) <= '0'; -- No auto-precharge
                    SDRAM_A(9 downto 0) <= addr_reg(7 downto 0); -- Column address
                    rd_valid <= '1';
                    next_state <= PRECHARGE;

                when WRITE =>
                    sdram_cmd <= CMD_WRITE;
                    data_out <= cpu_wr_data;
                    oe <= '1';
                    SDRAM_A(10) <= '0'; -- No auto-precharge
                    SDRAM_A(9 downto 0) <= addr_reg(7 downto 0); -- Column address
                    wr_ack <= '1';
                    next_state <= PRECHARGE;

                when PRECHARGE =>
                    sdram_cmd <= CMD_PRECHARGE;
                    SDRAM_A(10) <= '1'; -- Precharge current bank
                    next_state <= IDLE;

                when REFRESH =>
                    sdram_cmd <= CMD_REFRESH;
                    next_state <= IDLE;
            end case;
        end if;
    end process;

    -- Output Signals
    cpu_rd_data <= data_in when rd_valid = '1' else (others => 'Z');
    cpu_rd_valid <= rd_valid;
    cpu_wr_ack <= wr_ack;

end Behavioral;
