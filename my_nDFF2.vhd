LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY my_nDFF2 IS
	GENERIC ( n : integer := 16);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
		en_write : IN std_logic
		);
END my_nDFF2;

ARCHITECTURE b_my_nDFF2 OF my_nDFF2 IS
	COMPONENT my_DFF2 IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
			enable_write : IN std_logic
			);
	END COMPONENT;
BEGIN
	loop1: FOR i IN 0 TO n-1 GENERATE
	fx: my_DFF2 PORT MAP(d(i),Clk,Rst,q(i),en_write);
END GENERATE;

END b_my_nDFF2;
