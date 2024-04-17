LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity Mem_WB_reg is
    Port ( 
        clk,reset,enable : in STD_LOGIC;
        
        Ra2_in : in STD_LOGIC_VECTOR(31 downto 0);
        Mem_data_in : in STD_LOGIC_VECTOR(31 downto 0);
        Alu_data_in : in STD_LOGIC_VECTOR(31 downto 0);
        Rd_address_in : in STD_LOGIC_VECTOR(2 downto 0);
        WBS_in : in STD_LOGIC_VECTOR(1 downto 0);
        WB_EN_in : in STD_LOGIC;

        Ra2_out : out STD_LOGIC_VECTOR(31 downto 0);
        Mem_data_out : out STD_LOGIC_VECTOR(31 downto 0);
        Alu_data_out : out STD_LOGIC_VECTOR(31 downto 0);
        Rd_address_out : out STD_LOGIC_VECTOR(2 downto 0);
        WBS_out : out STD_LOGIC_VECTOR(1 downto 0);
        WB_EN_out : out STD_LOGIC     
    );
end Mem_WB_reg;

architecture My_imp_of_Mem_WB_reg of Mem_WB_reg is

    begin
        process(clk,reset)
        begin
            if reset = '1' then
                Ra2_out <= (others => '0');
                Mem_data_out <= (others => '0');
                Alu_data_out <= (others => '0');
                Rd_address_out <= (others => '0');
                WBS_out <= (others => '0');
                WB_EN_out <= '0';
            elsif rising_edge(clk) then
                if enable = '1' then
                    Ra2_out <= Ra2_in;
                    Mem_data_out <= Mem_data_in;
                    Alu_data_out <= Alu_data_in;
                    Rd_address_out <= Rd_address_in;
                    WBS_out <= WBS_in;
                    WB_EN_out <= WB_EN_in;
                end if;
            end if;
        end process;
end My_imp_of_Mem_WB_reg;