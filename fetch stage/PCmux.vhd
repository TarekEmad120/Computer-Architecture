library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity PCmux is
    port(
        PCnext : in std_logic_vector(31 downto 0);
        PC_BR_Ra: in std_logic_vector(31 downto 0);
        PC_Ret: in std_logic_vector(31 downto 0);
        PC_value: in std_logic_vector(31 downto 0);
        flushEX: in std_logic;
        flushMem: in std_logic;

        PC: out std_logic_vector(31 downto 0)

    );

end entity PCmux;

architecture mux of PCmux is
begin
    process(PCnext, PC_BR_Ra, PC_Ret, PC_value, flushEX, flushMem)
    begin
        if flushEX = '1' and flushMem = '1' then
            PC <= PC_value;
        elsif flushMem = '1'and flushEX = '0' then
            PC <= PC_Ret;
        elsif flushEX = '1' and flushMem = '0' then
            PC <= PC_BR_Ra;

        else
            PC <= PCnext;
        end if;
    end process;
end architecture mux;