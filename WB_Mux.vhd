LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY WB_mux IS
    PORT (
        inPort_data : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        Mem_data_out : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_data_out : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        Ra2_data_out : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        WRB_SEL : in STD_LOGIC_VECTOR(1 DOWNTO 0);
        WRB_data_out : out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END WB_mux;

ARCHITECTURE My_imp_of_WB_mux OF WB_mux IS
BEGIN
    PROCESS(WRB_SEL, inPort_data, Mem_data_out, ALU_data_out, Ra2_data_out)
    BEGIN
        CASE WRB_SEL IS
            WHEN "00" =>
                WRB_data_out <= inPort_data;
            WHEN "01" =>
                WRB_data_out <= Mem_data_out;
            WHEN "10" =>
                WRB_data_out <= ALU_data_out;
            WHEN "11" =>
                WRB_data_out <= Ra2_data_out;
            WHEN OTHERS =>
                WRB_data_out <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END My_imp_of_WB_mux;