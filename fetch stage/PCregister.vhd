library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PCregister is
    port(
        clk : in std_logic;
        reset : in std_logic;
        Interrupt : in std_logic;
        WriteEnable : in std_logic;
        ResetValue, InterruptValue,PCValue: in unsigned(11 downto 0);
        PCout : out unsigned(11 downto 0)
    );
end entity PCregister;

architecture Behavioral of PCregister is
    begin
        process(clk, reset)
        begin
            if reset = '1' then
                PCout <= ResetValue;
            elsif (rising_edge(clk) and WriteEnable = '1') then
                if Interrupt = '1' then
                    PCout <= InterruptValue;
                else
                    PCout <= PCValue;
                end if;
            end if;
        end process;
end architecture Behavioral;