library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Temp_File is
	port(Add: in std_logic_vector(2 downto 0); En,reset: in std_logic; clk: in  std_logic; Dout: out std_logic_vector(15 downto 0); R0,R1,R2,R3,R4,R5,R6,R7: in std_logic_vector(15 downto 0));
end entity Temp_File;

architecture struct of Temp_File is

component Register_16 is
	port(Clk, Reset, enable : in std_logic;
		D_in : in std_logic_vector(15 downto 0);
		D_out : out std_logic_vector(15 downto 0));
end component Register_16;

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

signal reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7, Do: std_logic_vector(15 downto 0):=(others=>'0');

begin

	regf0: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R0, D_out=>reg0);
	regf1: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R1, D_out=>reg1);
	regf2: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R2, D_out=>reg2);
	regf3: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R3, D_out=>reg3);
	regf4: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R4, D_out=>reg4);
	regf5: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R5, D_out=>reg5);
	regf6: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R6, D_out=>reg6);
	regf7: Register_16 port map(clk=>clk, reset=>reset, enable=>En, D_in=>R7, D_out=>reg7);
	mux: MUXM15_81 port map(reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7, cs=>Add, outp=>Do);

    Dout<=Do;
	
end architecture struct;