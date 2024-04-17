
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_ram IS
    PORT (
        clk : IN STD_LOGIC;
        rest : IN STD_LOGIC;
        we1 : IN STD_LOGIC;
        we2 : IN STD_LOGIC;
        readaddress1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        readaddress2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        writeaddress1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        writeaddress2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        data_in1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_out1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_out2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END register_ram;

ARCHITECTURE register_ram OF register_ram IS
    TYPE ram_type IS ARRAY (0 to 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN

    PROCESS (clk, rest)
    BEGIN
        IF rest = '1' THEN
            FOR i IN 0 TO 63 LOOP
                ram(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF clk'EVENT AND clk = '1' THEN
            IF we1 = '1' THEN
                ram(to_integer(unsigned(writeaddress1))) <= data_in1;
            END IF;
            IF we2 = '1' THEN
                ram(TO_INTEGER(UNSIGNED(writeaddress2))) <= data_in2;
            END IF;
        END IF;
    END PROCESS;

    data_out1 <= ram(TO_INTEGER(UNSIGNED(readaddress1)));
    data_out2 <= ram(TO_INTEGER(UNSIGNED(readaddress2)));


END register_ram;