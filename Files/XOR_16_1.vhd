library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity XOR_16_1  is
  port (A: in std_logic; B: in std_logic_vector(15 downto 0); Y: out std_logic_vector(15 downto 0));
end entity XOR_16_1;

architecture Struct of XOR_16_1 is
  
begin
  Gen1: for i in 0 to 15 generate 
		XOR_gate: XOR_2 port map (A => A, B => B(i), Y => Y(i));
		end generate;
end Struct;