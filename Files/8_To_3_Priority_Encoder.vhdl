library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

-- Entity declaration
entity Priority_Encoder_8_3 is
    port (	SigIn : in std_logic_vector(7 downto 0);
				SigOut : out std_logic_vector(2 downto 0);
				V : out std_logic);
end entity Priority_Encoder_8_3;

-- Architecture definition
architecture Struct of Priority_Encoder_8_3 is
begin
    V <= SigIn(0) or SigIn(1) or SigIn(2) or SigIn(3) or SigIn(4) or SigIn(5) or SigIn(6) or SigIn(7);
    SigOut(2) <= SigIn(7) or SigIn(6) or SigIn(5) or SigIn(4);
    SigOut(1) <= (SigIn(1) and not SigIn(5)) or (SigIn(3) and not SigIn(5)) or SigIn(6) or SigIn(7);
    SigOut(0) <= (SigIn(1) and not SigIn(2) and not SigIn(4) and not SigIn(6)) or (SigIn(3) and not SigIn(4) and not SigIn(6)) or (SigIn(5) and not SigIn(6)) or SigIn(7);
end architecture Struct;