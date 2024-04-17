
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decode_excute IS
	GENERIC ( n : integer := 16);
	PORT(	Clk,Rst : IN std_logic;
		data : IN std_logic_vector(n-1 DOWNTO 0);
        controlin : IN std_logic_vector(3 DOWNTO 0);
		outp : OUT std_logic_vector(n-1 DOWNTO 0);
        contolout : out std_logic_vector(3 DOWNTO 0);
		en_write : IN std_logic
		);
END decode_excute;

ARCHITECTURE decode_excute OF decode_excute IS
	COMPONENT my_DFF IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
			enable_write : IN std_logic
			);
	END COMPONENT;
BEGIN
loop1: FOR i IN 0 TO n-1 GENERATE
fx: my_DFF PORT MAP
    (
        d => data(i),
        clk => Clk,
        rst => Rst,
        q => outp(i),
        enable_write => en_write
    );
END GENERATE;

END decode_excute;
