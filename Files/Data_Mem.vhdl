library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
use work.mat_pak.all;
use ieee.numeric_std.all;

entity Data_Mem is
	port(Din,Add: in std_logic_vector(15 downto 0); Readb_Write,clk,reset: in std_logic; Dout: out std_logic_vector(15 downto 0));
end entity Data_Mem;

architecture struct of Data_Mem is
signal mem_arr : matrix(0 to 255, 7 downto 0) := (others=>(others=>'0'));

begin
	clock_proc:process(clk,reset,Add,Din,Readb_Write, mem_arr)
	begin
			if(reset='1') then
				mem_arr <= (others=>(others=>'0'));
				Dout<="0000000000000000";
				
			elsif(Readb_Write='0') then
				mem_arr<=mem_arr;
				if(to_integer(unsigned(Add))<=254) then
					for i in 0 to 7 loop
						Dout(i)<=mem_arr(to_integer(unsigned(Add)),i); 
						Dout(i+8)<=mem_arr(to_integer(unsigned(Add))+1,i);
					end loop;
				else
					Dout <= "0000000000000000";
				end if;
		
			elsif(clk='0' and clk'event) then
				if(Readb_Write='1') then
					if(to_integer(unsigned(Add))<=254) then
						if( Readb_Write='1') then
							for i in 0 to 7 loop
								mem_arr(to_integer(unsigned(Add)),i)<=Din(i);
								mem_arr(to_integer(unsigned(Add))+1,i)<=Din(i+8);
							end loop;
							Dout<="0000000000000000";
						
						else
							Dout<="0000000000000000";
						end if;
					else
						NULL;
					end if;
				end if;
			end if;
	end process;

end architecture struct;