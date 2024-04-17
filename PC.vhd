--includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

-- A 6-bit counter (PC) that starts at 0 at reset and increments with 1 each 
-- clock cycle. The counter increments only if the enable is set to 1. (Hint: you 
-- can use the ‘+’

ENTITY counter IS
    GENERIC (N : INTEGER := 6);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        PC : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0));
END counter;

ARCHITECTURE Behavioral OF counter IS

    
BEGIN

    PROCESS (clk, reset)
    VARIABLE COUNT_TEMP : INTEGER := 0;
    BEGIN
        IF reset = '1' THEN
            COUNT_TEMP := 0;
            PC <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            --check if enable is set to 1 and pc is not at max value
            IF enable = '1' THEN
                IF COUNT_TEMP < 2 ** N - 1 THEN
                    COUNT_TEMP := COUNT_TEMP + 1;
                ELSE
                    COUNT_TEMP := 0;
                END IF;

            END IF;
        END IF;
        PC <= STD_LOGIC_VECTOR(TO_UNSIGNED(COUNT_TEMP, N));
    END PROCESS;


END Behavioral;