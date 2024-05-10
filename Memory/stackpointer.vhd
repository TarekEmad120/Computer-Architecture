library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity stackpointer is
    port(
        clk : in std_logic;
        reset : in std_logic;
        push_pop : in std_logic;
        enable : in std_logic;
        stackpointer : out unsigned (31 downto 0)
    );
end entity stackpointer;

architecture rtl of stackpointer is
    signal stackpointer_reg : unsigned (31 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            stackpointer_reg <= (others => '0');
        elsif falling_edge(clk) then
            if enable = '1' then
                if push_pop = '0' then
                    stackpointer_reg <= stackpointer_reg - 2;
                else
                    stackpointer_reg <= stackpointer_reg + 2;
                end if;
            end if;
        end if;
    end process;

    stackpointer <= stackpointer_reg;
end architecture rtl;