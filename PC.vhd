--includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

-- A 6-bit counter (PC) that starts at 0 at reset and increments with 1 each 
-- clock cycle. The counter increments only if the enable is set to 1. (Hint: you 
-- can use the ‘+’

ENTITY PC IS
    GENERIC (N : INTEGER := 32);
    PORT (

        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        pc_in : in STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        pc_reset_value : in STD_LOGIC_VECTOR (N - 1 DOWNTO 0); 
        pc_out : out STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        enable : IN STD_LOGIC
    );
END PC;

ARCHITECTURE Behavioral OF PC IS

    
BEGIN

    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            pc_out <= pc_reset_value;
        ELSIF rising_edge(clk) and enable = '1' THEN

        pc_out <=pc_in;

        END IF;
    END PROCESS;


END Behavioral;