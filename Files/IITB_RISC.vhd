library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
use work.mat_pak.all;
use ieee.numeric_std.all;

entity IITB_RISC is
	port(clk,reset: in std_logic);
end entity IITB_RISC;

architecture struct of IITB_RISC is
--Forwarding Unit
	component Forwarding_Unit is
		port(	Opcode_ID_RR, Opcode_RR_EX, Opcode_EX_MEM, Opcode_MEM_WB: in std_logic_vector(3 downto 0); 
				RA_ID_RR, RA_RR_EX, RA_EX_MEM, RA_MEM_WB: in std_logic_vector(2 downto 0);
				RB_ID_RR, RB_RR_EX, RB_EX_MEM, RB_MEM_WB: in std_logic_vector(2 downto 0);
				RC_ID_RR, RC_RR_EX, RC_EX_MEM, RC_MEM_WB: in std_logic_vector(2 downto 0);
				RF_edit_EX, RF_edit_EX_MEM, RF_edit_MEM_WB, E_EX, L_EX: in std_logic;
				Condition_ID_RR, Condition_RR_EX: in std_logic_vector(1 downto 0);
				Valid_ID_RR, Valid_RR_EX, Valid_EX_MEM, Valid_MEM_WB: in std_logic;
				LSMEn_EX_MEM, LSMEn_MEM_WB: in std_logic;
				counter_EXmem, counter_memWB: in std_logic_vector(2 downto 0);
				--: in std_logic_vector(15 downto 0);
				
				S, S_prime: out std_logic_vector(16 downto 1));
	end component Forwarding_Unit;

--Deciding Unit
	component Deciding_Unit is
		port(	ALU_C_EX, ALU_C_EX_MEM, MEM_out_MEM, ALU_C_MEM_WB, MEM_out_MEM_WB: in std_logic_vector(15 downto 0); -- for RA RB
				Imm9_RR_EX, Imm9_EX_MEM, Imm9_MEM_WB: in std_logic_vector(8 downto 0);
				RB_C_RR_EX: in std_logic_vector(15 downto 0);
				S, S_prime: in std_logic_vector(16 downto 1);
				
				Forward_to_RA_RR, Forward_to_RB_RR, Forward_to_PC_IF: out std_logic_vector(15 downto 0);
				Forward_signal_RA_RR, Forward_signal_RB_RR, Forward_signal_PC_IF: out std_logic);
	end component Deciding_Unit;

--pipeline registers
	component IF_ID is
		port(Clk, valid_in, enable : in std_logic;	
			Instr_in : in std_logic_vector(15 downto 0);
			PC_2in : in std_logic_vector(15 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			Instr_out : out std_logic_vector(15 downto 0);
			PC_2out : out std_logic_vector(15 downto 0);
			PC_out: out std_logic_vector(15 downto 0);
			valid_out: out std_logic);
	end component IF_ID;

	component ID_RR is
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
	end component ID_RR;

	component RR_EX is
		port(Clk, valid_in,enable,enable_RA : in std_logic;	
			opcode_in : in std_logic_vector(3 downto 0);
			RA_in : in std_logic_vector(2 downto 0);
			RC_in : in std_logic_vector(2 downto 0);
			RA_Cin : in std_logic_vector(15 downto 0);
			RB_Cin : in std_logic_vector(15 downto 0);
			comp_in : in std_logic;
			cond_in: in std_logic_vector(1 downto 0);
			imm6_in : in std_logic_vector(5 downto 0);
			imm9_in : in std_logic_vector(8 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			PC_2in: in std_logic_vector(15 downto 0);

			RB_in: in std_logic_vector(2 downto 0);
			RB_out: out std_logic_vector(2 downto 0);
			
			opcode_out : out std_logic_vector(3 downto 0);
			RA_out : out std_logic_vector(2 downto 0);
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
	end component RR_EX;

	component EX_Mem is
		port(Clk, valid_in,enable : in std_logic;
			counter_in: in std_logic_vector(2 downto 0);
			LSMen_in: in std_logic;	
			opcode_in : in std_logic_vector(3 downto 0);
			RA_in : in std_logic_vector(2 downto 0);
			RC_in : in std_logic_vector(2 downto 0);
			RA_Cin : in std_logic_vector(15 downto 0);
			RB_Cin : in std_logic_vector(15 downto 0);
			imm9_in : in std_logic_vector(8 downto 0);
			PC_in: in std_logic_vector(15 downto 0);
			PC_2in: in std_logic_vector(15 downto 0);
			ALUC_in: in std_logic_vector(15 downto 0);
			RF_edit_in: in std_logic;
			SMC_in: in std_logic_vector(15 downto 0);

			RB_in: in std_logic_vector(2 downto 0);
			RB_out: out std_logic_vector(2 downto 0);

			opcode_out : out std_logic_vector(3 downto 0);
			RA_out : out std_logic_vector(2 downto 0);
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
	end component EX_Mem;

	component Mem_WB is
		port(Clk, valid_in,enable : in std_logic;	
			counter_in: in std_logic_vector(2 downto 0);
			LSMen_in: in std_logic;	
			opcode_in : in std_logic_vector(3 downto 0);
			RA_in : in std_logic_vector(2 downto 0);
			RC_in : in std_logic_vector(2 downto 0);
			imm9_in : in std_logic_vector(8 downto 0);
			PC_2in: in std_logic_vector(15 downto 0);
			ALUC_in: in std_logic_vector(15 downto 0);
			RF_edit_in: in std_logic;
			Dout_in: in std_logic_vector(15 downto 0);

			RB_in: in std_logic_vector(2 downto 0);
			RB_out: out std_logic_vector(2 downto 0);

			opcode_out : out std_logic_vector(3 downto 0);
			RA_out : out std_logic_vector(2 downto 0);
			RC_out : out std_logic_vector(2 downto 0);
			imm9_out : out std_logic_vector(8 downto 0);
			PC_2out: out std_logic_vector(15 downto 0);
			ALUC_out: out std_logic_vector(15 downto 0);
			RF_edit_out: out std_logic;
			Dout_out: out std_logic_vector(15 downto 0);
			valid_out: out std_logic;
			LSMen_out: out std_logic;
			counter_out: out std_logic_vector(2 downto 0));
	end component Mem_WB;

--ALU
	component ALU is
		port (ALU_A, ALU_B : in std_logic_vector(15 downto 0); S, CY: in std_logic; ALU_C: out std_logic_vector(15 downto 0); ALU_Z: out std_logic; ALU_CY: out std_logic);
	end component ALU;

--Adder
	component Adder_plus2  is
		port (A: in std_logic_vector(15 downto 0); S: out std_logic_vector(15 downto 0));
	end component Adder_plus2;

--Register Files
	component Reg_File is
		port(A1,A2,A3: in std_logic_vector(2 downto 0); rf_write, R0_En: in std_logic; D3, R0_Din: in std_logic_vector(15 downto 0); clk,reset: in  std_logic; D1,D2,R0_Dout, R0, R1, R2, R3, R4, R5, R6, R7: out std_logic_vector(15 downto 0));
	end component Reg_File;

	component Temp_File is
		port(Add: in std_logic_vector(2 downto 0); En,reset: in std_logic; clk: in  std_logic; Dout: out std_logic_vector(15 downto 0); R0,R1,R2,R3,R4,R5,R6,R7: in std_logic_vector(15 downto 0));
	end component Temp_File;

--Memory
	component Instr_Mem is
		port(Add: in std_logic_vector(15 downto 0); Clk, Mem_Read: in std_logic; Dout: out std_logic_vector(15 downto 0));
	end component Instr_Mem;

	component Data_Mem is
		port(Din,Add: in std_logic_vector(15 downto 0); Readb_Write,clk,reset: in std_logic; Dout: out std_logic_vector(15 downto 0));
	end component Data_Mem;

--Muxes
	component MUXM15_21  is
		port (inp0, inp1: in std_logic_vector(15 downto 0); cs: in std_logic; outp: out std_logic_vector(15 downto 0));
	end component MuxM15_21;

	component MUXM15_41  is
		port (inp0, inp1, inp2, inp3: in std_logic_vector(15 downto 0); cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(15 downto 0));
	end component MuxM15_41;

	component Mux_2x1  is
		port (I0, I1, S: in std_logic; Y: out std_logic);
	end component Mux_2x1;

	component MUXM3_21  is
		port (inp0, inp1: in std_logic_vector(2 downto 0); cs: in std_logic; outp: out std_logic_vector(2 downto 0));
	end component MUXM3_21;

	component Mux_8x1  is
		port (I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2: in std_logic; Y: out std_logic);
	end component Mux_8x1;

	component MUXM3_41  is
		port (inp0, inp1, inp2, inp3: in std_logic_vector(2 downto 0); cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(2 downto 0));
	end component MuxM3_41;

--Sign Extenders
	component SE6 is
		port(inp: in std_logic_vector(5 downto 0); outp: out std_logic_vector(15 downto 0));
	end component SE6;

	component SE9 is
		port(inp: in std_logic_vector(8 downto 0); outp: out std_logic_vector(15 downto 0));
	end component SE9;

--Gates
	component XOR_16_1  is
		port (A: in std_logic; B: in std_logic_vector(15 downto 0); Y: out std_logic_vector(15 downto 0));
 	end component XOR_16_1;

--Shifter
	component LS is
		port(A: in std_logic_vector(15 downto 0); B: out std_logic_vector(15 downto 0) );
	end component LS;

--DFF
	component D_FLipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
				Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;

--Comparator
	component Comparator is
		port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); E, L: out std_logic);
  	end component Comparator;

--Counter
	component counter is 
		port(enable,clk,reset: in std_logic; count: out std_logic_vector(2 downto 0); end_bit: out std_logic);
	end component counter;

--Hazard Unit
	component HazardMitigation is
    -- Entity ports declaration
    -- Add your input and output ports here
		port(
			Opcode_ID_RR, Opcode_RR_EX, Opcode_EX_MEM, Opcode_MEM_WB: in std_logic_vector(3 downto 0);
			Counter_count : in std_logic_vector(2 downto 0);
			Valid_ID_RR, Valid_RR_EX, Valid_EX_MEM, Valid_MEM_WB, LSMEn_EX_MEM, Count_end_bit: in std_logic;
			S, S_prime : in std_logic_vector(16 downto 1); -- Needed for branching
			
			-- Outputs
			R0_En, IF_ID_En, ID_RR_En, RR_EX_En, EX_MEM_En, MEM_WB_En, Z_En, Cy_En, RA_C_En, TempRF_En : out std_logic; -- Enable signals for Pipeline Registers, Flags and R0   

			Valid_ID_RR_Out, Valid_RR_EX_Out, Valid_EX_MEM_Out, Valid_IF_ID_Out, Valid_MEM_WB_Out  : out std_logic -- Valid Bits for Pipeline Registers
		);

	end component HazardMitigation;

-- control signals	
	--IF
	signal mux1_IF_cont: std_logic:='0';
	signal instr_mem_IF_read: std_logic:='1'; --to assign 	--update: Read at sugnal = '1' hence permanently '1'
	signal enable_IFID: std_logic:='1'; --to assign 		--update: Assigned in Hazard Unit
	signal validate_IFID: std_logic:='0';
	signal R0_En: std_logic:='0'; --to assign				--update: Assigned in Hazard Unit

	--ID
	signal enable_IDRR: std_logic:='1'; --to assign			--update: Assigned in Hazard Unit
	signal validate_IDRR: std_logic:='0';

	--RR
	signal rf_write: std_logic:='0'; 
	signal mux1_RR_cont: std_logic:='0';
	signal mux2_RR_cont: std_logic:='0';
	signal mux3_RR_cont: std_logic:='0';
	signal enable_RREX: std_logic:='1'; --to assign			--update: Assigned in Hazard Unit
	signal validate_RREX: std_logic:='0';
	signal enable_RA_RREX: std_logic:='0'; --to assign		--update: Assigned in EX stage
	signal mux4_RRf_cs : std_logic:='0';
	signal mux5_RRf_cs : std_logic:='0';


	--EX
	signal mux1_EX_cont: std_logic:='0';
	signal mux2_EX_cont: std_logic_vector(1 downto 0):=(others=>'0');
	signal mux3_EX_cont: std_logic_vector(1 downto 0):=(others=>'0');
	signal mux4_EX_cont: std_logic_vector(1 downto 0):=(others=>'0');
	signal mux5_EX_cont: std_logic:='0';
	signal ALU_sel_EX: std_logic:='0'; --to assign			--update: updated in EX stage
	signal Z_en_EX: std_logic:='0'; --to assign				--update: updated in EX stage
	signal Cy_en_EX: std_logic:='0'; --to assign			--update: updated in EX stage
	signal enable_EXmem: std_logic:='1'; --to assign		--update: Assigned in Hazard Unit
	signal validate_EXmem: std_logic:='0';
		--for LM/SM
	signal temp_rf_enable: std_logic:='1'; --to assign		--update: Assigned in Hazard Unit
	signal counter_enable: std_logic:='0'; --to assign		--update: Assigned in EX stage
	signal counter_reset: std_logic:='0'; --to assign		--update: Assigned in RR stage
	signal RA_C_EN_HAZARD: std_logic:='0';
	signal counter_reg_ex_lm_reset : std_logic:='0';


	--Mem
	signal mux1_mem_cont: std_logic:='0'; 
	signal mem_RW_mem: std_logic:='0'; --to assign			--update: Assigned in Memory stage
	signal enable_memWB: std_logic:='1'; --to assign		--update: Assigned in Hazard Unit
	signal validate_memWB: std_logic:='0';


	--WB
	signal mux1_WB_cont: std_logic_vector(1 downto 0):=(others=>'0');
	signal mux2_WB_cont: std_logic_vector(1 downto 0):=(others=>'0');
	signal mux3_WB_cont: std_logic:='0';

	--signals from hazard unit(will be anded with validate signals to give valid bit signals to pipeline registers)
	signal hazard_validate_EXmem: std_logic:='0'; --to assign		--update: Assigned in Hazard Unit
	signal hazard_validate_memWB: std_logic:='0'; --to assign		--update: Assigned in Hazard Unit
	signal hazard_validate_IFID: std_logic:='0'; --to assign		--update: Assigned in Hazard Unit
	signal hazard_validate_IDRR: std_logic:='0'; --to assign		--update: Assigned in Hazard Unit
	signal hazard_validate_RREX: std_logic:='0'; --to assign		--update: Assigned in Hazard Unit
	signal hazard_Cy_En: std_logic:= '0';
	signal hazard_Z_En: std_logic:= '0';



-- datapath signals

	--Forwarding
	signal f1_IF: std_logic_vector(15 downto 0):=(others=>'0');
	signal f1_RR: std_logic_vector(15 downto 0):=(others=>'0');
	signal f2_RR: std_logic_vector(15 downto 0):=(others=>'0');
	signal f3_RR: std_logic_vector(15 downto 0):=(others=>'0');
	signal S,S_prime: std_logic_vector(16 downto 1):=(others=>'0');

	--IF 
	signal Adder_IF_out, mux1_IF_out, R0_out, Instr_Mem_IF_out: std_logic_vector(15 downto 0):=(others=>'0');

	--ID
	signal Instr_IFID, PC_2_IFID, PC_IFID: std_logic_vector(15 downto 0):=(others=>'0');
	signal valid_IFID:std_logic:='0';	

	--RR
	signal PC_2_IDRR, PC_IDRR: std_logic_vector(15 downto 0):=(others=>'0');
	signal RA_IDRR, RB_IDRR, RC_IDRR: std_logic_vector(2 downto 0):=(others=>'0');
	signal imm6_IDRR: std_logic_vector(5 downto 0):=(others=>'0');
	signal imm9_IDRR: std_logic_vector(8 downto 0):=(others=>'0');
	signal opcode_IDRR: std_logic_vector(3 downto 0):=(others=>'0');
	signal comp_IDRR: std_logic:='0';
	signal cond_IDRR: std_logic_vector(1 downto 0):=(others=>'0');
	signal valid_IDRR:std_logic:='0';	

	signal RF_D1_RR, RF_D2_RR: std_logic_vector(15 downto 0):=(others=>'0');
	signal mux1_RR_out, mux2_RR_out, mux3_RR_out, mux4_RRf_out, mux5_RRf_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal R0,R1,R2,R3,R4,R5,R6,R7: std_logic_vector(15 downto 0):=(others=>'0');

	--EX
	signal XOR_EX_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal mux1_EX_out: std_logic_vector(15 downto 0):=(others=>'0'); --PC/RA
	signal mux2_EX_out: std_logic_vector(15 downto 0):=(others=>'0'); --Imm6/imm9/..
	signal mux3_EX_out: std_logic_vector(15 downto 0):=(others=>'0'); --Imm6/RB..
	signal mux4_EX_out: std_logic_vector(15 downto 0):=(others=>'0'); --RA/PC/Imm6/
	signal mux5_EX_out: std_logic:= '0'; --Cin
	signal se6_EX_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal se9_EX_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal ls_EX_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal Comp_EX_E, Comp_EX_L: std_logic := '0';
	signal ALU_Z_EX, ALU_Cy_EX: std_logic:= '0';
	signal ALU_Zf_EX, ALU_Cyf_EX: std_logic:= '0'; --from dff
	signal RF_edit_EX: std_logic := '0';
	signal ALU_C_EX: std_logic_vector(15 downto 0):=(others=>'0');
	
	signal RA_RREX, RB_RREX, RC_RREX: std_logic_vector(2 downto 0):=(others=>'0');
	signal RA_C_RREX, RB_C_RREX: std_logic_vector(15 downto 0):=(others=>'0');
	signal opcode_RREX: std_logic_vector(3 downto 0):=(others=>'0');
	signal comp_RREX: std_logic:='0';
	signal cond_RREX: std_logic_vector(1 downto 0):=(others=>'0');
	signal imm6_RREX: std_logic_vector(5 downto 0):=(others=>'0');
	signal imm9_RREX: std_logic_vector(8 downto 0):=(others=>'0');
	signal PC_2_RREX, PC_RREX: std_logic_vector(15 downto 0):=(others=>'0');
	signal valid_RREX: std_logic:='0';

		--LM/SM
	signal adder_EX_LM_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal counter_end_bit:std_logic:='0';
	signal counter_count: std_logic_vector(2 downto 0):=(others=>'0');
	signal mux_LM_count_out: std_logic:='0';
	signal temp_reg_file_out: std_logic_vector(15 downto 0):=(others=>'0');

	--Mem
	signal mux1_mem_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal mem_mem_dout: std_logic_vector(15 downto 0):=(others=>'0');
	
	signal RA_EXmem, RC_EXmem, RB_EXmem: std_logic_vector(2 downto 0):=(others=>'0');
	signal RA_C_EXmem, RB_C_EXmem, ALU_C_EXmem: std_logic_vector(15 downto 0):=(others=>'0');
	signal opcode_EXmem: std_logic_vector(3 downto 0):=(others=>'0');
	signal RF_edit_EXmem: std_logic:='0';
	signal imm9_EXmem: std_logic_vector(8 downto 0):=(others=>'0');
	signal PC_2_EXmem, PC_EXmem: std_logic_vector(15 downto 0):=(others=>'0');
	signal valid_EXmem: std_logic:='0';
	signal counter_EXmem: std_logic_vector(2 downto 0):=(others=>'0');
	signal LSMen_EXmem: std_logic:='0';
	signal SMC_Exmem: std_logic_vector(15 downto 0):=(others=>'0');


	--WB
	signal mux1_WB_out: std_logic_vector(2 downto 0):=(others=>'0'); --RA/RC
	signal mux2_WB_out: std_logic_vector(15 downto 0):=(others=>'0');
	signal mux3_WB_out: std_logic:='0';
	signal se9_WB_out: std_logic_vector(15 downto 0):=(others=>'0');

	signal Dout_memWB: std_logic_vector(15 downto 0):=(others=>'0');
	signal RC_memWB,RB_memWB: std_logic_vector(2 downto 0):=(others=>'0');
	signal ALUC_C_memWB: std_logic_vector(15 downto 0):=(others=>'0');
	signal PC_2_memWB: std_logic_vector(15 downto 0):=(others=>'0');
	signal RA_memWB: std_logic_vector(2 downto 0):=(others=>'0');
	signal opcode_memWB: std_logic_vector(3 downto 0):=(others=>'0');
	signal RF_edit_memWB:std_logic:='0';
	signal imm9_memWB: std_logic_vector(8 downto 0):=(others=>'0');
	signal valid_memWB: std_logic:='0';
	signal counter_memWB: std_logic_vector(2 downto 0):=(others=>'0');
	signal LSMen_memWB: std_logic:='0';

	begin

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Instruction Fetch


		register_file: Reg_file port map(A1=>RA_IDRR, A2=>RB_IDRR, A3=>mux1_WB_out, D3=>mux2_WB_out, D1=>RF_D1_RR, D2=>RF_D2_RR, R0_En=>R0_En, 

										rf_write=>rf_write, R0_Din=>Adder_IF_out, R0_Dout=> R0_out, clk=>clk, reset=>reset, 

										R0=>R0, R1=>R1, R2=>R2, R3=>R3, R4=>R4, R5=>R5, R6=>R6, R7=>R7);

		Instruction_memory: Instr_mem port map(Add=>mux1_IF_out, Clk=>clk, Mem_Read=>instr_mem_IF_read, Dout=>Instr_Mem_IF_out);

		adder_IF: Adder_plus2 port map(A=>mux1_IF_out, S=>Adder_IF_out);

		mux1_IF: MUXM15_21 port map(inp0=>R0_out, inp1=>f1_IF, cs=>mux1_IF_cont, outp=>mux1_IF_out); --control and input from forwarding unit

		IF_ID_reg: IF_ID port map(clk=>clk, enable=>enable_IFID, valid_in=>validate_IFID , valid_out=>valid_IFID, instr_in=> Instr_Mem_IF_out, PC_2in=> Adder_IF_out, PC_in=> mux1_IF_out, Instr_out=>Instr_IFID, PC_2out=>PC_2_IFID, PC_out=>PC_IFID);
    
		validate_IFID<='1';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Instruction Decode


		ID_RR_reg: ID_RR port map(clk=>clk, enable=>enable_IDRR, valid_out=>valid_IDRR, valid_in=>validate_IDRR, opcode_in=>Instr_Mem_IF_out(15 downto 12), RA_in=>Instr_Mem_IF_out(11 downto 9), RB_in=>Instr_Mem_IF_out(8 downto 6), 

								RC_in=>Instr_Mem_IF_out(5 downto 3), comp_in=>Instr_Mem_IF_out(2), cond_in=>Instr_Mem_IF_out(1 downto 0), imm6_in=>Instr_Mem_IF_out(5 downto 0), 
								
								imm9_in=>Instr_Mem_IF_out(8 downto 0), PC_in=>PC_IFID, PC_2in=>PC_2_IFID, opcode_out=>opcode_IDRR, RA_out=>RA_IDRR, RB_out=>RB_IDRR, RC_out=>RC_IDRR, 
								
								comp_out=>comp_IDRR, cond_out=>cond_IDRR, imm6_out=>imm6_IDRR, imm9_out=>imm9_IDRR, PC_out=>PC_IDRR, PC_2out=>PC_2_IDRR);

		validate_IDRR<=valid_IFID and hazard_validate_IDRR;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Register Read


		mux1_RR: MUXM15_21 port map(inp0=>mux4_RRf_out, inp1=>f1_RR, cs=>mux1_RR_cont, outp=>mux1_RR_out); --i and c from fu

		mux2_RR: MUXM15_21 port map(inp0=>mux5_RRf_out, inp1=>f2_RR, cs=>mux2_RR_cont, outp=>mux2_RR_out); --i and c from fu

		mux3_RR: MUXM15_21 port map(inp1=>f3_RR, inp0=>mux1_RR_out, cs=>mux3_RR_cont, outp=>mux3_RR_out);

		RR_EX_reg: RR_EX port map(clk=>clk, enable_RA=>enable_RA_RREX, valid_in=>validate_RREX, enable=>enable_RREX, valid_out=>valid_RREX, opcode_out=>opcode_RREX, RA_out=>RA_RREX, RC_out=>RC_RREX, RA_Cout=>RA_C_RREX, RB_Cout=>RB_C_RREX, 

								  comp_out=>comp_RREX, cond_out=>cond_RREX, imm6_out=>imm6_RREX, imm9_out=>imm9_RREX, PC_out=>PC_RREX, PC_2out=>PC_2_RREX, RB_out=>RB_RREX,

								  opcode_in=>opcode_IDRR, RA_in=>RA_IDRR, RC_in=>RC_IDRR, RB_in=>RB_IDRR, RA_Cin=>mux3_RR_out, RB_Cin=>mux2_RR_out, 

								  comp_in=>comp_IDRR, cond_in=>cond_IDRR, imm6_in=>imm6_IDRR, imm9_in=>imm9_IDRR, PC_in=>PC_IDRR, PC_2in=>PC_2_IDRR);

		mux3_RR_cont<= (not opcode_RREX(3)) and opcode_RREX(2) and opcode_RREX(1);

		mux4_RRf: MUXM15_21 port map(inp0=>PC_IDRR, inp1=>RF_D1_RR, cs=>mux4_RRf_cs, outp=>mux4_RRf_out);

		mux5_RRf: MUXM15_21 port map(inp0=>PC_IDRR, inp1=>RF_D2_RR, cs=>mux5_RRf_cs, outp=>mux5_RRf_out);

		validate_RREX<=valid_IDRR and hazard_validate_RREX;

		counter_reset <= ((not Opcode_IDRR(3)) and (Opcode_IDRR(2)) and Opcode_IDRR(1)) and valid_IDRR;

		mux4_RRf_cs <= RA_IDRR(0) or RA_IDRR(1) or RA_IDRR(2);

		mux5_RRf_cs <= RB_IDRR(0) or RB_IDRR(1) or RB_IDRR(2);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Execute


		XOR1_EX: XOR_16_1 port map(B=>RB_C_RREX,A=>comp_IDRR,Y=>XOR_EX_out);

		mux1_EX: MUXM15_21 port map(inp0=>PC_RREX, inp1=>RA_C_RREX, cs=>mux1_EX_cont, outp=>mux1_EX_out);

		mux2_EX: MUXM15_41 port map(inp1=>XOR_EX_out, inp0=>se6_EX_out, inp2=>XOR_EX_out, inp3=>se9_EX_out, cs=>mux2_EX_cont, outp=>mux2_EX_out);

		mux3_EX: MUXM15_41 port map(inp0=>mux2_EX_out, inp1=>RB_C_RREX, inp2=>ls_EX_out, inp3=>mux1_EX_out, cs=>mux3_EX_cont, outp=>mux3_EX_out);

		mux4_EX: MUXM15_41 port map(inp0=>RA_C_RREX, inp1=>se6_EX_out, inp2=>PC_RREX, inp3=>se9_EX_out, cs=>mux4_EX_cont, outp=>mux4_EX_out);

		mux5_EX: MUX_2x1 port map(I0=>'0', I1=>ALU_Cyf_EX, S=>mux5_EX_cont, y=>mux5_EX_out);

		ALU_risc: ALU port map(ALU_A=>mux4_EX_out, ALU_B=>mux3_EX_out , ALU_C=>ALU_C_EX ,S=>ALU_sel_EX ,CY=>mux5_EX_out ,ALU_Z=>ALU_Z_EX ,ALU_CY=> ALU_Cy_EX);

		zero_flag: D_FlipFLop port map(D=>ALU_Z_EX, clk=>clk, enable=>Z_en_EX, reset=>reset, preset=>'0', Q=>ALU_Zf_EX);

		carry_flag: D_FlipFLop port map(D=>ALU_Cy_EX, clk=>clk, enable=>Cy_en_EX, reset=>reset, preset=>'0', Q=>ALU_Cyf_EX);

		comp1: Comparator port map(A=>RA_C_RREX, B=>RB_C_RREX, E=>Comp_EX_E, L=>Comp_EX_L);

		SE6_EX: SE6 port map(inp=>imm6_RREX, outp=>se6_EX_out);

		SE9_EX: SE9 port map(inp=>imm9_RREX, outp=>se9_EX_out);

		lS_EX: LS port map(A=>se6_EX_out, B=>ls_EX_out);

		EX_Mem_reg: EX_Mem port map(clk=>clk, enable=>enable_Exmem, valid_in=> validate_EXmem, valid_out=>valid_EXmem, opcode_in=>opcode_IDRR, RA_in=>RA_RREX, RC_in=>RC_RREX, RA_Cin=>RA_C_RREX, RB_in=>RB_RREX,

									counter_in=>counter_count,counter_out=>counter_EXmem, SMC_in=>temp_reg_file_out, SMC_out=>SMC_Exmem ,RB_Cin=>RB_C_RREX, imm9_in=>imm9_RREX, PC_in=>PC_RREX, PC_2in=>PC_2_RREX, ALUC_in=>ALU_C_EX, RF_edit_in=>RF_edit_EX, 

									LSMen_in=>mux_LM_count_out, LSMen_out=>LSMen_Exmem, opcode_out=>opcode_EXmem, RA_out=>RA_EXmem, RB_out=>RB_EXmem, RC_out=>RC_EXmem, RA_Cout=>RA_C_EXmem, RB_Cout=>RB_C_EXmem, imm9_out=>imm9_EXmem,
									
									PC_out=>PC_EXmem, PC_2out=>PC_2_EXmem, ALUC_out=>ALU_C_EXmem, RF_edit_out=>RF_edit_EXmem);

		
		ALU_sel_EX <= (not Opcode_RREX(3)) and (not Opcode_RREX(2)) and (Opcode_RREX(1)) and (not Opcode_RREX(0));

		Z_en_EX <= hazard_Z_En and ((not Opcode_RREX(3)) and (not Opcode_RREX(2)) and ((not Opcode_RREX(1)) or (not Opcode_RREX(0))) and rf_edit_EX);

		Cy_en_EX <= hazard_Z_En and (((not Opcode_RREX(3)) and (not Opcode_RREX(2)) and (not Opcode_RREX(1))) and rf_edit_EX);
		
		mux1_EX_cont<=opcode_RREX(0);

		mux2_EX_cont<=opcode_RREX(1) & opcode_RREX(0);

		mux3_EX_cont<=opcode_RREX(3) & opcode_RREX(2);

		mux4_EX_cont<=opcode_RREX(3) & opcode_RREX(2);

		mux5_EX_cont<=(not opcode_RREX(3)) and (not opcode_RREX(2)) and (not opcode_RREX(1)) and opcode_RREX(0) and cond_RREX(1) and cond_RREX(0);

		rf_edit_EX<=((((cond_RREX(0) and not cond_RREX(1) and ALU_Zf_EX) or (cond_RREX(1) and not cond_RREX(0) and ALU_Cyf_EX) or (cond_RREX(0) and cond_RREX(1)) or (not cond_RREX(0) and not cond_RREX(1)))
					and
					((not opcode_RREX(3) and not opcode_RREX(2) and not opcode_RREX(1) and opcode_RREX(0)) or (not opcode_RREX(3) and not opcode_RREX(2) and opcode_RREX(1) and not opcode_RREX(0))))
					or
					(not opcode_RREX(3) and not opcode_RREX(2) and not opcode_RREX(1) and not opcode_RREX(0)) --ADI
					or
					(not opcode_RREX(3) and not opcode_RREX(2) and opcode_RREX(1) and opcode_RREX(0)) --LLI
					or
					(not opcode_RREX(3) and opcode_RREX(2) and not opcode_RREX(1) and not opcode_RREX(0)) --LW
					or
					(not opcode_RREX(3) and opcode_RREX(2) and opcode_RREX(1) and not opcode_RREX(0)) --LM
					or
					(opcode_RREX(3) and opcode_RREX(2) and not opcode_RREX(1) and not opcode_RREX(0)) --JAL
					or
					(opcode_RREX(3) and opcode_RREX(2) and not opcode_RREX(1) and opcode_RREX(0))) and valid_RREX; --JLR
					

		--LM/SM

		adder_EX_LM: Adder_plus2 port map(A=>RA_C_RREX, S=>adder_EX_LM_out);

		f3_RR<=adder_EX_LM_out;

		counter_reg_EX_LM: counter port map(enable=>counter_enable, reset=>counter_reg_EX_LM_reset, clk=>clk, count=>counter_count, end_bit=>counter_end_bit);

		mux_LM_count: Mux_8x1 port map(I0=>imm9_IDRR(7), I1=>imm9_IDRR(6), I2=>imm9_IDRR(5), I3=>imm9_IDRR(4), I4=>imm9_IDRR(3), I5=>imm9_IDRR(2), I6=>imm9_IDRR(1), I7=>imm9_IDRR(0), 

									   S0=>counter_count(0), S1=>counter_count(1),S2=>counter_count(2), Y=>mux_LM_count_out);

		temp_rf: Temp_File port map(Add=>counter_count, En=>temp_rf_enable, reset=>reset, clk=>clk, Dout=>temp_reg_file_out, R0=>R0, R1=>R1, R2=>R2, R3=>R3, R4=>R4, R5=>R5, R6=>R6, R7=>R7);

		validate_EXmem<=valid_RREX and hazard_validate_EXmem;

		enable_RA_RREX <= mux_LM_count_out and RA_C_EN_HAZARD;

		counter_enable <= '1';

		counter_reg_EX_LM_reset <= reset or counter_reset;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Memory

		Data_memory: Data_mem port map(Din=>RA_C_EXmem, Add=>mux1_mem_out, Readb_Write=>mem_RW_mem, clk=>clk, reset=>reset, Dout=>mem_mem_dout);

		mux1_mem: MUXM15_21 port map(inp1=>RA_C_EXmem, inp0=>ALU_C_EXmem, cs=>mux1_mem_cont, outp=>mux1_mem_out);
				
		Mem_WB_reg: Mem_WB port map(clk=>clk, valid_in=>validate_memWB, enable=>enable_memWB, valid_out=>valid_memWB, opcode_in=>opcode_EXmem, RA_in=>RA_EXmem, RB_in=>RB_EXmem, RC_in=>RC_EXmem,  imm9_in=>imm9_EXmem,

									counter_in=>counter_EXmem, counter_out=>counter_memWB, LSMen_in=>LSMen_Exmem, LSMen_out=>LSMen_memWB ,PC_2in=>PC_2_EXmem, ALUC_in=>ALU_C_EXmem, RF_edit_in=>RF_edit_EXmem, Dout_in=>mem_mem_dout, 

									opcode_out=>opcode_memWB, RA_out=>RA_memWB, RC_out=>RC_memWB,  imm9_out=>imm9_memWB, RB_out=>RB_memWB,

									PC_2out=>PC_2_memWB, ALUC_out=>ALUC_C_memWB, RF_edit_out=>RF_edit_memWB, Dout_out=>Dout_memWB);

		mux1_mem_cont<=(not opcode_RREX(3)) and opcode_RREX(2) and opcode_RREX(1);

		validate_memWB<=valid_EXmem and hazard_validate_memWB;

		mem_RW_mem<= (((not Opcode_EXmem(3)) and (Opcode_EXmem(2)) and (not Opcode_EXmem(1)) and (Opcode_EXmem(0))) or ((not Opcode_EXmem(3)) and (Opcode_EXmem(2)) and (Opcode_EXmem(1)) and (Opcode_EXmem(0)) and LSMen_Exmem)) and Valid_EXmem;							
						--(SW + SM*En)*Valid

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Write Back

		mux1_WB: MUXM3_41 port map(inp3=>RC_memWB,inp1=>RA_memWB, inp0=>counter_memWB, inp2=>RB_memWB, cs=>mux1_WB_cont,outp=>mux1_WB_out);

		mux2_WB: MUXM15_41 port map(inp0=>Dout_memWB, inp1=>ALUC_C_memWB, inp2=>PC_2_memWB, inp3=>se9_WB_out, cs=>mux2_WB_cont, outp=>mux2_WB_out);

		mux3_WB: MUX_2x1 port map(I0=>RF_edit_memWB, I1=>LSMen_memWB, S=>mux3_WB_cont, y=>mux3_WB_out);

		se9_WB: SE9 port map(inp=>imm9_memWB, outp=>se9_WB_out);

		rf_write<=mux3_WB_out and valid_MEMWB;

		mux1_WB_cont(0)<= (opcode_memWB(0) and opcode_memWB(1)) or (not opcode_memWB(1) and opcode_memWB(2));

		mux1_WB_cont(1)<= (not opcode_memWB(0) and opcode_memWB(1) and not opcode_memWB(2)) or (not opcode_memWB(1) and not opcode_memWB(2));		

		mux2_WB_cont(0)<= not opcode_memWB(2);
		
		mux2_WB_cont(1)<= opcode_memWB(3) or (opcode_memWB(0) and opcode_memWB(1));

		mux3_WB_cont<= (not opcode_RREX(3)) and opcode_RREX(2) and opcode_RREX(1);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Forwarding Unit

		FU: Forwarding_Unit port map(Opcode_ID_RR=>opcode_IDRR, Opcode_RR_EX=>opcode_RREX, Opcode_EX_MEM=>opcode_EXmem, Opcode_MEM_WB=>opcode_memWB, RA_ID_RR=>RA_IDRR, RA_RR_EX=>RA_RREX, 

									RA_EX_MEM=>RA_EXmem, RA_MEM_WB=>RA_memWB, RB_ID_RR=>RB_IDRR, RB_RR_EX=>RB_RREX, RB_EX_MEM=>RB_EXmem, 
									
									RB_MEM_WB=>RB_memWB, RC_ID_RR=>RC_IDRR, RC_RR_EX=>RC_RREX, RC_EX_MEM=>RC_EXMEM, RC_MEM_WB=>RC_memWB, RF_edit_EX=>rf_edit_EX,
									
									RF_edit_EX_MEM=>RF_edit_EXmem, RF_edit_MEM_WB=>RF_edit_memWB, E_EX=>Comp_EX_E, L_EX=>Comp_EX_L,

								   Condition_ID_RR=>cond_IDRR, Condition_RR_EX=>cond_RREX, Valid_ID_RR=>valid_IDRR, LSMEn_EX_MEM => LSMen_Exmem, counter_EXmem => counter_EXmem,

									LSMEn_mem_WB => LSMEn_memWB, counter_memWB => counter_memWB,
									
									Valid_RR_EX=>valid_RREX, Valid_EX_MEM=>valid_EXmem, Valid_MEM_WB=>valid_memWB, S=>S, S_prime=>S_prime);
		

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Deciding Unit
		DU: Deciding_Unit port map(ALU_C_EX=>ALU_C_EX, ALU_C_EX_MEM=>ALU_C_EXmem, MEM_out_MEM=>mem_mem_dout, ALU_C_MEM_WB=>ALUC_C_memWB, MEM_out_MEM_WB=>Dout_memWB,

									Imm9_RR_EX=>imm9_RREX, Imm9_EX_MEM=>imm9_EXmem, Imm9_MEM_WB=>imm9_memWB, RB_C_RR_EX=>RB_C_RREX, S=>S, S_prime=>S_prime, 

									Forward_to_RA_RR=>f1_RR, Forward_to_RB_RR=>f2_RR, Forward_to_PC_IF=>f1_IF,

									Forward_signal_RA_RR=>mux1_RR_cont, Forward_signal_RB_RR=>mux2_RR_cont, Forward_signal_PC_IF=>mux1_IF_cont);


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Hazard Mitigation Unit
		Hazard_Unit: HazardMitigation port map (	Opcode_ID_RR => opcode_IDRR, Opcode_RR_EX => opcode_RREX, Opcode_EX_MEM => opcode_Exmem, Opcode_MEM_WB => opcode_memWB, 
												
													Counter_count => counter_count, Count_end_bit => Counter_end_bit, Valid_ID_RR => valid_IDRR, Valid_RR_EX => valid_RREX,
													
													Valid_EX_MEM => valid_exmem, Valid_MEM_WB => valid_memWB, LSMEn_EX_MEM => LSMEn_exmem, S => S, S_prime => S_prime,

													R0_En => R0_En, IF_ID_EN => enable_IFID, ID_RR_EN => enable_IDRR, RR_EX_EN => enable_RREX, EX_MEM_EN => enable_exmem,
													
													MEM_WB_EN => enable_memWB, Z_En => hazard_Z_En, CY_En => hazard_Cy_En, RA_C_En => RA_C_EN_HAZARD, TempRF_En => temp_rf_enable,

													Valid_ID_RR_out => hazard_validate_IDRR, Valid_RR_EX_out => hazard_validate_RREX, Valid_EX_MEM_out => hazard_validate_exmem,

													Valid_IF_ID_out => hazard_validate_IFID, Valid_MEM_WB_out => hazard_validate_memWB);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------





end architecture struct;