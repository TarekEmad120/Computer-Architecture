LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Alu_Controller IS

PORT (
    enable : IN STD_LOGIC;
    aluControl : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    Func: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    one_two_attrib: IN  STD_LOGIC
   
);

END Alu_Controller;

ARCHITECTURE IMP OF Alu_Controller IS

    
BEGIN
aluControl <= "0000" when Func = "001" and one_two_attrib ='0'
           <= "0001" when 


  
END IMP;