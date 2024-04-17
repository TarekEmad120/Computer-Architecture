LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY register_file IS
GENERIC (
    bits : INTEGER := 32;
    RegNo: INTEGER := 8
    );
PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    data_write : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out1 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out2 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    write_enable : IN STD_LOGIC;
    read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
);

END register_file;

ARCHITECTURE IMP OF register_file IS
    TYPE  reg_array IS ARRAY (0 TO RegNo-1) OF STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    SIGNAL registers : reg_array := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            FOR i IN 0 TO 7 LOOP
            registers(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF clk'EVENT AND clk = '1' THEN
            IF write_enable = '1' THEN
                 registers(to_integer(unsigned(write_address))) <= data_write;
            END IF;
        END IF;
    END PROCESS;
    data_out1 <= registers(TO_INTEGER(UNSIGNED(read_address1)));
    data_out2 <= registers(TO_INTEGER(UNSIGNED(read_address2)));

END IMP;