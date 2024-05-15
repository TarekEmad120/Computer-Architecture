library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity hazarddectionunit is
    port (
        oldRD: in std_logic_vector(2 downto 0);
        currentRS1: in std_logic_vector(2 downto 0);
        currentRS2: in std_logic_vector(2 downto 0);
        MEMRead: in std_logic;
        MEMWrite: in std_logic;
        stall: out std_logic
    );

end hazarddectionunit;

architecture Behavioral of hazarddectionunit is
begin
    process(oldRD, currentRS1, currentRS2, MEMRead, MEMWrite)
    begin
        if (MEMRead ='1' and MEMWrite = '1' and (oldRD = currentRS1 or oldRD = currentRS2)) then
            stall <= '1';
        else
            stall <= '0';
        end if;
    end process;
end Behavioral;