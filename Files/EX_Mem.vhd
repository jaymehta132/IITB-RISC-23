library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity EX_Mem is
	port(Clk, valid_in,enable : in std_logic;
		counter_in: in std_logic_vector(2 downto 0);
		LSMen_in: in std_logic;	
		opcode_in : in std_logic_vector(3 downto 0);
		RA_in : in std_logic_vector(2 downto 0);
		RB_in : in std_logic_vector(2 downto 0);
		RC_in : in std_logic_vector(2 downto 0);
        RA_Cin : in std_logic_vector(15 downto 0);
		RB_Cin : in std_logic_vector(15 downto 0);
		imm9_in : in std_logic_vector(8 downto 0);
		PC_in: in std_logic_vector(15 downto 0);
		PC_2in: in std_logic_vector(15 downto 0);
        ALUC_in: in std_logic_vector(15 downto 0);
		RF_edit_in: in std_logic;
		SMC_in: in std_logic_vector(15 downto 0);

		opcode_out : out std_logic_vector(3 downto 0);
		RA_out : out std_logic_vector(2 downto 0);
		RB_out : out std_logic_vector(2 downto 0);
		RC_out : out std_logic_vector(2 downto 0);
        RA_Cout : out std_logic_vector(15 downto 0);
		RB_Cout : out std_logic_vector(15 downto 0);
		imm9_out : out std_logic_vector(8 downto 0);
		PC_out: out std_logic_vector(15 downto 0);
		PC_2out: out std_logic_vector(15 downto 0);
        ALUC_out: out std_logic_vector(15 downto 0);
		RF_edit_out: out std_logic;
		valid_out: out std_logic;
		LSMen_out: out std_logic;
		counter_out: out std_logic_vector(2 downto 0);
		SMC_out: out std_logic_vector(15 downto 0));
end entity;

architecture struct of EX_Mem is
	signal D: std_logic_vector(123 downto 0);
	signal Do: std_logic_vector(123 downto 0);
	signal Dob: std_logic_vector(123 downto 0);
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=RB_in & SMC_in & counter_in & LSMen_in & valid_in & opcode_in & RA_in & RC_in & RA_Cin & RB_Cin & imm9_in & PC_in & PC_2in & ALUC_in & RF_edit_in;
	generation:  for i in 0 to 123 generate
		en_gen: if(i=100) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>'1', reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate en_gen;

		norm_gen: if(i/=100) generate
			dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>'0', preset=>'0', Q=>Do(i), Qb=>Dob(i));
		end generate norm_gen;
	end generate;
	RB_out<=Do(123 downto 121);
	SMC_out<=Do(120 downto 105);
	counter_out<=Do(104 downto 102);
	LSMen_out<=Do(101);
	valid_out<=Do(100);
	opcode_out<=Do(99 downto 96);
	RA_out<=Do(95 downto 93);
	RC_out<=Do(92 downto 90);
    RA_Cout<=Do(89 downto 74);
	RB_Cout<=Do(73 downto 58);
	imm9_out<=Do(57 downto 49);
	PC_out<=Do(48 downto 33);
	PC_2out<=Do(32 downto 17);
    ALUC_out<=Do(16 downto 1);
    RF_edit_out<=Do(0);
end architecture struct;