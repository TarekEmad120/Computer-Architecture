library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux_source_alu1 is
    port(
        RA,SRC_DATA_EXE,SRC_DATA_MEM   : in  std_logic_vector(31 downto 0);
        DATA_OUT_TO_ALU     : out std_logic_vector(31 downto 0);
        ForwardUnit_sel    : in  std_logic_vector (1 DOWNTO 0)
    );
end entity mux_source_alu1;

architecture mux of mux_source_alu1 is
begin
    process (SRC_DATA_MEM,RA, SRC_DATA_EXE, ForwardUnit_sel) is
        begin
            case ForwardUnit_sel is
                when "00" =>
                    DATA_OUT_TO_ALU <= RA;
                when "01" =>
                    DATA_OUT_TO_ALU <= SRC_DATA_EXE;
                when "10" =>
                    DATA_OUT_TO_ALU <=SRC_DATA_MEM;
                when others =>
                    DATA_OUT_TO_ALU <= RA;
            end case;
        end process;
end architecture mux;