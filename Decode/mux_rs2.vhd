library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux_rs2 is
    port(
        rs2, rd   : in  std_logic_vector(2 downto 0);
        ra2       : out std_logic_vector(2 downto 0);
        rs2_rd    : in  std_logic
    );

end entity mux_rs2;

architecture mux of mux_rs2 is
begin
    process (rs2, rd, rs2_rd) is
        begin
            case rs2_rd is
                when '0' =>
                    ra2 <= rs2;
                when '1' =>
                    ra2 <= rd;
                when others =>
                    ra2 <= (others => 'X');
            end case;
        end process;
end architecture mux;