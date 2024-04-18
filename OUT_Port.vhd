LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY OUT_Port IS
    PORT (
        reset, enable : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END OUT_Port;

ARCHITECTURE My_Imp_of_OUT_Port OF OUT_Port IS

BEGIN
    PROCESS (reset, enable, data_in)
    BEGIN
        IF (reset = '1') THEN
            data_out <= (OTHERS => '0');
        ELSIF (enable = '1') THEN
            data_out <= data_in;
        END IF;
    END PROCESS;
END My_Imp_of_OUT_Port;