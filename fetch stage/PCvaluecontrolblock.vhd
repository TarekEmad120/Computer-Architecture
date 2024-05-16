LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY PCValuecontrolbox IS
    PORT (
        PC_nextInstruc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal_cond : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        PCValue : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY PCValuecontrolbox;

ARCHITECTURE IMP OF PCValuecontrolbox IS
BEGIN
    PROCESS (PC_nextInstruc, signal_cond)
    BEGIN
        CASE signal_cond IS
            WHEN "10" =>
                PCValue <= PC_nextInstruc;
            WHEN OTHERS =>
        END CASE;
    END PROCESS;
END IMP;