library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Full_Adder_Sub16bit  is
  port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); CY: in std_logic; S: out std_logic_vector(15 downto 0); A_CY: out std_logic);
end entity Full_Adder_sub16bit;

architecture Struct of Full_Adder_sub16bit is

	component Full_Adder is
     port(A, B, Ci: in std_logic;
         SUM, CARRY: out std_logic);
   end component;
	
	signal Carry: std_logic_vector(16 downto 0);
  begin
	Carry(0)<= CY;
	Gen2 : for i in 0 to 15 generate 
		FA : Full_Adder port map (A => A(i), B => B(i), Ci => Carry(i), SUM => S(i), CARRY => Carry(i+1));
		end generate;
		
	A_CY <= Carry(16);
	
end Struct;