LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Mem_WB_reg IS
    PORT (
        clk, reset, enable : IN STD_LOGIC;
        Ra2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rd_address_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WBS_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        WB_EN_in : IN STD_LOGIC;
        In_port_data_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        Ra2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Mem_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rd_address_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WBS_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        WB_EN_out : OUT STD_LOGIC;
        In_port_data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Mem_WB_reg;

ARCHITECTURE My_imp_of_Mem_WB_reg OF Mem_WB_reg IS

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            Ra2_out <= (OTHERS => '0');
            Mem_data_out <= (OTHERS => '0');
            Alu_data_out <= (OTHERS => '0');
            Rd_address_out <= (OTHERS => '0');
            WBS_out <= (OTHERS => '0');
            WB_EN_out <= '0';
            In_port_data_OUT <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                Ra2_out <= Ra2_in;
                Mem_data_out <= Mem_data_in;
                Alu_data_out <= Alu_data_in;
                Rd_address_out <= Rd_address_in;
                WBS_out <= WBS_in;
                WB_EN_out <= WB_EN_in;
                In_port_data_OUT <= In_port_data_In;
            END IF;
        END IF;
    END PROCESS;
END My_imp_of_Mem_WB_reg;