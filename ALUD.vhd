---includes

library IEEE;
use IEEE.std_logic_1164.all;

entity ALUd is
    generic (bits : integer := 16);
    Port ( A : in  STD_LOGIC_VECTOR (bits-1 downto 0);
           B : in  STD_LOGIC_VECTOR (bits-1 downto 0);
           S : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           F : out  STD_LOGIC_VECTOR (bits-1 downto 0);
           Cout : out  STD_LOGIC);
end ALUd;

-- Part D
-- 1 1 0 0 F = Logic shift right A, Cout = shifted bit
-- 1 1 0 1 F = Rotate right A, Cout = rotated bit
-- 1 1 1 0 F = Rotate right A with carry (cin), Cout = rotated bit
-- 1 1 1 1 F = Arithmetic Shift A

architecture partD of ALUd is
    begin
    process (A, B, S, Cin)

    begin
        case S is
            when "1100" =>
            --logic shift right A
                F <= '0' & A(bits-1 downto 1);--shift right
                Cout <= A(0);
            when "1101" =>
            --rotate right A
                F <= A(0) & A(bits-1 downto 1);--rotate right
                Cout <= A(0);
            when "1110" =>
            --rotate right A with carry (cin)
                F <= Cin & A(bits-1 downto 1);--rotate right with carry
                Cout <= A(0);
            when "1111" =>
            --arithmetic shift A
                F <= A(bits-1) & A(bits-1 downto 1);--arithmetic shift
                Cout <= A(0);
            when others =>
                F <= (others => '0');
                Cout <= '0';
        end case;
    end process;
end partD;