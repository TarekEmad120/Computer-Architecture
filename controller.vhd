LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        selalu : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : OUT STD_LOGIC;
        write_en : OUT STD_LOGIC
    );

END controller;

ARCHITECTURE Behavioral OF controller IS
BEGIN
    PROCESS (CLK, reset)
    BEGIN
        IF reset = '1' THEN
            selalu <= "0000";
            cin <= '0';
            write_en <= '0';
        ELSE
            IF opcode = "100" THEN
                selalu <= "0101";
                cin <= '0';
                write_en <= '1';
            ELSIF opcode = "000" THEN
                selalu <= "0011";
                cin <= '0';
                write_en <= '1';
            ELSE
                selalu <= "0000";
                cin <= '0';
                write_en <= '0';
            END IF;
        END IF;
        END PROCESS;

    END Behavioral;