library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;


entity HazardMitigation is
    -- Entity ports declaration
    -- Add your input and output ports here
    port(
        Opcode_ID_RR, Opcode_RR_EX, Opcode_EX_MEM, Opcode_MEM_WB : in std_logic_vector(3 downto 0);
        Counter_count : in std_logic_vector(2 downto 0);
        Valid_ID_RR, Valid_RR_EX, Valid_EX_MEM, Valid_MEM_WB, LSMEn_EX_MEM, Count_end_bit: in std_logic;
        S, S_prime : in std_logic_vector(16 downto 1); -- Needed for branching
        
        -- Outputs
        R0_En, IF_ID_En, ID_RR_En, RR_EX_En, EX_MEM_En, MEM_WB_En, Z_En, Cy_En, RA_C_En, TempRF_En : out std_logic; -- Enable signals for Pipeline Registers, Flags and R0   

        Valid_ID_RR_Out, Valid_RR_EX_Out, Valid_EX_MEM_Out, Valid_IF_ID_Out, Valid_MEM_WB_Out : out std_logic -- Valid Bits for Pipeline Registers
    );

end entity HazardMitigation;

architecture Behavioral of HazardMitigation is
begin
    process (Opcode_ID_RR, Opcode_RR_EX, Opcode_EX_MEM, Opcode_MEM_WB, Counter_count, Valid_ID_RR, Valid_RR_EX, Valid_EX_MEM, Valid_MEM_WB, S, S_prime)
    begin
        -- Valid LM in WB Stage and Register to be updated is R0
        --if (Opcode_MEM_WB = "0110" and Valid_MEM_WB = '1') then
            --Valid_RR_EX_Out <= '0';
            --Valid_ID_RR_Out <= '1';
            --Valid_EX_MEM_out <= '1';
            --R0_En <= '0';
            --IF_ID_En <= '0';
            --ID_RR_En <= '0';
            --RR_EX_En <= '1';
            --Z_En <= '1';
            --Cy_En <= '1';       

        -- Valid LM or LW in MEM Stage and Register to be updated is R0
        --if (Opcode_EX_MEM = "0110" and Valid_EX_MEM = '1' and Counter_EX_MEM = "0000" and LSMEn_EX_MEM = '1') then
        if (S(3) = '1') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '0';
            Valid_EX_MEM_out <= '0';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_EN <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '0';
            Cy_En <= '0';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Valid LM Hazard in Execute Stage (Not R0)
        elsif (Opcode_RR_EX = "0110" and Valid_RR_EX = '1' and Counter_count = "000" and Count_end_bit = '0') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '0';
            Valid_EX_MEM_out <= '1';
            R0_En <= '0';
            IF_ID_En <= '0';
            ID_RR_En <= '0';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            TempRF_En <= '0';
            RA_C_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Valid SM in EX Stage and Register to be updated is R0
        elsif (Opcode_RR_EX = "0111" and Valid_RR_EX = '1' and Counter_count = "000") then
            Valid_RR_EX_Out <= '1';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '1';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Valid SM in EX Stage and Register to be updated is not R0
        elsif (Opcode_RR_EX = "0111" and Valid_RR_EX = '1' and not Counter_count = "000") then
            Valid_RR_EX_Out <= '1';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '0';
            IF_ID_En <= '0';
            ID_RR_En <= '0';
            RR_EX_En <= '0';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '1';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        --- Completes hazards raised in Execute Stage by LM SM
        -- Valid Load Immediate Dependency in Execute Stage
        elsif (S(11) = '1' or S_prime(11) = '1') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '0';
            IF_ID_En <= '0';
            ID_RR_En <= '0';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Branching Hazard raised in Execute Stage
        elsif (S(1) = '1' or S(2) = '1' or S(4) = '1') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '0';
            Valid_EX_MEM_out <= '1';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Completes hazards raised in Execute Stage by Load Immediate Dependency and Branching Hazard
        -- Valid LM in ID_RR and Valid_RR_EX = Valid_EX_MEM = Valid_MEM_WB = 0
        elsif (Opcode_ID_RR = "0110" and Valid_ID_RR = '1' and Valid_RR_EX = '0' and Valid_EX_MEM = '0' and Valid_MEM_WB = '0') then
            Valid_RR_EX_Out <= '1';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- LM in ID_RR Stage
        elsif (Opcode_ID_RR = "0110" and Valid_ID_RR = '1') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '0';
            IF_ID_En <= '0';
            ID_RR_En <= '0';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- Valid SM in ID_RR and Valid_RR_EX = Valid_EX_MEM = Valid_MEM_WB = 0
        elsif (Opcode_ID_RR = "0111" and Valid_ID_RR = '1' and Valid_RR_EX = '0' and Valid_EX_MEM = '0' and Valid_MEM_WB = '0') then
            Valid_RR_EX_Out <= '1';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '1';
            TempRF_En <= '1'; -- TempRF is enabled for SM in ID_RR
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        -- SM in ID_RR Pipeline Register (SM in RR Stage)
        elsif (Opcode_ID_RR = "0111" and Valid_ID_RR = '1') then
            Valid_RR_EX_Out <= '0';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '0';
            IF_ID_En <= '0';
            ID_RR_En <= '0';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '0';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        else
            Valid_RR_EX_Out <= '1';
            Valid_ID_RR_Out <= '1';
            Valid_EX_MEM_out <= '1';
            R0_En <= '1';
            IF_ID_En <= '1';
            ID_RR_En <= '1';
            RR_EX_En <= '1';
            EX_MEM_En <= '1';
            MEM_WB_En <= '1';
            RA_C_En <= '1';
            TempRF_En <= '0';
            Z_En <= '1';
            Cy_En <= '1';
            Valid_IF_ID_Out <= '1';
            Valid_MEM_WB_Out <= '1';
        end if;

    end process;

end architecture Behavioral;


