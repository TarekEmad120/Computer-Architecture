library IEEE;
use IEEE.std_logic_1164.all;

entity test_parta is
end test_parta;

architecture test_parta of test_parta is
   component partaAdder IS
    PORT (
        A : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        C_in : IN STD_LOGIC;
        S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        Cout : OUT STD_LOGIC);
END component;

--this is for testing the adderA
signal A : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal B : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal C_in : STD_LOGIC;
signal S : STD_LOGIC_VECTOR (3 DOWNTO 0);
signal result : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal Cout : STD_LOGIC;

begin
    adderA : partaAdder PORT MAP (A, B, C_in, S, result, Cout);

    process
    begin 
        A <= x"0F0F";
        C_in <= '0';
        S <= "0000";

        wait for 10 ns;

        A <= x"0F0F";
        B <= x"0001";
        C_in <= '0';
        S <= "0001";

        wait for 10 ns;

        A <= x"FFFF";
        B <= x"0001";
        C_in <= '0';
        S <= "0010";

        wait for 10 ns;

        A <= x"FFFF";
        C_in <= '0';
        S <= "0011";

        wait for 10 ns;

        A <= x"0F0E";
        B <= x"0001";
        C_in <= '1';
        S <= "0000";

        wait for 10 ns;

        A <= x"FFFF";
        B <= x"0001";
        C_in <= '1';
        S <= "0001";

        wait for 10 ns;

        A <= x"0F0F";
        B <= x"0001";
        C_in <= '1';
        S <= "0010";

        wait for 10 ns;

        A <= x"0F0F";
        B <= x"0001";
        C_in <= '1';
        S <= "0011";

        wait for 10 ns;

        wait;
    end process;

end test_parta;

