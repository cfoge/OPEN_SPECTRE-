library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
--use work.types_pkg.all;

entity debounced_button_decoder is
  generic (
    g_NUM_KEY_ROWS      : integer := 5;
    g_NUM_KEY_COLUMNS   : integer := 6
  );
  port (
    reset_n              : in  std_logic;
    clock_i             : in  std_logic;
    debounce_strobe_i   : in  std_logic := '1';    -- Strobe for debounce ~10ms    
    -- Keypad Input
    columns_i           : in  std_logic_vector(g_NUM_KEY_COLUMNS-1 downto 0);    
    rows_o              : out std_logic_vector(g_NUM_KEY_ROWS-1 downto 0);
    -- Button state
    button_state_o      : out std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);
    button_event_o      : out std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0)   
  );
end debounced_button_decoder;

---------------------------------------------------------------------------------
architecture rtl of debounced_button_decoder is
  type t_slv2_array    is array (natural range <>) of std_logic_vector(1 downto 0); 
  type t_slv3_array    is array (natural range <>) of std_logic_vector(2 downto 0);
  

  signal debounce_count     : integer range 0 to (g_NUM_KEY_ROWS-1);
  signal raw_button_state   : std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);
  signal meta_button_state  : t_slv2_array(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);
  signal debounced_button   : t_slv3_array(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);
  signal event_internal     : std_logic_vector(g_NUM_KEY_COLUMNS*g_NUM_KEY_ROWS-1 downto 0);  
  signal row_select         : std_logic_vector(g_NUM_KEY_ROWS-1 downto 0);
  signal clock_divider      : unsigned(19 downto 0);
  signal sample_strobe      : std_logic;
  signal clear_state_strobe : std_logic;

begin

  ---------------------------------------------------------------------------
  -- Clock divider
  ---------------------------------------------------------------------------
  clock_div_p : process (reset_n, clock_i) is
  begin
    if (reset_n = '0') then
      clock_divider <= (Others => '0');
    elsif rising_edge(clock_i) then
      clock_divider <= clock_divider + 1;
      -- Key sample strobe
      if (clock_divider(9 downto 0) = 0) then
        sample_strobe <= '1';
      else
        sample_strobe <= '0';
      end if;
      -- Button state clear
      if (clock_divider = 0) then
        clear_state_strobe <= '1';
      else
        clear_state_strobe <= '0';
      end if;
    end if;
  end process clock_div_p;

  ---------------------------------------------------------------------------
  -- Debounce buttons
  -- Drive row and check col to see which button has been pressed
  ---------------------------------------------------------------------------
  button_decode_p : process (reset_n, clock_i) is
  begin
    if (reset_n = '0') then
      debounce_count <= 0;
      row_select <= conv_std_logic_vector(1, g_NUM_KEY_ROWS);
      raw_button_state <= (others => '0');  
    elsif rising_edge(clock_i) then
      if (sample_strobe = '1') then
        -- Scan each row
        debounce_count <= debounce_count + 1;
        -- Drive each row
        if debounce_count = (g_NUM_KEY_ROWS-1) then
          if (row_select = conv_std_logic_vector(2**(g_NUM_KEY_ROWS-1), g_NUM_KEY_ROWS)) then
            row_select <= conv_std_logic_vector(1, g_NUM_KEY_ROWS);
          else
            row_select((g_NUM_KEY_ROWS-1) downto 0) <= row_select((g_NUM_KEY_ROWS-2) downto 0) & '0'; -- shift bit in every 40ms
          end if;
        end if;
        
        -- Weak pull-up on columns overridden by button
        -- Extract the button pressed
        for k in row_select'range loop
          if (row_select(k) = '1') then
             raw_button_state(k*g_NUM_KEY_COLUMNS + g_NUM_KEY_COLUMNS-1 downto k*g_NUM_KEY_COLUMNS) <= columns_i;
          end if;
        end loop;

      end if;
    end if;
  end process button_decode_p;
    
  rows_o <= row_select;

 
     ---------------------------------------------------------------------------
    -- Sample key state and remove metastability
    ---------------------------------------------------------------------------
    pSAMPLE_KEY : process (reset_n, clock_i) is
    begin
      if (reset_n = '0') then
          meta_button_state <= (others => (others => '0'));
      elsif rising_edge(clock_i) then
        for k in raw_button_state'range loop
          meta_button_state(k) <= meta_button_state(k)(0) & raw_button_state(k);            
        end loop;
      end if;
    end process pSAMPLE_KEY;
    
    ---------------------------------------------------------------------------
    -- Key debounce
    -- Button state is set when a stable key press is detected
    -- Button event is toggled when a stable key release is detected
    ---------------------------------------------------------------------------
    pKEY_DEBOUNCE : process (reset_n, clock_i) is
    begin
        if (reset_n = '0') then
            debounced_button <= (others => (others => '0'));
            button_state_o <= (others => '0');
            event_internal <= (others => '0');
        elsif rising_edge(clock_i) then
            if debounce_strobe_i = '1' then
              for k in raw_button_state'range loop
                debounced_button(k) <= debounced_button(k)(1 downto 0) & meta_button_state(k)(1);
                case debounced_button(k) is
                when "011" | "111"    =>  button_state_o(k) <= '1';
                when "000"            =>  button_state_o(k) <= '0';
                when "100"            =>  button_state_o(k) <= '0';
                                          event_internal(k) <= not(event_internal(k));
                when others           => null;
                end case;
              end loop;
            end if;            
        end if;
    end process pKEY_DEBOUNCE;
    
    button_event_o <= event_internal; 
  
   
end rtl;
