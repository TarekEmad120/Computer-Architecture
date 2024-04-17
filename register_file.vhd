-- ● A register file which contains 7 registers, each register has 12-bits widths. 
-- The register file has:
-- o 2-read addresses and 2-write address.
-- o 2-read ports and 2-write port. 
-- o write enables and reset signal. 
-- (What is the size of address bus? What is the size of data bus?)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY register_file IS
GENERIC (bits : INTEGER := 16);
PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    data_in1 : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_in2 : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out1 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out2 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    write_enable : IN STD_LOGIC;
    read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
);

END register_file;

ARCHITECTURE register_ram OF register_file IS
    TYPE ram_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN

    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            FOR i IN 0 TO 7 LOOP
                ram(i) <= (OTHERS => '0');
            END LOOP;
        ELSIF clk'EVENT AND clk = '1' THEN
            IF write_enable = '1' THEN
                ram(to_integer(unsigned(write_address1))) <= data_in1;
                ram(TO_INTEGER(UNSIGNED(write_address2))) <= data_in2;
            END IF;
        END IF;
    END PROCESS;

    data_out1 <= ram(TO_INTEGER(UNSIGNED(read_address1)));
    data_out2 <= ram(TO_INTEGER(UNSIGNED(read_address2)));


END register_ram;