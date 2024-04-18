LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

entity IN_Port is
    Port ( 
        
        reset,enable : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0)
        
    );
end IN_Port;

architecture MY_imp_of_IN_Port of IN_Port is

    begin
        process(reset,enable,data_in)
        begin
            if reset = '1' then
                data_out <= (others => '0');
            elsif enable = '1' then
                data_out <= data_in;
            end if;
        end process;
end MY_imp_of_IN_Port;