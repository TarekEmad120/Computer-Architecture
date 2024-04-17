LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY select_adder IS
    GENERIC (n : INTEGER := 4);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cin : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cout : OUT STD_LOGIC);
END select_adder;

ARCHITECTURE a_my_adder OF select_adder IS
    COMPONENT my_nadder IS
        GENERIC (n : INTEGER := 4);
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL S0, S1 : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL cout0, cout1 : STD_LOGIC;
BEGIN
    f0 : my_nadder GENERIC MAP(n) PORT MAP(a, b, '0', s0, cout0);
    f1 : my_nadder GENERIC MAP(n) PORT MAP(a, b, '1', s1, cout1);

    s <= s0 WHEN cin = '0' ELSE
        s1;
    cout <= cout0 WHEN cin = '0' ELSE
        cout1;

END a_my_adder;