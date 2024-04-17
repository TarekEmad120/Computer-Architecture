-- this is testbecnch for lab1 partB

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
end testbench;  

architecture tb_partB of testbench is
    component ALU is
        Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
               B : in  STD_LOGIC_VECTOR (15 downto 0);
               S : in  STD_LOGIC_VECTOR (3 downto 0);
               Cin : in  STD_LOGIC;
               F : out  STD_LOGIC_VECTOR (15 downto 0);
               Cout : out  STD_LOGIC);
    end component;
    signal A, B, F : STD_LOGIC_VECTOR (15 downto 0);
    signal S : STD_LOGIC_VECTOR (3 downto 0);
    signal Cin, Cout : STD_LOGIC;
begin
    -- Part B
-- 0 1 0 0 F = A xor B, Cout = 0
-- 0 1 0 1 F = A nand B, Cout = 0
-- 0 1 1 0 F = A or B, Cout = 0
-- 0 1 1 1 F = Not A, Cout = 0

    UUT: ALU port map (A, B, S, Cin, F, Cout);
    process
    begin
        A <= "1111000000000000";
        B <= "0000000010110000";
        S <= "0100";
        Cin <= '0';
    
        wait for 10 ns;
        A <= "1111000000000000";
        B <= "0000000000001011";
        S <= "0101";
        Cin <= '0';
      
        wait for 10 ns;
        A <= "1111000000000000";
        B <= "1011000000000000";
        S <= "0110";
        Cin <= '0';
        
        wait for 10 ns;
        A <= "1111000000000000";
        B <= "0000000000000000";
        S <= "0111";
        Cin <= '0';
       
        wait for 10 ns;
        wait;
    end process;
end tb_partB;