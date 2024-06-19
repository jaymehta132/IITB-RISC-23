library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity IF_ID is
	port(Clk, valid_in, enable : in std_logic;	
		Instr_in : in std_logic_vector(15 downto 0);
		PC_2in : in std_logic_vector(15 downto 0);
		PC_in: in std_logic_vector(15 downto 0);
		Instr_out : out std_logic_vector(15 downto 0);
		PC_2out : out std_logic_vector(15 downto 0);
		PC_out: out std_logic_vector(15 downto 0);
		valid_out: out std_logic);
end entity;

architecture struct of IF_ID is
	signal D: std_logic_vector(48 downto 0);
	signal Do: std_logic_vector(48 downto 0);
	signal Dob: std_logic_vector(48 downto 0);
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=Instr_in & PC_2in & PC_in & valid_in;
	generation:  for i in 0 to 48 generate
		en_gen: if(i=0) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>'1', reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate en_gen;

		norm_gen: if(i>0) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate norm_gen;


	end generate;
	Instr_Out<=Do(48 downto 33);
	PC_2out<=Do(32 downto 17);
	PC_out<=Do(16 downto 1);
	valid_out<=Do(0);
end architecture struct;