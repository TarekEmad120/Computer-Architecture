LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY ForwardUnit IS
    PORT (
        RS1_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RS2_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rd_address_EM_reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WRB_EN_EM_reg : IN STD_LOGIC;
        Rd_address_MW_reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WRB_EN_MW_reg : IN STD_LOGIC;

        Alu_src2_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Alu_src1_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );
END ForwardUnit;

ARCHITECTURE My_imp_of_Forward_unit OF ForwardUnit IS

BEGIN
    
        Alu_src2_sel <=
            "01" WHEN (RS2_address = Rd_address_EM_reg AND  WRB_EN_EM_reg = '1') ELSE
            "10" WHEN (RS2_address = Rd_address_MW_reg AND  WRB_EN_MW_reg = '1')
            --AND (RS2_address != Rd_address_EM_reg AND WRB_EN_EM_reg = '1') 
            ELSE
            "00";
        Alu_src1_sel <= 
            "01" WHEN (RS1_address = Rd_address_EM_reg AND WRB_EN_EM_reg = '1') ELSE
            "10" WHEN (RS1_address = Rd_address_MW_reg AND WRB_EN_MW_reg = '1')
            --AND (RS1_address != Rd_address_EM_reg AND WRB_EN_EM_reg = '1') 
            ELSE
            "00";
            -- Rd_address_MW_reg=>Rd_address_out_mem_wb,
            -- WRB_EN_MW_reg=>WB_EN_out_mem_wb,
    
END My_imp_of_Forward_unit;