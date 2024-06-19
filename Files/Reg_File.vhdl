library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Reg_File is
	port(A1,A2,A3: in std_logic_vector(2 downto 0); rf_write, R0_En: in std_logic; D3, R0_Din: in std_logic_vector(15 downto 0); clk,reset: in  std_logic; D1,D2,R0_Dout, R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0));
end entity Reg_File;

architecture struct of Reg_File is

component Register_16 is
	port(Clk, Reset, enable : in std_logic;
		D_in : in std_logic_vector(15 downto 0);
		D_out : out std_logic_vector(15 downto 0));
end component Register_16;

component DEMUX_81 is
	port(I:in std_logic ;S: in std_logic_vector(2 downto 0); A: out std_logic_vector(7 downto 0));
end component DEMUX_81;

component MUXM15_81 is
	port(	inp0: in std_logic_vector(15 downto 0);
			inp1: in std_logic_vector(15 downto 0);
			inp2: in std_logic_vector(15 downto 0);
			inp3: in std_logic_vector(15 downto 0);
			inp4: in std_logic_vector(15 downto 0);
			inp5: in std_logic_vector(15 downto 0);
			inp6: in std_logic_vector(15 downto 0);
			inp7: in std_logic_vector(15 downto 0);
			cs: in std_logic_vector(2 downto 0); outp: out std_logic_vector(15 downto 0));
end component MUXM15_81;

signal reg00,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7: std_logic_vector(15 downto 0):=(others=>'0');
signal enable_f: std_logic_vector(7 downto 0):=(others=>'0');

begin

	regf0: Register_16 port map(clk=>clk, reset=>reset, enable=>R0_En, D_in=>R0_Din, D_out=>reg00);
	
	regf1: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(1), D_in=>D3, D_out=>reg1);
	regf2: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(2), D_in=>D3, D_out=>reg2);
	regf3: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(3), D_in=>D3, D_out=>reg3);
	regf4: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(4), D_in=>D3, D_out=>reg4);
	regf5: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(5), D_in=>D3, D_out=>reg5);
	regf6: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(6), D_in=>D3, D_out=>reg6);
	regf7: Register_16 port map(clk=>clk, reset=>reset, enable=>enable_f(7), D_in=>D3, D_out=>reg7);
	mux1: MUXM15_81 port map(reg00,reg1,reg2,reg3,reg4,reg5,reg6,reg7, cs=>A1, outp=>D1);
	mux2: MUXM15_81 port map(reg00,reg1,reg2,reg3,reg4,reg5,reg6,reg7, cs=>A2, outp=>D2);
	--mux3: MUXM15_81 port map(reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7, cs=>A_ext, outp=>D_ext);
	enabler: DEMUX_81 port map(I=>rf_write, S=>A3, A=>enable_f);
	
	R0_Dout<= reg00;
	R0<= reg00;
	R1<= reg1;
	R2<= reg2;
	R3<= reg3;
	R4<= reg4;
	R5<= reg5;
	R6<= reg6;
	R7<= reg7;
	
end architecture struct;