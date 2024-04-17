---includes 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALUc IS
    GENERIC (bits : INTEGER := 16);
    PORT (
        A : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        Cin : IN STD_LOGIC;
        F : OUT STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END ALUc;

-- Part C
-- 1 0 0 0 F = Logic shift left A, Cout = shifted bit
-- 1 0 0 1 F = Rotate left A, Cout = rotated bit
-- 1 0 1 0 F = Rotate Left A with carry (cin), Cout = rotated bit
-- 1 0 1 1 F = 0000, Cout = 0

ARCHITECTURE partC OF ALUc IS
BEGIN
    PROCESS (S, A, B, Cin)
    BEGIN
        CASE S IS
            WHEN "1000" =>
                F <= A(bits - 2 DOWNTO 0) & '0';
                Cout <= A(bits - 1);
            WHEN "1001" =>
                Cout <= A(bits - 1);
                F <= A(bits - 2 DOWNTO 0) & A(bits - 1);

            WHEN "1010" =>
                F <= A(bits - 2 DOWNTO 0) & Cin;
                Cout <= A(bits - 1);
            WHEN "1011" =>
                F <= (OTHERS => '0');
                Cout <= '0';
            WHEN OTHERS =>
                F <= (OTHERS => '0');
                Cout <= '0';
        END CASE;
    END PROCESS;
END partC;