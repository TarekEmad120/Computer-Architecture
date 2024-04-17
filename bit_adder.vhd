LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY bit_adder IS
	PORT (a,b,cin : IN  std_logic;
		  s, cout : OUT std_logic );
END bit_adder;

ARCHITECTURE behavioral OF bit_adder IS
	BEGIN
		
				s <= a XOR b XOR cin;
				cout <= (a AND b) OR (cin AND (a XOR b));
		
END behavioral;