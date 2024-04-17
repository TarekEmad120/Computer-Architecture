-- ● A register file which contains 7 registers, each register has 12-bits widths. 
-- The register file has:
-- o 2-read addresses and 2-write address.
-- o 2-read ports and 2-write port. 
-- o write enables and reset signal. 
-- (What is the size of address bus? What is the size of data bus?)
-- ● Use the given registers (DFF) to create the register files.

--includes
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

--entity
--entity
ENTITY register_12bits IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_in1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_out1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_out2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        write_enable : IN STD_LOGIC;
        read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END register_12bits;

ARCHITECTURE Behavioral OF register_12bits IS
    COMPONENT my_nDFF IS
        GENERIC (n : INTEGER := 12);
        PORT (
            Clk, Rst : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            en_write : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL we0, we1, we2, we3, we4, we5, we6 : STD_LOGIC;
    SIGNAL d0, d1, d2, d3, d4, d5, d6 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL q0, q1, q2, q3, q4, q5, q6 : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN
    registerA : my_nDFF PORT MAP(clk, reset, d0, q0, we0);
    registerB : my_nDFF PORT MAP(clk, reset, d1, q1, we1);
    registerC : my_nDFF PORT MAP(clk, reset, d2, q2, we2);
    registerD : my_nDFF PORT MAP(clk, reset, d3, q3, we3);
    registerE : my_nDFF PORT MAP(clk, reset, d4, q4, we4);
    registerF : my_nDFF PORT MAP(clk, reset, d5, q5, we5);
    registerG : my_nDFF PORT MAP(clk, reset, d6, q6, we6);

    we0 <= write_enable WHEN write_address1 = "000" OR write_address2 = "000" ELSE
        '0';
    we1 <= write_enable WHEN write_address1 = "001" OR write_address2 = "001" ELSE
        '0';
    we2 <= write_enable WHEN write_address1 = "010" OR write_address2 = "010" ELSE
        '0';
    we3 <= write_enable WHEN write_address1 = "011" OR write_address2 = "011" ELSE
        '0';
    we4 <= write_enable WHEN write_address1 = "100" OR write_address2 = "100" ELSE
        '0';
    we5 <= write_enable WHEN write_address1 = "101" OR write_address2 = "101" ELSE
        '0';
    we6 <= write_enable WHEN write_address1 = "110" OR write_address2 = "110" ELSE
        '0';

    d0 <= data_in1 WHEN write_address1 = "000" ELSE
        data_in2 WHEN write_address2 = "000" ELSE
        data_in1 ;
    d1 <= data_in1 WHEN write_address1 = "001" ELSE
        data_in2 WHEN write_address2 = "001" ELSE
        data_in1;
    d2 <= data_in1 WHEN write_address1 = "010" ELSE
        data_in2 WHEN write_address2 = "010" ELSE
        data_in1;
    d3 <= data_in1 WHEN write_address1 = "011" ELSE
        data_in2 WHEN write_address2 = "011" ELSE
        data_in1;
    d4 <= data_in1 WHEN write_address1 = "100" ELSE
        data_in2 WHEN write_address2 = "100" ELSE
        data_in1;
    d5 <= data_in1 WHEN write_address1 = "101" ELSE
        data_in2 WHEN write_address2 = "101" ELSE
        data_in1;
    d6 <= data_in1 WHEN write_address1 = "110" ELSE
        data_in2 WHEN write_address2 = "110" ELSE
        data_in1;

    data_out1 <= q0 WHEN read_address1 = "000" ELSE
        q1 WHEN read_address1 = "001" ELSE
        q2 WHEN read_address1 = "010" ELSE
        q3 WHEN read_address1 = "011" ELSE
        q4 WHEN read_address1 = "100" ELSE
        q5 WHEN read_address1 = "101" ELSE
        q6 WHEN read_address1 = "110" ELSE
        (OTHERS => '0');
    data_out2 <= q0 WHEN read_address2 = "000" ELSE
        q1 WHEN read_address2 = "001" ELSE
        q2 WHEN read_address2 = "010" ELSE
        q3 WHEN read_address2 = "011" ELSE
        q4 WHEN read_address2 = "100" ELSE
        q5 WHEN read_address2 = "101" ELSE
        q6 WHEN read_address2 = "110" ELSE
        (OTHERS => '0');



END Behavioral;