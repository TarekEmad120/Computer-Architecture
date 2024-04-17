--includes

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY testmux IS
END testmux;

ARCHITECTURE tb_mux OF testmux IS
    COMPONENT part_BCD IS
        PORT (
            input1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            input2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            selections : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            C_in : IN STD_LOGIC;
            output1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            C_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL input1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL input2 : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL selections : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL C_in : STD_LOGIC;
    SIGNAL output1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL C_out : STD_LOGIC;
BEGIN
    UUT : part_BCD PORT MAP(input1, input2, selections, C_in, output1, C_out);
    PROCESS
    BEGIN
        input1 <= x"0F0F";
        C_in <= '0';
        selections <= "0000";

        WAIT FOR 10 ns;

        input1 <= x"0F0F";
        input2 <= x"0001";
        C_in <= '0';
        selections <= "0001";

        WAIT FOR 10 ns;

        input1 <= x"FFFF";
        input2 <= x"0001";
        C_in <= '0';
        selections <= "0010";

        WAIT FOR 10 ns;

        input1 <= x"FFFF";
        C_in <= '0';
        selections <= "0011";

        WAIT FOR 10 ns;

        input1 <= x"0F0E";
        input2 <= x"0001";
        C_in <= '1';
        selections <= "0000";

        WAIT FOR 10 ns;

        input1 <= x"FFFF";
        input2 <= x"0001";
        C_in <= '1';
        selections <= "0001";

        WAIT FOR 10 ns;

        input1 <= x"0F0F";
        input2 <= x"0001";
        C_in <= '1';
        selections <= "0010";

        WAIT FOR 10 ns;

        input1 <= x"0F0F";
        input2 <= x"0001";
        C_in <= '1';
        selections <= "0011";

        WAIT FOR 10 ns;

        input1 <= "1111000000000000";
        input2 <= "0000000010110000";
        selections <= "0100";
        C_in <= '0';

        WAIT FOR 10 ns;
        input1 <= "1111000000000000";
        input2 <= "0000000000001011";
        selections <= "0101";
        C_in <= '0';

        WAIT FOR 10 ns;
        input1 <= "1111000000000000";
        input2 <= "1011000000000000";
        selections <= "0110";
        C_in <= '0';

        WAIT FOR 10 ns;
        input1 <= "1111000000000000";
        input2 <= "0000000000000000";
        selections <= "0111";
        C_in <= '0';

        WAIT FOR 10 ns;
        --input1 = A00A
        input1 <= x"A00A";
        input2 <= x"0000";
        selections <= "1000";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"000A";
        input2 <= x"0000";
        selections <= "1000";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"B00C";
        input2 <= x"0000";
        selections <= "1001";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"000C";
        input2 <= x"0000";
        selections <= "1001";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"A00A";
        input2 <= x"0000";
        selections <= "1010";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"A00A";
        input2 <= x"0000";
        selections <= "1010";
        C_in <= '1';
        WAIT FOR 10 ns;

        input1 <= x"A00A";
        input2 <= x"0000";
        selections <= "1011";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"000F";
        input2 <= x"0000";
        selections <= "1100";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"0F0F";
        input2 <= x"0000";
        selections <= "1101";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"0F0F";
        input2 <= x"0000";
        selections <= "1110";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"F000";
        input2 <= x"0000";
        selections <= "1111";
        C_in <= '0';
        WAIT FOR 10 ns;

        input1 <= x"0F00";
        input2 <= x"0000";
        selections <= "1110";
        C_in <= '1';
        WAIT FOR 10 ns;

        WAIT;
    END PROCESS;

END ARCHITECTURE tb_mux;