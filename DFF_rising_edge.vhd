LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DFF_rising_edge IS
	PORT( 	d,clk,rst : IN std_logic;
			q : OUT std_logic;
			enable_write : IN std_logic
			);
END DFF_rising_edge;

ARCHITECTURE a_DFF_rising_edge OF DFF_rising_edge IS
BEGIN
	PROCESS(clk,rst,enable_write)
	BEGIN
		IF(rst = '1') THEN
			q <= '0';
		ELSIF rising_edge(clk)  THEN
		if enable_write = '1' then
			q <= d;
			end if;
		END IF;
	END PROCESS;
END a_DFF_rising_edge;