LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Controller IS

PORT (
    enable : IN STD_LOGIC;
    oppCode:IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    Func: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    one_two_attrib: IN  STD_LOGIC;
    MEM_READ,MEM_WRITE,WRITE_BACK:OUT STD_LOGIC;
    RA2_SEL:OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    WRB_S: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Free_P_Enable:OUT  STD_LOGIC;
    Mem_protect_enable, Mem_free_enable: OUT  STD_LOGIC;
    aluControl : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    RS1_RD_SEL,RS2_RD_SEL:OUT STD_LOGIC
);

END Controller;

ARCHITECTURE IMP OF Controller IS

    
BEGIN
     aluControl <= Func&one_two_attrib when oppCode="001";
     WRB_S <= "10" when oppCode="001";                    -- select ALU Data to write Back
     WRITE_BACK<='1'  when oppCode="001";
     Free_P_Enable<='0' when oppCode="001";

      -- to be edited --
     RA2_SEL<="00" when oppCode="001";
     else <="01";

     -- to be edited --
     RS2_RD_SEL<='0' when oppCode="001";
     RS1_RD_SEL<='1' When one_two_attrib='0'
     else <='0';


     MEM_READ<='0'  when oppCode="001";
     MEM_WRITE<='0' when oppCode="001";
     Mem_protect_enable<='0'when oppCode="001";
     Mem_free_enable<='0'  when oppCode="001";
     -- LDM OPERATION 
     WRITE_BACK<='1'  when oppCode="100" and Func="011";
     WRB_S <= "11"  when oppCode="100" and Func="011"; 
     MEM_READ<='0'  when oppCode="100" and Func="011"; 
     MEM_WRITE<='0' when oppCode="100" and Func="011"; 
     Mem_protect_enable<='0'when oppCode="100" and Func="011"; 
     Mem_free_enable<='0'  when oppCode="100" and Func="011"; 

  
END IMP;