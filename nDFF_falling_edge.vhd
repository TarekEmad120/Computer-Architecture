LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY nDFF_falling_edge IS
	GENERIC ( n : integer := 16);
	PORT(	Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0);
		en_write : IN std_logic
		);
END nDFF_falling_edge;

ARCHITECTURE a_nDFF_falling_edge OF nDFF_falling_edge IS
	COMPONENT DFF_falling_edge IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
			enable_write : IN std_logic
			);
	END COMPONENT;
BEGIN
	loop1: FOR i IN 0 TO n-1 GENERATE
	fx: DFF_falling_edge PORT MAP(d(i),Clk,Rst,q(i),en_write);
END GENERATE;

END a_nDFF_falling_edge;
