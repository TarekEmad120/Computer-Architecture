LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY flags IS
    PORT (
        clk : IN STD_LOGIC;
        isJump : IN STD_LOGIC;
        zf_in : IN STD_LOGIC;
        zf_out : OUT STD_LOGIC
    );

END ENTITY flags;

ARCHITECTURE mux OF flags IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            zf_out <= zf_in;
        END IF;
    END PROCESS;
END ARCHITECTURE mux;