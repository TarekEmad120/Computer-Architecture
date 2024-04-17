

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY n_bit_adder IS
    GENERIC (bits : INTEGER := 16);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
        cin : IN STD_LOGIC;
        result : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
        c_out : OUT STD_LOGIC);
END n_bit_adder;

-- S3 S2 S1 S0 Cin =0 Cin =1
-- Part A
-- 0 0 0 0 F=A F=A+1
-- 0 0 0 1 F=A-B F=A-B-1
-- 0 0 1 0 F=A-B+1 F=A+B+1
-- 0 0 1 1 F=A-1 F=B+1
ARCHITECTURE Behavioral OF n_bit_adder IS

    COMPONENT my_nadder IS
        GENERIC (n : INTEGER := 4);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT select_adder IS
        GENERIC (n : INTEGER := 4);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;
   -- SIGNAL s0, s1, s2, s3 : STD_LOGIC_VECTOR((bits/4) - 1 DOWNTO 0);
   signal CARRYS : STD_LOGIC_VECTOR((bits/4) - 1 DOWNTO 0);

BEGIN

    -- making generic full adder circuit
    my_nadder1 : my_nadder GENERIC MAP(bits/4) PORT MAP(a(3 DOWNTO 0), b(3 DOWNTO 0), cin, result(3 downto 0), CARRYS(0));

    loop1 : FOR i IN 0 TO (bits/4) - 2 GENERATE
        select_adder1 : select_adder GENERIC MAP(bits/4) PORT MAP(a((i + 1) * 4 + 3 DOWNTO (i * 4) + 4), b((i + 1) * 4 + 3 DOWNTO (i *4) + 4), CARRYS(i), result((i + 1) * 4 + 3 DOWNTO (i *4) + 4), CARRYS(i + 1));
    END GENERATE loop1;

    c_out <= CARRYS((bits/4) - 1);

END Behavioral;