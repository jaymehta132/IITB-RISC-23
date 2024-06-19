library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Adder_plus2  is
  port (A: in std_logic_vector(15 downto 0); S: out std_logic_vector(15 downto 0));
end entity Adder_plus2;

architecture Struct of Adder_plus2 is

	component Full_Adder is
     port(A, B, Ci: in std_logic;
         SUM, CARRY: out std_logic);
   end component;
	
	signal Carry : std_logic_vector(16 downto 0);
	signal B : std_logic_vector(15 downto 0);
	begin
	B <= "0000000000000010";
	Carry(0) <= '0';
	
	Gen2 : for i in 0 to 15 generate 
		FA : Full_Adder port map (A => A(i), B => B(i), Ci => Carry(i), SUM => S(i), CARRY => Carry(i+1));
		end generate;
end Struct;