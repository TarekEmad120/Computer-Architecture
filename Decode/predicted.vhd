LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY predictedBit IS
    PORT (
        clk, reset : IN STD_LOGIC;
        predicted_in : IN STD_LOGIC;
        predicted_out : OUT STD_LOGIC

    );
END ENTITY predictedBit;

ARCHITECTURE mux OF predictedBit IS
BEGIN
    PROCESS (clk, reset) IS
    BEGIN
        IF reset = '1' THEN
            predicted_out <= '1';
        ELSIF clk'EVENT AND clk = '1'THEN
            predicted_out <= predicted_in;
        END IF;
    END PROCESS;
END ARCHITECTURE mux;