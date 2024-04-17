-- this is testbecnch for lab1 partC

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbenchC is
end testbenchC;

architecture tb_partC of testbenchC is
    component ALUc is
        Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
               B : in  STD_LOGIC_VECTOR (7 downto 0);
               S : in  STD_LOGIC_VECTOR (3 downto 0);
               Cin : in  STD_LOGIC;
               F : out  STD_LOGIC_VECTOR (7 downto 0);
               Cout : out  STD_LOGIC);
    end component;
    signal A, B, F : STD_LOGIC_VECTOR (7 downto 0);
    signal S : STD_LOGIC_VECTOR (3 downto 0);
    signal Cin, Cout : STD_LOGIC;
begin

-- Part C
-- 1 0 0 0 F = Logic shift left A, Cout = shifted bit
-- 1 0 0 1 F = Rotate left A, Cout = rotated bit
-- 1 0 1 0 F = Rotate Left A with carry (cin), Cout = rotated bit
-- 1 0 1 1 F = 0000, Cout = 0

    UUT: ALUc port map (A, B, S, Cin, F, Cout);
    process
    begin
        A <= "11110000";
        B <= "10110000";
        S <= "1000";
        Cin <= '0';
        wait for 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1001";
        Cin <= '0';
        wait for 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1010";
        Cin <= '0';
        wait for 10 ns;
        A <= "11110000";
        B <= "00000000";
        S <= "1011";
        Cin <= '0';
        wait for 10 ns;
        wait;
    end process;
end tb_partC;


