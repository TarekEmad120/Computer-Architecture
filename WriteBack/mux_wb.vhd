library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux_WB is
    port(
        InPortData,Mem_data,Alu_Data,RA2 : in  std_logic_vector(31 downto 0);
        DataWriteBack       : out std_logic_vector(31 downto 0);
        WBW_s    : in  std_logic_vector(1 downto 0)
    );

end entity mux_WB;

architecture mux of mux_WB is
begin
    process (InPortData,Mem_data,Alu_Data,RA2,WBW_s) is
        begin
            case WBW_s is
                when "00" =>
                DataWriteBack <= InPortData;
                when "01" =>
                DataWriteBack <= Mem_data;
                when "10" =>
                DataWriteBack <= Alu_Data;
                when "11" =>
                DataWriteBack <= RA2;
                When others =>
                DataWriteBack <= (others => 'X');
            end case;
        end process;
end architecture mux;