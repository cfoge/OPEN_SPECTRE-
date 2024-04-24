

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity monstable_4 is
  Port ( 
        input  : in std_logic;
        clk  : in std_logic;
        output : out STD_LOGIC_VECTOR (3 downto 0)
  );
end monstable_4;

architecture Behavioral of monstable_4 is
signal ed_o0, ed_o1, ed_o2, ed_o3 : std_logic;
signal ed_o2_d,ed_o2_d2,ed_o2_d3, ed_o3_d,ed_o3_d2,ed_o3_d3, ed_o2_stretch, ed_o3_stretch  : std_logic;

begin
    ed_1: entity work.edge_detector
        port map (
            x => input,
            clk => clk,
            rising_edge_O => ed_o0
        );
     ed_2: entity work.edge_detector
        port map (
            x => input,
            clk => clk,
            falling_edge_O => ed_o1
        );
     ed_3: entity work.edge_detector
        port map (
            x => input,
            clk => clk,
            rising_edge_O => ed_o2
        );
     ed_4: entity work.edge_detector
        port map (
            x => input,
            clk => clk,
            falling_edge_O => ed_o3
        );
        
        process(clk) -- edge width stretched 3 clks, does it need to be more?
        begin
            if rising_edge(clk) then
                ed_o2_d <= ed_o2;
                ed_o2_d2 <= ed_o2_d;
                ed_o2_d3 <= ed_o2_d2;
                ed_o3_d <= ed_o3;
                ed_o3_d2 <= ed_o3_d;
                ed_o3_d3 <= ed_o3_d2;    
            end if;    
        end process;
        
        
        ed_o2_stretch <= ed_o2 or ed_o2_d or ed_o2_d2 or ed_o2_d3;
        ed_o3_stretch <= ed_o3 or ed_o3_d or ed_o3_d2 or ed_o3_d3;
        
        output(0) <= ed_o0;
        output(1) <= ed_o1;
        output(2) <=  ed_o2_stretch;
        output(3) <=  ed_o3_stretch;

end Behavioral;
