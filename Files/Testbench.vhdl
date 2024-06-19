library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end Testbench;

architecture ClockTB of Testbench is
	
	-- Component Instaiation of the Entity you want to verify using testbench
	component IITB_RISC is
			port(clk,reset: in std_logic);
	end component IITB_RISC;

	signal Clk_50, Reset : std_logic;
	--signal ALU_C,IR_out,Mem_out, M6_out: std_logic_vector(15 downto 0);
	--signal output: std_logic_vector(7 downto 0);
	--signal Selection: std_logic_vector(2 downto 0);
	--signal Address: std_logic_vector(7 downto 0);
	--signal Z_out: std_logic;
	
	begin
		-- Port Mapping of the component being instantiated
		main : IITB_RISC port map (clk => Clk_50, reset => Reset); --,  outp1 => ALU_C, outp3=> IR_out, outp4=> Mem_out, outp5 => M6_out, outp6 => Z_out);
		
		Reset <= '1', '0' after 50 us;
		
		L1: process  -- In Testbench Process statement does not have sensitivity list
					 -- the Statement written inside process block in testbench will run in a infinite loop
				begin
					Clk_50 <= '0';
					wait for 500 us; -- 100 us is used as Clk_50 freq = 50 MHz, so T = 200 us 
									 -- So T/2 Clk_50 will be OFF and for next T/2 Clk_50 will ON 
					Clk_50 <= '1';
					wait for 500 us;
			end process;
		
end ClockTB;