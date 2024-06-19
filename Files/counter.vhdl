library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity counter is 
    port(enable,clk,reset: in std_logic; count: out std_logic_vector(2 downto 0); end_bit: out std_logic);
end entity counter;

architecture struct of counter is 
    component JK_FLipFlop is
        port( J: in std_logic; K: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
                Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
    end component JK_FlipFlop;
    signal q_int: std_logic_vector(3 downto 0):="0111";
    begin
        --jk0: JK_FlipFlop port map(J=>'1',K=>'1',clk=>clk,enable=>enable,reset=>'0',preset=>(change or reset),Q=>Q_out(0),Qb=>Qb_out(0));
        --jk1: JK_FlipFlop port map(J=>Qb_out(0),K=>Qb_out(0),clk=>clk,enable=>enable,reset=>'0',preset=>(change or reset),Q=>Q_out(1),Qb=>Qb_out(1));
        --jk2: JK_FlipFlop port map(J=>(Qb_out(1) and Qb_out(0)),K=>(Qb_out(1) and Qb_out(0)),clk=>clk,enable=>enable,reset=>'0',preset=>(change or reset),Q=>Q_out(2),Qb=>Qb_out(2));
        --jk3: JK_FlipFlop port map(J=>(Qb_out(1) and Qb_out(0) and Qb_out(2)),K=>(Qb_out(1) and Qb_out(0) and Qb_out(2)),clk=>clk,enable=>enable,reset=>(change or reset),preset=>'0',Q=>Q_out(3),Qb=>Qb_out(3));
        --end_bit<=Q_out(3); --1-> completed
        --count<=Q_out(2 downto 0);
        --change<=Q_out(3);

        process(clk, reset)
        begin
            if reset = '1' then
                q_int <= "1000";  -- Initialize the counter to 8 (1000 in binary) on reset
            elsif (clk'event and clk = '1') then
                case q_int is
                    when "1000" =>
                        q_int <= "0111";  -- Transition from 8 to 7
                    when "0111" =>
                        q_int <= "0110";  -- Transition from 7 to 6
                    when "0110" =>
                        q_int <= "0101";  -- Transition from 6 to 5
                    when "0101" =>
                        q_int <= "0100";  -- Transition from 5 to 4
                    when "0100" =>
                        q_int <= "0011";  -- Transition from 4 to 3
                    when "0011" =>
                        q_int <= "0010";  -- Transition from 3 to 2
                    when "0010" =>
                        q_int <= "0001";  -- Transition from 2 to 1
                    when others =>
                        q_int <= "1000";  -- Transition from 1 to 0 and 0 to 9
                end case;
            end if;
        end process;

        Count <= q_int(2 downto 0);  -- Output the counter value
        end_bit <= q_int(3);


end architecture struct;