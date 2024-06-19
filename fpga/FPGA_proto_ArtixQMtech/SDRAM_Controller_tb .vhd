library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SDRAM_Controller_tb is
end SDRAM_Controller_tb;

architecture Behavioral of SDRAM_Controller_tb is

    -- Component Declaration for the SDRAM Controller
    component SDRAM_Controller is
        Port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            
            -- CPU Interface
            cpu_rd_req    : in  std_logic;
            cpu_wr_req    : in  std_logic;
            cpu_addr      : in  std_logic_vector(22 downto 0);
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
    end component;

    -- Signals for testing
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal cpu_rd_req   : std_logic := '0';
    signal cpu_wr_req   : std_logic := '0';
    signal cpu_addr     : std_logic_vector(22 downto 0) := (others => '0');
    signal cpu_wr_data  : std_logic_vector(15 downto 0) := (others => '0');
    signal cpu_rd_data  : std_logic_vector(15 downto 0);
    signal cpu_rd_valid : std_logic;
    signal cpu_wr_ack   : std_logic;

    signal SDRAM_CKE    : std_logic;
    signal SDRAM_CS_N   : std_logic;
    signal SDRAM_RAS_N  : std_logic;
    signal SDRAM_CAS_N  : std_logic;
    signal SDRAM_WE_N   : std_logic;
    signal SDRAM_BA     : std_logic_vector(1 downto 0);
    signal SDRAM_A      : std_logic_vector(12 downto 0);
    signal SDRAM_DQM    : std_logic_vector(1 downto 0);
    signal SDRAM_DQ     : std_logic_vector(15 downto 0);

    -- Clock generation process
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz clock
    begin
        process
        begin
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end process;

    -- Instantiate the Unit Under Test (UUT)
    UUT: SDRAM_Controller
        Port map (
            clk          => clk,
            rst          => rst,
            cpu_rd_req   => cpu_rd_req,
            cpu_wr_req   => cpu_wr_req,
            cpu_addr     => cpu_addr,
            cpu_wr_data  => cpu_wr_data,
            cpu_rd_data  => cpu_rd_data,
            cpu_rd_valid => cpu_rd_valid,
            cpu_wr_ack   => cpu_wr_ack,
            SDRAM_CKE    => SDRAM_CKE,
            SDRAM_CS_N   => SDRAM_CS_N,
            SDRAM_RAS_N  => SDRAM_RAS_N,
            SDRAM_CAS_N  => SDRAM_CAS_N,
            SDRAM_WE_N   => SDRAM_WE_N,
            SDRAM_BA     => SDRAM_BA,
            SDRAM_A      => SDRAM_A,
            SDRAM_DQM    => SDRAM_DQM,
            SDRAM_DQ     => SDRAM_DQ
        );

    -- Test sequence
    process
    begin
        -- Reset the system
        rst <= '1';
        wait for 50 ns;
        rst <= '0';

        -- Wait for initialization to complete
        wait for 500 ns;

        -- Write data to SDRAM
        cpu_wr_req <= '1';
        cpu_addr <= "00000000000000000000001"; -- Example address
        cpu_wr_data <= x"1234"; -- Example data
        wait for CLK_PERIOD;
        cpu_wr_req <= '0';
        wait for 100 ns;

        -- Read data from SDRAM
        cpu_rd_req <= '1';
        cpu_addr <= "00000000000000000000001"; -- Same address as written
        wait for CLK_PERIOD;
        cpu_rd_req <= '0';
        wait for 100 ns;

        -- Add more read/write operations if needed
        -- ...

        -- End of simulation
        wait;
    end process;

end Behavioral;
