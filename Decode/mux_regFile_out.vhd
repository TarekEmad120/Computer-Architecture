library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux_regFile_out is
    port(
        ra2, IMM ,Pc  : in  std_logic_vector(31 downto 0);
        ra2_out       : out std_logic_vector(31 downto 0);
        ra2_Sel   : in  std_logic_vector(1 downto 0)
    );
end entity mux_regFile_out;

architecture mux of mux_regFile_out is
begin
    process (ra2, IMM ,Pc,ra2_Sel ) is
        begin
            case ra2_Sel is
                when "00" =>
                    ra2_out <= ra2;
                when "01" =>
                    ra2_out <= IMM;
                when "10" =>
                    ra2_out <= Pc;
                when others =>
                    ra2_out <= (others => '0');
            end case;
        end process;
end architecture mux;