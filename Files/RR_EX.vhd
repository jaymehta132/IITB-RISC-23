library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity RR_EX is
	port(Clk, valid_in,enable,enable_RA : in std_logic;	
		opcode_in : in std_logic_vector(3 downto 0);
		RA_in : in std_logic_vector(2 downto 0);
		RB_in : in std_logic_vector(2 downto 0);
		RC_in : in std_logic_vector(2 downto 0);
        RA_Cin : in std_logic_vector(15 downto 0);
		RB_Cin : in std_logic_vector(15 downto 0);
		comp_in : in std_logic;
		cond_in: in std_logic_vector(1 downto 0);
		imm6_in : in std_logic_vector(5 downto 0);
		imm9_in : in std_logic_vector(8 downto 0);
		PC_in: in std_logic_vector(15 downto 0);
		PC_2in: in std_logic_vector(15 downto 0);
		
		opcode_out : out std_logic_vector(3 downto 0);
		RA_out : out std_logic_vector(2 downto 0);
		RB_out : out std_logic_vector(2 downto 0);
		RC_out : out std_logic_vector(2 downto 0);
        RA_Cout : out std_logic_vector(15 downto 0);
		RB_Cout : out std_logic_vector(15 downto 0);
		comp_out : out std_logic;
		cond_out: out std_logic_vector(1 downto 0);
		imm6_out : out std_logic_vector(5 downto 0);
		imm9_out : out std_logic_vector(8 downto 0);
		PC_out: out std_logic_vector(15 downto 0);
		PC_2out: out std_logic_vector(15 downto 0);
		valid_out: out std_logic);
end entity;

architecture struct of RR_EX is
	signal D: std_logic_vector(95 downto 0);
	signal Do: std_logic_vector(95 downto 0);
	signal Dob: std_logic_vector(95 downto 0);
	signal enable_RA_dff : std_logic;
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=RB_in & valid_in & RA_Cin & opcode_in & RA_in & RC_in & RB_Cin & comp_in & cond_in & imm6_in & imm9_in & PC_in & PC_2in;
	generation:  for i in 0 to 95 generate
		en_gen: if(i=92) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));      --changed enable signal to enable 
		end generate en_gen;

		RA_gen: if(i<92 and i>75) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable => enable_RA_dff, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));			--changed enable signal to enable or enable_RA
		end generate RA_gen;

		norm_gen: if(i<76) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));			--changed enable signal to enable 
		end generate norm_gen;

	end generate;

	enable_RA_dff <= (enable_RA or enable);
	RB_out<=Do(95 downto 93);
	valid_out<=Do(92);
	RA_Cout<=Do(91 downto 76);
	opcode_out<=Do(75 downto 72);
	RA_out<=Do(71 downto 69);
	RC_out<=Do(68 downto 66);
	RB_Cout<=Do(65 downto 50);
	comp_out<=Do(49);
	cond_out<=Do(48 downto 47);
	imm6_out<=Do(46 downto 41);
	imm9_out<=Do(40 downto 32);
	PC_out<=Do(31 downto 16);
	PC_2out<=Do(15 downto 0);
end architecture struct;