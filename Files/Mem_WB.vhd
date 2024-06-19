library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mem_WB is
	port(Clk, valid_in,enable : in std_logic;	
		counter_in: in std_logic_vector(2 downto 0);
		LSMen_in: in std_logic;	
		opcode_in : in std_logic_vector(3 downto 0);
		RA_in : in std_logic_vector(2 downto 0);
		RB_in : in std_logic_vector(2 downto 0);
		RC_in : in std_logic_vector(2 downto 0);
		imm9_in : in std_logic_vector(8 downto 0);
		PC_2in: in std_logic_vector(15 downto 0);
        ALUC_in: in std_logic_vector(15 downto 0);
		RF_edit_in: in std_logic;
        Dout_in: in std_logic_vector(15 downto 0);

		opcode_out : out std_logic_vector(3 downto 0);
		RA_out : out std_logic_vector(2 downto 0);
		RB_out : out std_logic_vector(2 downto 0);
		RC_out : out std_logic_vector(2 downto 0);
		imm9_out : out std_logic_vector(8 downto 0);
		PC_2out: out std_logic_vector(15 downto 0);
        ALUC_out: out std_logic_vector(15 downto 0);
		RF_edit_out: out std_logic;
        Dout_out: out std_logic_vector(15 downto 0);
		valid_out: out std_logic;
		LSMen_out: out std_logic;
		counter_out: out std_logic_vector(2 downto 0));
end entity;

architecture struct of Mem_WB is
	signal D: std_logic_vector(75 downto 0);
	signal Do: std_logic_vector(75 downto 0);
	signal Dob: std_logic_vector(75 downto 0);
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=RB_in & counter_in & LSMen_in & valid_in & opcode_in & RA_in & RC_in & imm9_in & Dout_in & PC_2in & ALUC_in & RF_edit_in;
	generation:  for i in 0 to 75 generate
		en_gen: if(i=68) generate  --(earlier was /=, changed to =)
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>'1', reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate en_gen;

		norm_gen: if(i/=68) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate norm_gen;
	end generate;

	RB_out<=Do(75 downto 73);
	counter_out<=Do(72 downto 70);
	LSMen_out<=Do(69);
	valid_out<=Do(68);
	opcode_out<=Do(67 downto 64);
	RA_out<=Do(63 downto 61);
	RC_out<=Do(60 downto 58);
	imm9_out<=Do(57 downto 49);
	Dout_out<=Do(48 downto 33);
	PC_2out<=Do(32 downto 17);
    ALUC_out<=Do(16 downto 1);
    RF_edit_out<=Do(0);
end architecture struct;