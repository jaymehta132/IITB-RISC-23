library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
use work.mat_pak.all;
use ieee.numeric_std.all;

entity Instr_Mem is
	port(Add: in std_logic_vector(15 downto 0); Clk, Mem_Read: in std_logic; Dout: out std_logic_vector(15 downto 0));
end entity Instr_Mem;

architecture struct of Instr_Mem is
signal mem_arr : matrix(0 to 255, 7 downto 0) := (others=>"00000000");
--(others=>(others=>'0'));

begin
	clock_proc:process(clk, Add, Mem_read, mem_arr)
	begin
	mem_arr <= mem_arr;
	if(Mem_read='1') then			
		mem_arr<=mem_arr;
		if(to_integer(unsigned(Add))<=254) then
			for i in 0 to 7 loop
				Dout(i)<=mem_arr(to_integer(unsigned(Add)),i);
				Dout(i+8)<=mem_arr(to_integer(unsigned(Add))+1,i);
			end loop;
		else
			Dout <= "0000000000000000";
		end if;
	else
		null;
	end if;
	end process;

end architecture struct;