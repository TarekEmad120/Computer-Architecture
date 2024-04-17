LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory_Data IS
	PORT (
		Reset,clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(11 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY Memory_Data;

ARCHITECTURE IMP OF Memory_Data IS

	TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL  Memory_Data : ram_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF reset = '1' THEN

				IF rising_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END IMP;
