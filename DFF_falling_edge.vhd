LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DFF_falling_edge IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
			enable_write : IN std_logic
			);
END DFF_falling_edge;

ARCHITECTURE a_DFF_falling_edge OF DFF_falling_edge IS
BEGIN
	PROCESS(clk,rst,enable_write)
	BEGIN
		IF(rst = '1') THEN
			q <= '0';
		ELSIF falling_edge(clk)  THEN
		if enable_write = '1' then
			q <= d;
			end if;
		END IF;
	END PROCESS;
END a_DFF_falling_edge;