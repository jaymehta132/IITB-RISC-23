library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Comparator is
  port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); E, L: out std_logic);
end entity Comparator;

architecture Struct of Comparator is

	component Full_Adder is
     port(A, B, Ci: in std_logic;
         SUM, CARRY: out std_logic);
   end component;
	
	component OR_16input  is
		port (A: in std_logic_vector(15 downto 0); Y: out std_logic);
	end component OR_16input;
	
	signal Carry : std_logic_vector(16 downto 0);
	signal B_new, S : std_logic_vector(15 downto 0);
	signal Temp: std_logic;
  begin
	Gen1 : for i in 0 to 15 generate
		XOR_gate : XOR_2 port map (A => B(i), B => '1', Y => B_new(i));
	end generate;
	
	Carry(0) <= '1';
	
	Gen2 : for i in 0 to 15 generate 
		FA : Full_Adder port map (A => A(i), B => B_new(i), Ci => Carry(i), SUM => S(i), CARRY => Carry(i+1));
		end generate;
		
	OR_16ip: OR_16input port map (A => S, Y => Temp);
	
	E <= not Temp;
	L <= Carry(16);
	
end Struct;