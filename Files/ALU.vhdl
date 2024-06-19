library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity ALU is
  port (ALU_A, ALU_B : in std_logic_vector(15 downto 0); S, CY: in std_logic; ALU_C: out std_logic_vector(15 downto 0); ALU_Z: out std_logic; ALU_CY: out std_logic);
end entity ALU;

architecture Struct of ALU is
  signal Temp, Cout: std_logic;
  signal Temp0, Temp1, Output: std_logic_vector(15 downto 0);
  
	component Full_Adder_Sub16bit  is
		port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); CY: in std_logic; S: out std_logic_vector(15 downto 0); A_CY: out std_logic);
	end component;
	
	component NAND_16bit  is
		port (A, B: in std_logic_vector(15 downto 0); Y: out std_logic_vector(15 downto 0));
	end component;
	
	component OR_16input  is
		port (A: in std_logic_vector(15 downto 0); Y: out std_logic);
	end component;
		
	component MUXM15_21  is
		port (inp0, inp1: in std_logic_vector(15 downto 0); cs: in std_logic; outp: out std_logic_vector(15 downto 0));
	end component MuxM15_21;

	
begin

	
	Add_sub: Full_Adder_Sub16bit port map (A => ALU_A, B => ALU_B, CY => CY, S => Temp0, A_CY => Cout);
	Nand_gate: NAND_16bit port map (A => ALU_A, B => ALU_B, Y => Temp1);
	
	MUX: MUXM15_21 port map (inp0 => Temp0, inp1 => Temp1, cs => S, outp => Output);
	
	OR_16ip: OR_16input port map (A => Output, Y => Temp);
	
	ALU_C <= Output;
	ALU_Z <= not Temp;
	ALU_CY <= Cout;
	end Struct;

	