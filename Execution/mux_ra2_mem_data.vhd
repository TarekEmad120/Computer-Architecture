LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY mux_ra2_data_mem IS
    PORT (
        ra2_forwarderd, ra2_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ra2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        sel : IN STD_LOGIC
    );

END ENTITY mux_ra2_data_mem;

ARCHITECTURE mux OF mux_ra2_data_mem IS
BEGIN
    PROCESS (ra2_forwarderd, ra2_alu, sel) IS
    BEGIN
        CASE sel IS
            WHEN '0' =>
                ra2_out <= ra2_forwarderd;
            WHEN '1' =>
                ra2_out <= ra2_alu;
            WHEN OTHERS =>
                ra2_out <= ra2_forwarderd;
        END CASE;
    END PROCESS;
END ARCHITECTURE mux;