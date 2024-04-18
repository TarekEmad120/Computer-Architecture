library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux_rs1 is
    port(
        rs1, rd   : in  std_logic_vector(2 downto 0);
        ra1       : out std_logic_vector(2 downto 0);
        rs1_rd    : in  std_logic
    );
end entity mux_rs1;

architecture mux of mux_rs1 is
begin
    process (rs1, rd, rs1_rd) is
        begin
            case rs1_rd is
                when "0" =>
                    ra1 <= rs1;
                when "1" =>
                    ra1 <= rd;
                when others =>
                    ra1 <= (others => 'X');
            end case;
        end process;
end architecture mux;