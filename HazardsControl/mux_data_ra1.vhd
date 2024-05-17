LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY mux_data_r1 IS
    PORT (
        data_port, data_execute : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        inPort : IN STD_LOGIC
    );

END ENTITY mux_data_r1;

ARCHITECTURE mux OF mux_data_r1 IS
BEGIN
    PROCESS (data_port, data_execute, inPort) IS
    BEGIN
        CASE inPort IS
            WHEN '0' =>
                data_out <= data_execute;
            WHEN '1' =>
                data_out <= data_port;
            WHEN OTHERS =>
                data_out <= data_execute;
        END CASE;
    END PROCESS;
END ARCHITECTURE mux;