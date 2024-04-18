LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALU_Controller IS
    PORT (
        OPCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Funct : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Two_Attribute : IN STD_LOGIC;

        ALUSelection : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
END ALU_Controller;


