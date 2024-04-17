LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Execute_Mememory_Register IS

PORT (
    clk,reset,enable : IN STD_LOGIC;
    MEM_READ_In,MEM_WRITE_In,WRITE_BACK_In:IN STD_LOGIC;
    WRB_S_In: IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Rd_address_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Ra_In:In STD_LOGIC_VECTOR(31 DOWNTO 0);
    AluOut_In: In STD_LOGIC_VECTOR(31 DOWNTO 0);


    MEM_READ_Out,MEM_WRITE_Out,WRITE_BACK_Out:OUT STD_LOGIC;
    WRB_S_Out: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Rd_address_Out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    Ra_Out:Out STD_LOGIC_VECTOR(31 DOWNTO 0);
    AluOut_Out: Out STD_LOGIC_VECTOR(31 DOWNTO 0)

);
END Execute_Mememory_Register;

ARCHITECTURE IMP OF Execute_Mememory_Register IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
                Rd_address_Out<=(OTHERS => '0');
                RA_Out<=(OTHERS => '0');
                AluOut_Out<=(OTHERS => '0');
                MEM_READ_Out<= '0';
                MEM_WRITE_Out<='0';
                WRITE_BACK_Out<='0';
                WRB_S_Out<=(OTHERS => '0');
        ELSIF clk'EVENT AND clk = '1' THEN
            IF enable = '1' THEN
                Rd_address_Out<=Rd_address_In;
                RA_Out<=Ra_In;
                AluOut_Out<=AluOut_In;
                MEM_READ_Out<=MEM_READ_In;
                MEM_WRITE_Out<=MEM_WRITE_In;
                WRITE_BACK_Out<=WRITE_BACK_In;
                WRB_S_Out<=WRB_S_In;
            END IF;
        END IF;
    END PROCESS;
  
END IMP;