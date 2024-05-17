LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY ICU IS

    PORT (
        clk : IN STD_LOGIC;
        isInterrupt : IN STD_LOGIC;
        interrupt_stall : OUT STD_LOGIC
    );

END ICU;

ARCHITECTURE IMP OF ICU IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF isInterrupt = '1' THEN
                interrupt_stall <= '1';
            ELSE
                interrupt_stall <= '0';
            END IF;
        END IF;
    END PROCESS;

END IMP;