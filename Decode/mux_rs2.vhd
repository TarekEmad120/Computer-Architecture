LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY mux_rs2 IS
    PORT (
        rs2, rd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ra2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        rs2_rd : IN STD_LOGIC
    );

END ENTITY mux_rs2;

ARCHITECTURE mux OF mux_rs2 IS
BEGIN
    PROCESS (rs2, rd, rs2_rd) IS
    BEGIN
        CASE rs2_rd IS
            WHEN '0' =>
                ra2 <= rs2;
            WHEN '1' =>
                ra2 <= rd;
            WHEN OTHERS =>
                ra2 <= (OTHERS => 'X');
        END CASE;
    END PROCESS;
END ARCHITECTURE mux;