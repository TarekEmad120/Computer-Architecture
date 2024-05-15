library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity input is
    port (
        enable : in std_logic;
        reset : in std_logic;
        datain: in std_logic_vector(31 downto 0);
        dataout: out std_logic_vector(31 downto 0)
    );
end entity input;

architecture rtl of input is
    signal dataout_in : std_logic_vector(31 downto 0);
    begin
        process(enable, reset, datain)
        begin
            if reset = '1' then
                dataout_in <= (others => '0');
            elsif enable = '1' then
                dataout_in <= datain;
            end if;
        end process;
        dataout <= dataout_in;
end architecture rtl;
