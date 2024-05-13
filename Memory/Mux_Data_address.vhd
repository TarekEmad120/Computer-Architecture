LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY mux_data_address IS
    PORT (
        alu_data, ra : IN unsigned(11 DOWNTO 0);
        address_out : OUT unsigned(11 DOWNTO 0);
        sel : IN STD_LOGIC
    );
END ENTITY mux_data_address;

ARCHITECTURE mux OF mux_data_address IS
BEGIN
    PROCESS (alu_data, ra, sel) IS
    BEGIN
        CASE sel IS
            WHEN '0' =>
                address_out <= alu_data;
            WHEN '1' =>
                address_out <= ra;
            WHEN OTHERS =>
                address_out <= alu_data;
        END CASE;
    END PROCESS;
END ARCHITECTURE mux;