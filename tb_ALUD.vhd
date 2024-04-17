-- this is testbecnch for lab1 partD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY testbenchD IS
END testbenchD;

ARCHITECTURE tb_partD OF testbenchD IS
    COMPONENT ALUd IS
        PORT (
            A : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL A, B, F : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL S : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL Cin, Cout : STD_LOGIC;
BEGIN
    -- Part D
    -- 1 1 0 0 F = Logic shift right A, Cout = shifted bit
    -- 1 1 0 1 F = Rotate right A, Cout = rotated bit
    -- 1 1 1 0 F = Rotate right A with carry (cin), Cout = rotated bit
    -- 1 1 1 1 F = Arithmetic Shift A
    UUT : ALUd PORT MAP(A, B, S, Cin, F, Cout);
    PROCESS
    BEGIN
        A <= "11110000";
        B <= "10110000";
        S <= "1100";
        Cin <= '0';
        WAIT FOR 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1101";
        Cin <= '0';
        WAIT FOR 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1110";
        Cin <= '0';
        WAIT FOR 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1111";
        Cin <= '1';
        WAIT FOR 10 ns;
        WAIT;
    END PROCESS;
END tb_partD;