library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity ID_RR is
	port(Clk, valid_in,enable : in std_logic;	
		opcode_in : in std_logic_vector(3 downto 0);
		RA_in : in std_logic_vector(2 downto 0);
		RB_in: in std_logic_vector(2 downto 0);
		RC_in : in std_logic_vector(2 downto 0);
		comp_in : in std_logic;
		cond_in: in std_logic_vector(1 downto 0);
		imm6_in : in std_logic_vector(5 downto 0);
		imm9_in : in std_logic_vector(8 downto 0);
		PC_in: in std_logic_vector(15 downto 0);
		PC_2in: in std_logic_vector(15 downto 0);
		
		opcode_out : out std_logic_vector(3 downto 0);
		RA_out : out std_logic_vector(2 downto 0);
		RB_out: out std_logic_vector(2 downto 0);
		RC_out : out std_logic_vector(2 downto 0);
		comp_out : out std_logic;
		cond_out: out std_logic_vector(1 downto 0);
		imm6_out : out std_logic_vector(5 downto 0);
		imm9_out : out std_logic_vector(8 downto 0);
		PC_out: out std_logic_vector(15 downto 0);
		PC_2out: out std_logic_vector(15 downto 0);
		valid_out: out std_logic);
end entity;

architecture struct of ID_RR is
	signal D: std_logic_vector(63 downto 0);
	signal Do: std_logic_vector(63 downto 0);
	signal Dob: std_logic_vector(63 downto 0);
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=valid_in & opcode_in & RA_in & RB_in & RC_in & comp_in & cond_in & imm6_in & imm9_in & PC_in & PC_2in;
	generation:  for i in 0 to 63 generate
		en_gen: if(i=63) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>'1', reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate en_gen;

		norm_gen: if(i<63) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate norm_gen;
	end generate;
	valid_out<=Do(63);
	opcode_out<=Do(62 downto 59);
	RA_out<=Do(58 downto 56);
	RB_out<=Do(55 downto 53);
	RC_out<=Do(52 downto 50);
	comp_out<=Do(49);
	cond_out<=Do(48 downto 47);
	imm6_out<=Do(46 downto 41);
	imm9_out<=Do(40 downto 32);
	PC_out<=Do(31 downto 16);
	PC_2out<=Do(15 downto 0);
end architecture struct;