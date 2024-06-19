library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Priority_Encoder_4_2 is
  port (SigIn : in std_logic_vector(3 downto 0);
        V: out std_logic;
        SigOut : out std_logic_vector(1 downto 0));
end entity Priority_Encoder_4_2;

architecture Struct of Priority_Encoder_4_2 is
  signal S1, S2, S3, S4 : std_logic;
begin
  -- component instances
  OR1 : OR_2 port map (A => SigIn(3), B => SigIn(2), Y => S4);
  OR5 : OR_2 port map (A => SigIn(3), B => SigIn(2), Y => SigOut(1));
  OR2 : OR_2 port map (A => SigIn(0), B => SigIn(1), Y => S1);
  OR3 : OR_2 port map (A => S4, B => S1, Y => V);
  NOT1 : INVERTER port map (A => SigIn(2), Y => S2);
  AND1 : AND_2 port map (A => S2, B => SigIn(1), Y => S3);
  OR4 : OR_2 port map (A => SigIn(3), B => S3, Y => SigOut(0));
end Struct;