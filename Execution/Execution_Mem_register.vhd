LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Execute_Mememory_Register IS

    PORT (
        clk, reset, enable : IN STD_LOGIC;
        MEM_READ_In, MEM_WRITE_In, WRITE_BACK_In : IN STD_LOGIC;
        WRB_S_In : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Rd_address_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Ra_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        AluOut_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        RA2_DATA_WB_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Push_signal_EX_MEM_IN : IN STD_LOGIC;
        Protect_signal_EX_MEM_IN : IN STD_LOGIC;
        Free_signal_EX_MEM_IN : IN STD_LOGIC;
        STACK_EX_MEM_IN : IN STD_LOGIC;
        Free_P_Enable_IN : IN STD_LOGIC;
        In_port_data_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Signal_br_control_IN : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        RA_1_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        inport_enable_IN : IN STD_LOGIC;
        zf_flag_in : IN STD_LOGIC;
        MEM_READ_Out, MEM_WRITE_Out, WRITE_BACK_Out : OUT STD_LOGIC;
        WRB_S_Out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        Rd_address_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Ra_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        AluOut_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        RA2_DATA_WB_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Push_signal_EX_MEM_OUT : OUT STD_LOGIC;
        Protect_signal_EX_MEM_OUT : OUT STD_LOGIC;
        Free_signal_EX_MEM_OUT : OUT STD_LOGIC;
        STACK_EX_MEM_OUT : OUT STD_LOGIC;
        Free_P_Enable_OUT : OUT STD_LOGIC;
        In_port_data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Signal_br_control_OUT : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        RA_1_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        inport_enable_OUT : OUT STD_LOGIC;
        zf_flag_out : OUT STD_LOGIC

    );
END Execute_Mememory_Register;

ARCHITECTURE IMP OF Execute_Mememory_Register IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            Rd_address_Out <= (OTHERS => '0');
            RA_Out <= (OTHERS => '0');
            AluOut_Out <= (OTHERS => '0');
            MEM_READ_Out <= '0';
            MEM_WRITE_Out <= '0';
            WRITE_BACK_Out <= '0';
            WRB_S_Out <= (OTHERS => '0');
            RA2_DATA_WB_OUT <= (OTHERS => '0');
            Push_signal_EX_MEM_OUT <= '0';
            Protect_signal_EX_MEM_OUT <= '0';
            Free_signal_EX_MEM_OUT <= '0';
            STACK_EX_MEM_OUT <= '0';
            Free_P_Enable_OUT <= '0';
            In_port_data_OUT <= (OTHERS => '0');
            Signal_br_control_OUT <= "00";
            RA_1_OUT <= (OTHERS => '0');
            inport_enable_OUT <= '0';
            zf_flag_out <= '0';
        ELSIF clk'EVENT AND clk = '1' THEN
            IF enable = '1' THEN
                Rd_address_Out <= Rd_address_In;
                RA_Out <= Ra_In;
                AluOut_Out <= AluOut_In;
                MEM_READ_Out <= MEM_READ_In;
                MEM_WRITE_Out <= MEM_WRITE_In;
                WRITE_BACK_Out <= WRITE_BACK_In;
                WRB_S_Out <= WRB_S_In;
                RA2_DATA_WB_OUT <= RA2_DATA_WB_IN;
                Push_signal_EX_MEM_OUT <= Push_signal_EX_MEM_IN;
                Protect_signal_EX_MEM_OUT <= Protect_signal_EX_MEM_IN;
                Free_signal_EX_MEM_OUT <= Free_signal_EX_MEM_IN;
                STACK_EX_MEM_OUT <= STACK_EX_MEM_IN;
                Free_P_Enable_OUT <= Free_P_Enable_IN;
                In_port_data_OUT <= In_port_data_In;
                Signal_br_control_OUT <= Signal_br_control_IN;
                RA_1_OUT <= RA_1_IN;
                inport_enable_OUT <= inport_enable_IN;
                zf_flag_out <= zf_flag_in;
            END IF;
        END IF;
    END PROCESS;

END IMP;