LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY FetchDecodeReg IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        IntermediateEnable : IN STD_LOGIC;

        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instructionIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        instructionOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY FetchDecodeReg;

ARCHITECTURE FetchDecodeReg_Arch OF FetchDecodeReg IS

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            PC_data <= (OTHERS => '0');
            instructionOut <= (OTHERS => '0');

        ELSIF rising_edge(clk) AND enable = '1' THEN
            IF IntermediateEnable = '1' THEN
                PC_data <= x"00000000";
                instructionOut <= x"0000";
            ELSIF Interrupt = '1' THEN
                --assging pc to pc_data using contactenation
                PC_data <= pc;
                instructionOut <= b"1110_0000_0000_0000";
            ELSE
                PC_data <= pc;
                instructionOut <= instructionIn;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE FetchDecodeReg_Arch;