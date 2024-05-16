LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY PCmux IS
    PORT (
        PCnext : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_BR_Ra : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_Ret : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_DATA_MEM_BR_COND : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL_COND : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        flushEX : IN STD_LOGIC;
        flushMem : IN STD_LOGIC;
        predicted : IN STD_LOGIC;
        ZF : IN STD_LOGIC;

        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );

END ENTITY PCmux;

ARCHITECTURE mux OF PCmux IS
BEGIN
    PROCESS (PCnext, PC_BR_Ra, PC_Ret, PC_value, flushEX, flushMem, PC_DATA_MEM_BR_COND, SIGNAL_COND)
    BEGIN
        IF ZF = '0' AND predicted = '1' AND SIGNAL_COND = "10" AND flushMem = '1' THEN
            PC <= PC_value;
        ELSIF SIGNAL_COND = "10" AND flushMem = '1' AND flushEX = '0' THEN
            PC <= PC_DATA_MEM_BR_COND;
        ELSIF flushMem = '1'AND flushEX = '0' THEN
            PC <= PC_Ret;
        ELSIF flushEX = '1' AND flushMem = '0' THEN
            PC <= PC_BR_Ra;

        ELSE
            PC <= PCnext;
        END IF;
    END PROCESS;
END ARCHITECTURE mux;