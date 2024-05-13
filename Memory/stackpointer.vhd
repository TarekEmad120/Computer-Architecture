LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY stackpointer IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        push_pop : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        stackpointer : OUT unsigned (31 DOWNTO 0)
    );
END ENTITY stackpointer;

ARCHITECTURE rtl OF stackpointer IS
    SIGNAL stackpointer_reg : unsigned (31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            stackpointer_reg <= "00000000000000000000000000000011";
        ELSIF falling_edge(clk) THEN
            IF enable = '1' THEN
                IF push_pop = '0' THEN
                    stackpointer_reg <= stackpointer_reg - 2;
                ELSE
                    stackpointer_reg <= stackpointer_reg + 2;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    stackpointer <= stackpointer_reg;
END ARCHITECTURE rtl;