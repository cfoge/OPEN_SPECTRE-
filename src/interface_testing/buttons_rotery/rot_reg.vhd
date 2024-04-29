
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rot_reg is
  port
  (
    sw_a  : in std_logic;
    sw_b  : in std_logic;
    step_size : in std_logic; -- 0 = stepsize of 1, 1 = stepsize of 4
    input_addr : in  std_logic_vector(4 - 1 downto 0);
    rst   : in std_logic;
    clk   : in std_logic;
    output_regs_o : out std_logic_vector(47 downto 0); --all regs concatinated together
    rotary_event_o : out std_logic
  );
end rot_reg;

architecture Behavioral of rot_reg is

  constant REG_WIDTH  : integer := 12; -- Width of input registers
  constant REG_COUNT  : integer := 4; -- Number of input registers
  constant ADDR_WIDTH : integer := 5; -- Address width for 32 registers (2^5 = 32)

  signal rotary_event, rotary_event_d, rotary_event_d2, rotary_event_d3 : std_logic := '0';
  signal rotary_dir                                                     : std_logic;
  signal rotary_dir_reg                                                 : std_logic;
  signal input_data                                                     : std_logic_vector(12 - 1 downto 0);
  signal data_out                                                       : std_logic_vector(12 - 1 downto 0);
  
  signal step_size_adder                                                     : std_logic_vector(12 - 1 downto 0);
  signal output_regs_e1                                                 : std_logic_vector(12 - 1 downto 0); -- reg value stored here before math

  type output_regs_a is array (0 to REG_COUNT - 1) of std_logic_vector(12 - 1 downto 0);
  signal output_regs    : output_regs_a;

     attribute keep                   : string;
     attribute keep of output_regs     : signal is "true";
  --   attribute keep of rotary_event_o : signal is "true";
  --   attribute keep of rotary_dir_o   : signal is "true";
begin

 process (clk) -- set stepsize
  begin
    if rising_edge(clk) then
        if step_size ='0' then
            step_size_adder  <= "000000000001"; 
        else
            step_size_adder  <= "000000000100";
        end if;
    end if;  
end process;

  customized_rotary_encoder_quad_inst : entity work.customized_rotary_encoder_quad
    generic
    map (
    g_DATA_WIDTH => 12
    )
    port map
    (
      clk_i          => clk,
      swa_i          => sw_a,
      swb_i          => sw_b,
      rotary_event_o => rotary_event,
      rotary_dir_o   => rotary_dir,
      data_out_o     => input_data
    );

  process (clk)
  begin
    if rst = '1' then
      output_regs(0) <= ((others => '0')); -- clear the register
      output_regs(1) <= ((others => '0')); -- clear the register
      output_regs(2) <= ((others => '0')); -- clear the register
      output_regs(3) <= ((others => '0')); -- clear the register
        else

        if rising_edge(clk) then
          rotary_event_d  <= rotary_event;
          rotary_event_d2 <= rotary_event_d;
          rotary_event_d3 <= rotary_event_d2;
          if rotary_event = '1' and rotary_event_d = '0' then -- if the rot encoder changed latch the curent reg value
            output_regs_e1 <= output_regs(to_integer(unsigned(input_addr)));
            rotary_dir_reg                      <= rotary_dir;
        end if;

          if rotary_event_d2 = '1' and rotary_event_d = '0' then -- 3 cycles after the event 
            output_regs(to_integer(unsigned(input_addr))) <= data_out;
        end if;

      end if;
    end if;
   
   
end process;

adder_subtractor : entity work.Adder_Subtractor_12bit_OverflowProtection
  port
  map (
  A         => output_regs_e1,
  B         => step_size_adder,
  Mode      => rotary_dir_reg,
  Result    => data_out,
  Overflow  => open,
  Underflow => open
  );


-- assign output regs as a single bus
  output_regs_o <= output_regs(3) & output_regs(2) & output_regs(1) & output_regs(0);
  rotary_event_o <= rotary_event;

  end Behavioral;