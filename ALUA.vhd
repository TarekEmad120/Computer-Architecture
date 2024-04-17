-- Part A
-- selections(S) Cin=0      Cin=1 --S is the selection signal not the sum
-- 0 0 0 0      F=A         F=A+1
-- 0 0 0 1      F=A-B       F=A-B-1
-- 0 0 1 0      F=A-B+1     F=A+B+1
-- 0 0 1 1      F=A-1       F=B+1

--a-b = a+ not b + 1
-- a-b-1 = a+ not b + 1 - 1 = a+ not b
-- a+b+1 = a+ b + 1
-- a-b+1 = a+ not b + 1
-- a-1 = a+ not 1 + 1
-- b+1 = b+1

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ALUA IS
    GENERIC (bits : INTEGER := 16);
    PORT (
        A : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        C_in : IN STD_LOGIC;
        S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END ALUA;

ARCHITECTURE Behavioral OF ALUA IS
    COMPONENT n_bit_adder IS
        GENERIC (bits : INTEGER := 16);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            c_out : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL ax, bx, a2, b2 : STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    SIGNAL temp, temp2 : STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    SIGNAL temp_cout, temp_cout2 : STD_LOGIC;
    SIGNAL cin, cin2 : STD_LOGIC;
BEGIN

    ax <= A WHEN S = "0000" OR S = "0001" OR S = "0010" ELSE
        A WHEN S = "0011" AND C_in = '0' ELSE
        x"0001" WHEN S = "0011" AND C_in = '1' ELSE
        x"0000";

    bx <= NOT B WHEN S = "0001" ELSE
        x"0000" WHEN S = "0000" ELSE
        NOT B WHEN S = "0010"AND C_in = '0' ELSE
        B WHEN S = "0010"AND C_in = '1' ELSE
        NOT(x"0001") WHEN S = "0011" AND C_in = '0' ELSE
        x"0001" WHEN S = "0011" AND C_in = '1' ELSE
        x"0000";

    cin <= C_in WHEN S = "0000" ELSE
        C_in WHEN S = "0010" AND C_in = '0' ELSE
        NOT C_in;

    a2 <= temp WHEN S = "0010" ELSE
        x"0000";
    b2 <= x"0001" WHEN S = "0010" ELSE
        x"0000";
    cin2 <= temp_cout WHEN S = "0010" ELSE
        '0';
    adder0 : n_bit_adder GENERIC MAP(bits) PORT MAP(ax, bx, cin, temp, temp_cout);
    adder1 : n_bit_adder GENERIC MAP(bits) PORT MAP(a2, b2, cin2, temp2, temp_cout2);

    result <= temp WHEN S = "0000" OR S = "0001" OR S = "0011" ELSE
        temp2;
    Cout <= temp_cout WHEN S = "0000" OR S = "0001" OR S = "0011" ELSE
        temp_cout2;

END Behavioral;