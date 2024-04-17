LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY n_bit_adder IS
    generic (n: integer := 4);
	PORT (a,b : IN  std_logic_vector(n-1 downto 0);
          cin : in std_logic;
		  s : out std_logic_vector(n-1 downto 0);
           cout : OUT std_logic );
END n_bit_adder;

ARCHITECTURE a_n_bit_adder OF n_bit_adder IS
component my_adder IS
	PORT (a,b,cin : IN  std_logic;
		  s, cout : OUT std_logic );
END component;

    signal temp : std_logic_vector( n downto 0);
	BEGIN
		
		temp(0) <= cin;
        loop1: for i in 0 to n-1 generate
            fx:my_adder port map(a(i),b(i),temp(i),s(i),temp(i+1));
        end generate;
		cout <= temp(n);
END a_n_bit_adder;