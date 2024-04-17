--includes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- You are required to design a 8-bit ALU that accepts a 2 8-bit input values “A” and “B” and 
-- provides a 8-bit output “F” and a 1-bit output Cout. The ALU has 4-bit selection inputs “S” (S0-
-- >S3) and Cin input.

entity ALU is
    generic (bits : integer := 16);
    Port ( A : in  STD_LOGIC_VECTOR (bits-1 downto 0);
           B : in  STD_LOGIC_VECTOR (bits-1 downto 0);
           S : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           F : out  STD_LOGIC_VECTOR (bits-1 downto 0);
           Cout : out  STD_LOGIC);
end ALU;

-- Part B

-- 0 1 0 0 F = A or B, Cout = 0
-- 0 1 0 1 F = A and B, Cout = 0
-- 0 1 1 0 F = A nor B, Cout = 0
-- 0 1 1 1 F = Not A, Cout = 0

architecture partB of ALU is
begin
        Cout <= '0' ;
        F <= A or B when S = "0100" else
             A and B when S = "0101" else
             not (A or B) when S = "0110" else
             not A when S = "0111" else
             (others => '0');
        
end partB;