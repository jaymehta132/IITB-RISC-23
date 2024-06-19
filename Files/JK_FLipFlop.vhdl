library ieee;
use ieee.std_logic_1164.all;

entity JK_FLipFlop is
	port( J: in std_logic; K: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
end entity JK_FlipFlop;

architecture struct of JK_FlipFlop is
	signal state: std_logic:='0';
	signal input: std_logic_vector(1 downto 0);
begin
  clock_process: process(J,K,clk,enable,preset,reset)
  begin
		input(0)<=K;
		input(1)<=J;
		if(preset ='1') then
			state<='1';
		elsif (reset='1') then
			state<='0';
		elsif (Clk'event and Clk='1') then
			if(enable='1') then
				case(input) is
					when "10" =>
						state <= '1';
					when "01" =>
						state <= '0';
					when "00" =>
						state<=state;
					when "11" =>
						state<=not state;
					when others=>
						null;
				end case;
			end if;
		end if;
  end process clock_process;
  Q<=state;
  Qb<=not state;

end architecture struct;	