 --includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;




ENTITY processor IS
    GENERIC (N : INTEGER := 6);
    PORT (
    );
END processor;



ARCHITECTURE behavioral OF processor IS

component PC IS
    GENERIC (N : INTEGER := 6);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        PC : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0));
end component;







begin

    program_counter: PC 




end architecture behavioral;