library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Forwarding_Unit is
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
end entity Forwarding_Unit;

architecture struct of Forwarding_Unit is
	signal ADA_ACA_ID_RR, ADC_ACC_ID_RR, ADZ_ACZ_ID_RR, AWC_ACW_ID_RR, ADI_ID_RR, NDU_NCU_ID_RR, NDC_NCC_ID_RR, NDZ_NCZ_ID_RR, LLI_ID_RR, LW_ID_RR, SW_ID_RR, BEQ_ID_RR, BLT_ID_RR, BLE_ID_RR, JAL_ID_RR, JLR_ID_RR, JRI_ID_RR, ADA_ACA_RR_EX, ADC_ACC_RR_EX, ADZ_ACZ_RR_EX, AWC_ACW_RR_EX, ADI_RR_EX, NDU_NCU_RR_EX, NDC_NCC_RR_EX, NDZ_NCZ_RR_EX, LLI_RR_EX, LW_RR_EX, SW_RR_EX, BEQ_RR_EX, BLT_RR_EX, BLE_RR_EX, JAL_RR_EX, JLR_RR_EX, JRI_RR_EX, RC_R0_RR_EX, RA_R0_RR_EX, RB_R0_RR_EX, ADA_ACA_EX_MEM, ADC_ACC_EX_MEM, ADZ_ACZ_EX_MEM, AWC_ACW_EX_MEM, ADI_EX_MEM, NDU_NCU_EX_MEM, NDC_NCC_EX_MEM, NDZ_NCZ_EX_MEM, LLI_EX_MEM, LW_EX_MEM, SW_EX_MEM, BEQ_EX_MEM, BLT_EX_MEM, BLE_EX_MEM, JAL_EX_MEM, JLR_EX_MEM, JRI_EX_MEM, RC_R0_EX_MEM, RA_R0_EX_MEM, RB_R0_EX_MEM, ADA_ACA_MEM_WB, ADC_ACC_MEM_WB, ADZ_ACZ_MEM_WB, AWC_ACW_MEM_WB, ADI_MEM_WB, NDU_NCU_MEM_WB, NDC_NCC_MEM_WB, NDZ_NCZ_MEM_WB, LLI_MEM_WB, LW_MEM_WB, SW_MEM_WB, BEQ_MEM_WB, BLT_MEM_WB, BLE_MEM_WB, JAL_MEM_WB, JLR_MEM_WB, JRI_MEM_WB, RC_R0_MEM_WB, RA_R0_MEM_WB, RB_R0_MEM_WB: std_logic;
	signal ADD_EX_MEM, ADD_MEM_WB, NAND_EX_MEM, NAND_MEM_WB, LM_MEM_R0, LM_R1_MEM_WB: std_logic;
		begin

			ADA_ACA_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and (not condition_ID_RR(1)) and (not Condition_ID_RR(0))) and Valid_ID_RR;
			ADC_ACC_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and (Condition_ID_RR(1)) and (not Condition_ID_RR(0))) and Valid_ID_RR;
			ADZ_ACZ_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and (Condition_ID_RR(0)) and (not Condition_ID_RR(1))) and Valid_ID_RR;
			AWC_ACW_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and (Condition_ID_RR(1)) and (Condition_ID_RR(0))) and Valid_ID_RR;
			
			ADI_ID_RR <= (not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and Valid_ID_RR;
			
			NDU_NCU_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and (not condition_ID_RR(1)) and (not Condition_ID_RR(0))) and Valid_ID_RR;
			NDC_NCC_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and (not condition_ID_RR(0)) and (Condition_ID_RR(1))) and Valid_ID_RR;
			NDZ_NCZ_ID_RR <= ((not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and (condition_ID_RR(0)) and (not Condition_ID_RR(1))) and Valid_ID_RR;
			
			LLI_ID_RR <= (not Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and Valid_ID_RR;
			
			LW_ID_RR <= (not Opcode_ID_RR(3)) and (Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (not Opcode_ID_RR(3)) and Valid_ID_RR;

			SW_ID_RR <= (not Opcode_ID_RR(3)) and (Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and Valid_ID_RR;
			
			BEQ_ID_RR <= ((Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and E_EX) and Valid_ID_RR;
			BLT_ID_RR <= ((Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and L_EX) and Valid_ID_RR;
			BLE_ID_RR <= ((Opcode_ID_RR(3)) and (not Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (not Opcode_ID_RR(0)) and (E_EX or L_EX)) and Valid_ID_RR;
			
			JAL_ID_RR <= ((Opcode_ID_RR(3)) and (Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (not Opcode_ID_RR(0))) and Valid_ID_RR;
			JLR_ID_RR <= (Opcode_ID_RR(3)) and (Opcode_ID_RR(2)) and (not Opcode_ID_RR(1)) and (Opcode_ID_RR(0)) and Valid_ID_RR;
			JRI_ID_RR <= ((Opcode_ID_RR(3)) and (Opcode_ID_RR(2)) and (Opcode_ID_RR(1)) and (Opcode_ID_RR(0))) and Valid_ID_RR;

			------ Completes ID_RR signals -------------
						
			ADA_ACA_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and (not condition_RR_EX(1)) and (not Condition_RR_EX(0))) and Valid_RR_EX;
			ADC_ACC_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and (Condition_RR_EX(1)) and (not Condition_RR_EX(0))) and Valid_RR_EX;
			ADZ_ACZ_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and (Condition_RR_EX(0)) and (not Condition_RR_EX(1))) and Valid_RR_EX;
			AWC_ACW_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and (Condition_RR_EX(1)) and (Condition_RR_EX(0))) and Valid_RR_EX;
			
			ADI_RR_EX <= (not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and Valid_RR_EX;
			
			NDU_NCU_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and (not condition_RR_EX(1)) and (not Condition_RR_EX(0))) and Valid_RR_EX;
			NDC_NCC_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and (not condition_RR_EX(0)) and (Condition_RR_EX(1))) and Valid_RR_EX;
			NDZ_NCZ_RR_EX <= ((not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and (condition_RR_EX(0)) and (not Condition_RR_EX(1))) and Valid_RR_EX;
			
			LLI_RR_EX <= (not Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and Valid_RR_EX;
			
			LW_RR_EX <= (not Opcode_RR_EX(3)) and (Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (not Opcode_RR_EX(3)) and Valid_RR_EX;

			SW_RR_EX <= (not Opcode_RR_EX(3)) and (Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and Valid_RR_EX;
			
			BEQ_RR_EX <= ((Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and E_EX) and Valid_RR_EX;
			BLT_RR_EX <= ((Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and L_EX) and Valid_RR_EX;
			BLE_RR_EX <= ((Opcode_RR_EX(3)) and (not Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (not Opcode_RR_EX(0)) and (E_EX or L_EX)) and Valid_RR_EX;
			
			JAL_RR_EX <= ((Opcode_RR_EX(3)) and (Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (not Opcode_RR_EX(0))) and Valid_RR_EX;
			JLR_RR_EX <= (Opcode_RR_EX(3)) and (Opcode_RR_EX(2)) and (not Opcode_RR_EX(1)) and (Opcode_RR_EX(0)) and Valid_RR_EX;
			JRI_RR_EX <= ((Opcode_RR_EX(3)) and (Opcode_RR_EX(2)) and (Opcode_RR_EX(1)) and (Opcode_RR_EX(0))) and Valid_RR_EX;
			
			RC_R0_RR_EX <= (not RC_RR_EX(0)) and (not RC_RR_EX(1)) and (not RC_RR_EX(2)) and Valid_RR_EX;  
			RA_R0_RR_EX <= (not RA_RR_EX(0)) and (not RA_RR_EX(1)) and (not RA_RR_EX(2)) and Valid_RR_EX;
			RB_R0_RR_EX <= (not RB_RR_EX(0)) and (not RB_RR_EX(1)) and (not RB_RR_EX(2)) and Valid_RR_EX;

			------ Completes RR_EX signals -------------

			--ADA_ACA_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and (not condition_EX_MEM(1)) and (not Condition_EX_MEM(0))) and Valid_EX_MEM;
			--ADC_ACC_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and (Condition_EX_MEM(1)) and (not Condition_EX_MEM(0))) and Valid_EX_MEM;
			--ADZ_ACZ_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and (Condition_EX_MEM(0)) and (not Condition_EX_MEM(1))) and Valid_EX_MEM;
			--AWC_ACW_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and (Condition_EX_MEM(1)) and (Condition_EX_MEM(0))) and Valid_EX_MEM;
			ADD_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and RF_edit_EX_MEM) and Valid_EX_MEM;

			ADI_EX_MEM <= (not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and Valid_EX_MEM;
			
			--NDU_NCU_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and (not condition_EX_MEM(1)) and (not Condition_EX_MEM(0))) and Valid_EX_MEM;
			--NDC_NCC_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and (not condition_EX_MEM(0)) and (Condition_EX_MEM(1))) and Valid_EX_MEM;
			--NDZ_NCZ_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and (condition_EX_MEM(0)) and (not Condition_EX_MEM(1))) and Valid_EX_MEM;
			NAND_EX_MEM <= ((not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and RF_edit_EX_MEM) and Valid_EX_MEM;

			LLI_EX_MEM <= (not Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and Valid_EX_MEM;
			
			LW_EX_MEM <= (not Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(3)) and Valid_EX_MEM;

			LM_MEM_R0 <= ((not Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and LSMEn_EX_MEM and ((not counter_EXmem(2)) 
							and (not counter_EXmem(1)) and (not counter_EXmem(0)))) and Valid_EX_MEM;

			SW_EX_MEM <= (not Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and Valid_EX_MEM;
			
			BEQ_EX_MEM <= ((Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and E_EX) and Valid_EX_MEM;
			BLT_EX_MEM <= ((Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and L_EX) and Valid_EX_MEM;
			BLE_EX_MEM <= ((Opcode_EX_MEM(3)) and (not Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0)) and (E_EX or L_EX)) and Valid_EX_MEM;
			
			JAL_EX_MEM <= ((Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (not Opcode_EX_MEM(0))) and Valid_EX_MEM;
			JLR_EX_MEM <= (Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (not Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0)) and Valid_EX_MEM;
			JRI_EX_MEM <= ((Opcode_EX_MEM(3)) and (Opcode_EX_MEM(2)) and (Opcode_EX_MEM(1)) and (Opcode_EX_MEM(0))) and Valid_EX_MEM;
			
			RC_R0_EX_MEM <= (not RC_EX_MEM(0)) and (not RC_EX_MEM(1)) and (not RC_EX_MEM(2)) and Valid_EX_MEM;  
			RA_R0_EX_MEM <= (not RA_EX_MEM(0)) and (not RA_EX_MEM(1)) and (not RA_EX_MEM(2)) and Valid_EX_MEM;
			RB_R0_EX_MEM <= (not RB_EX_MEM(0)) and (not RB_EX_MEM(1)) and (not RB_EX_MEM(2)) and Valid_EX_MEM;

			------ Completes EX_MEM signals -------------

			--ADA_ACA_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and (not condition_MEM_WB(1)) and (not Condition_MEM_WB(0))) and Valid_MEM_WB;
			--ADC_ACC_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and (Condition_MEM_WB(1)) and (not Condition_MEM_WB(0))) and Valid_MEM_WB;
			--ADZ_ACZ_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and (Condition_MEM_WB(0)) and (not Condition_MEM_WB(1))) and Valid_MEM_WB;
			--AWC_ACW_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and (Condition_MEM_WB(1)) and (Condition_MEM_WB(0))) and Valid_MEM_WB;
			ADD_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and RF_edit_MEM_WB) and Valid_MEM_WB;			

			ADI_MEM_WB <= (not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and Valid_MEM_WB;
			
			--NDU_NCU_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and (not condition_MEM_WB(1)) and (not Condition_MEM_WB(0))) and Valid_MEM_WB;
			--NDC_NCC_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and (not condition_MEM_WB(0)) and (Condition_MEM_WB(1))) and Valid_MEM_WB;
			--NDZ_NCZ_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and (condition_MEM_WB(0)) and (not Condition_MEM_WB(1))) and Valid_MEM_WB;
			NAND_MEM_WB <= ((not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and RF_edit_MEM_WB) and Valid_MEM_WB;

			LLI_MEM_WB <= (not Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and Valid_MEM_WB;
			
			LW_MEM_WB <= (not Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(3)) and Valid_MEM_WB;

			LM_R1_MEM_WB <= ((not Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and LSMEn_MEM_WB) and Valid_MEM_WB 
							and ((not counter_memWB(2)) and (not counter_memWB(1)) and counter_memWB(0));

			SW_MEM_WB <= (not Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and Valid_MEM_WB;
			
			BEQ_MEM_WB <= ((Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and E_EX) and Valid_MEM_WB;
			BLT_MEM_WB <= ((Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and L_EX) and Valid_MEM_WB;
			BLE_MEM_WB <= ((Opcode_MEM_WB(3)) and (not Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0)) and (E_EX or L_EX)) and Valid_MEM_WB;
			
			JAL_MEM_WB <= ((Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (not Opcode_MEM_WB(0))) and Valid_MEM_WB;
			JLR_MEM_WB <= (Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (not Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0)) and Valid_MEM_WB;
			JRI_MEM_WB <= ((Opcode_MEM_WB(3)) and (Opcode_MEM_WB(2)) and (Opcode_MEM_WB(1)) and (Opcode_MEM_WB(0))) and Valid_MEM_WB;
			
			RC_R0_MEM_WB <= (not RC_MEM_WB(0)) and (not RC_MEM_WB(1)) and (not RC_MEM_WB(2)) and Valid_MEM_WB;  
			RA_R0_MEM_WB <= (not RA_MEM_WB(0)) and (not RA_MEM_WB(1)) and (not RA_MEM_WB(2)) and Valid_MEM_WB;
			RB_R0_MEM_WB <= (not RB_MEM_WB(0)) and (not RB_MEM_WB(1)) and (not RB_MEM_WB(2)) and Valid_MEM_WB;

			------ Completes MEM_WB signals -------------
			
			---------------------------------------------------------------------
			
			S(1) <= JLR_RR_EX;
			S(2) <= JAL_RR_EX or JRI_RR_EX or BEQ_RR_EX or BLT_RR_EX or BLE_RR_EX or (ADA_ACA_RR_EX and RC_R0_RR_EX) or 
						(ADC_ACC_RR_EX and RF_edit_EX and RC_R0_RR_EX) or (ADZ_ACZ_RR_EX and RF_edit_EX and RC_R0_RR_EX) or 
						(AWC_ACW_RR_EX and RC_R0_RR_EX) or (ADI_RR_EX and RB_R0_RR_EX) or 
						(NDU_NCU_RR_EX and RC_R0_RR_EX) or (NDC_NCC_RR_EX and RF_edit_EX and RC_R0_RR_EX) or (NDZ_NCZ_RR_EX and RF_edit_EX and RC_R0_RR_EX);
			S(3) <= (LW_EX_MEM and RA_R0_EX_MEM) or LM_MEM_R0;
			S(4) <= LLI_RR_EX and RA_R0_RR_EX;
			
			-- Finishes Branching 
			
			S(5) <= (ADA_ACA_RR_EX or AWC_ACW_RR_EX or NDU_NCU_RR_EX or (NDC_NCC_RR_EX and RF_edit_EX) or (NDZ_NCZ_RR_EX and RF_edit_EX) or (ADC_ACC_RR_EX and RF_edit_EX) or (ADZ_ACZ_RR_EX and RF_edit_EX)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RC_RR_EX(0) xor RA_ID_RR(0)) or (RC_RR_EX(1) xor RA_ID_RR(1)) or (RC_RR_EX(2) xor RA_ID_RR(2)));
			S(6) <= (ADI_RR_EX) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RB_RR_EX(0) xor RA_ID_RR(0)) or (RB_RR_EX(1) xor RA_ID_RR(1)) or (RB_RR_EX(2) xor RA_ID_RR(2)));

			S(7) <= (ADA_ACA_EX_MEM or AWC_ACW_EX_MEM or NDU_NCU_EX_MEM or (NDC_NCC_EX_MEM and RF_edit_EX_MEM) or (NDZ_NCZ_EX_MEM and RF_edit_EX_MEM) or (ADC_ACC_EX_MEM and RF_edit_EX_MEM) or (ADZ_ACZ_EX_MEM and RF_edit_EX_MEM)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RC_EX_MEM(0) xor RA_ID_RR(0)) or (RC_EX_MEM(1) xor RA_ID_RR(1)) or (RC_EX_MEM(2) xor RA_ID_RR(2)));
			S(8) <= (ADI_EX_MEM) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RB_EX_MEM(0) xor RA_ID_RR(0)) or (RB_EX_MEM(1) xor RA_ID_RR(1)) or (RB_EX_MEM(2) xor RA_ID_RR(2)));

			S(9) <= (ADA_ACA_MEM_WB or AWC_ACW_MEM_WB or NDU_NCU_MEM_WB or (NDC_NCC_MEM_WB and RF_edit_MEM_WB) or (NDZ_NCZ_MEM_WB and RF_edit_MEM_WB) or (ADC_ACC_MEM_WB and RF_edit_MEM_WB) or (ADZ_ACZ_MEM_WB and RF_edit_MEM_WB)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RC_MEM_WB(0) xor RA_ID_RR(0)) or (RC_MEM_WB(1) xor RA_ID_RR(1)) or (RC_MEM_WB(2) xor RA_ID_RR(2)));
			S(10) <= (ADI_MEM_WB) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR or ADI_ID_RR) and not ((RB_MEM_WB(0) xor RA_ID_RR(0)) or (RB_MEM_WB(1) xor RA_ID_RR(1)) or (RB_MEM_WB(2) xor RA_ID_RR(2)));

			-- FInishes Arithmetic Dependency on first operand 

			S(11) <= (LW_RR_EX) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR) 
						and not ((RA_RR_EX(0) xor RA_ID_RR(0)) or (RA_RR_EX(1) xor RA_ID_RR(1)) or (RA_RR_EX(2) xor RA_ID_RR(2)));

			S(12) <= (LW_EX_MEM) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR)
						 and not ((RA_EX_MEM(0) xor RA_ID_RR(0)) or (RA_EX_MEM(1) xor RA_ID_RR(1)) or (RA_EX_MEM(2) xor RA_ID_RR(2)));

			S(13) <= ((LW_MEM_WB) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR)
						 and not ((RA_MEM_WB(0) xor RA_ID_RR(0)) or (RA_MEM_WB(1) xor RA_ID_RR(1)) or (RA_MEM_WB(2) xor RA_ID_RR(2)))) 
						 or (LM_R1_MEM_WB and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR) 
						 and (not RA_ID_RR(2)) and (not RA_ID_RR(1)) and RA_ID_RR(0));

			S(14) <= (LLI_RR_EX) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR)
						 and not ((RA_RR_EX(0) xor RA_ID_RR(0)) or (RA_RR_EX(1) xor RA_ID_RR(1)) or (RA_RR_EX(2) xor RA_ID_RR(2)));

			S(15) <= (LLI_EX_MEM) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR)
						 and not ((RA_EX_MEM(0) xor RA_ID_RR(0)) or (RA_EX_MEM(1) xor RA_ID_RR(1)) or (RA_EX_MEM(2) xor RA_ID_RR(2)));

			S(16) <= (LLI_MEM_WB) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR)
						 and not ((RA_MEM_WB(0) xor RA_ID_RR(0)) or (RA_MEM_WB(1) xor RA_ID_RR(1)) or (RA_MEM_WB(2) xor RA_ID_RR(2)));

			-- Finishes Load and LLI Dependencies

			-- Starting to define S_prime signals 

			S_prime(1) <= '0';
			S_prime(2) <= '0';
			S_prime(3) <= '0';
			S_prime(4) <= '0';
			
			-- Finishes Branching 
			
			S_prime(5) <= (ADA_ACA_RR_EX or AWC_ACW_RR_EX or NDU_NCU_RR_EX or (NDC_NCC_RR_EX and RF_edit_EX) or (NDZ_NCZ_RR_EX and RF_edit_EX) or (ADC_ACC_RR_EX and RF_edit_EX) or (ADZ_ACZ_RR_EX and RF_edit_EX)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RC_RR_EX(0) xor RB_ID_RR(0)) or (RC_RR_EX(1) xor RB_ID_RR(1)) or (RC_RR_EX(2) xor RB_ID_RR(2)));
			S_prime(6) <= (ADI_RR_EX) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RB_RR_EX(0) xor RB_ID_RR(0)) or (RB_RR_EX(1) xor RB_ID_RR(1)) or (RB_RR_EX(2) xor RB_ID_RR(2)));

			S_prime(7) <= (ADA_ACA_EX_MEM or AWC_ACW_EX_MEM or NDU_NCU_EX_MEM or (NDC_NCC_EX_MEM and RF_edit_EX_MEM) or (NDZ_NCZ_EX_MEM and RF_edit_EX_MEM) or (ADC_ACC_EX_MEM and RF_edit_EX_MEM) or (ADZ_ACZ_EX_MEM and RF_edit_EX_MEM)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RC_EX_MEM(0) xor RB_ID_RR(0)) or (RC_EX_MEM(1) xor RB_ID_RR(1)) or (RC_EX_MEM(2) xor RB_ID_RR(2)));
			S_prime(8) <= (ADI_EX_MEM) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RB_EX_MEM(0) xor RB_ID_RR(0)) or (RB_EX_MEM(1) xor RB_ID_RR(1)) or (RB_EX_MEM(2) xor RB_ID_RR(2)));

			S_prime(9) <= (ADA_ACA_MEM_WB or AWC_ACW_MEM_WB or NDU_NCU_MEM_WB or (NDC_NCC_MEM_WB and RF_edit_MEM_WB) or (NDZ_NCZ_MEM_WB and RF_edit_MEM_WB) or (ADC_ACC_MEM_WB and RF_edit_MEM_WB) or (ADZ_ACZ_MEM_WB and RF_edit_MEM_WB)) and 
					(ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RC_MEM_WB(0) xor RB_ID_RR(0)) or (RC_MEM_WB(1) xor RB_ID_RR(1)) or (RC_MEM_WB(2) xor RB_ID_RR(2)));
			S_prime(10) <= (ADI_MEM_WB) and (ADA_ACA_ID_RR or NDU_NCU_ID_RR) and not ((RB_MEM_WB(0) xor RB_ID_RR(0)) or (RB_MEM_WB(1) xor RB_ID_RR(1)) or (RB_MEM_WB(2) xor RB_ID_RR(2)));

			-- Finishes Arithmetic Dependency on second operand 

			S_prime(11) <= (LW_RR_EX) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_RR_EX(0) xor RB_ID_RR(0)) or (RA_RR_EX(1) xor RB_ID_RR(1)) or (RA_RR_EX(2) xor RB_ID_RR(2)));

			S_prime(12) <= (LW_EX_MEM) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_EX_MEM(0) xor RB_ID_RR(0)) or (RA_EX_MEM(1) xor RB_ID_RR(1)) or (RA_EX_MEM(2) xor RB_ID_RR(2)));

			S_prime(13) <= ((LW_MEM_WB) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_MEM_WB(0) xor RB_ID_RR(0)) or (RA_MEM_WB(1) xor RB_ID_RR(1)) or (RA_MEM_WB(2) xor RB_ID_RR(2))))
							or (LM_R1_MEM_WB and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR or ADI_ID_RR or SW_ID_RR) 
							and (not RB_ID_RR(2)) and (not RB_ID_RR(1)) and RB_ID_RR(0));

			S_prime(14) <= (LLI_RR_EX) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_RR_EX(0) xor RB_ID_RR(0)) or (RA_RR_EX(1) xor RB_ID_RR(1)) or (RA_RR_EX(2) xor RB_ID_RR(2)));

			S_prime(15) <= (LLI_EX_MEM) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_EX_MEM(0) xor RB_ID_RR(0)) or (RA_EX_MEM(1) xor RB_ID_RR(1)) or (RA_EX_MEM(2) xor RB_ID_RR(2)));

			S_prime(16) <= (LLI_MEM_WB) and (ADA_ACA_ID_RR or ADC_ACC_ID_RR or ADZ_ACZ_ID_RR or AWC_ACW_ID_RR or NDU_NCU_ID_RR or NDC_NCC_RR_EX or NDZ_NCZ_ID_RR) 
							and not ((RA_MEM_WB(0) xor RB_ID_RR(0)) or (RA_MEM_WB(1) xor RB_ID_RR(1)) or (RA_MEM_WB(2) xor RB_ID_RR(2)));

			-- Finishes Load and LLI dependency on second operand 
			
			------------------------------------------------------------------------
end architecture;