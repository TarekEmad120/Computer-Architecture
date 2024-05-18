LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MemoryBranch IS
    PORT (
        clk : IN STD_LOGIC;
        signal_br : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        bit_predict : IN STD_LOGIC;
        ZF : IN STD_LOGIC;
        Flush_MEM : OUT STD_LOGIC;
        predicted_out : OUT STD_LOGIC
    );
END MemoryBranch;

ARCHITECTURE IMP OF MemoryBranch IS
    -- SIGNAL signal_br_reg : std_logic_vector(1 downto 0); 
BEGIN
    PROCESS (clk)
    BEGIN
        -- signal_br_reg <= signal_br;
        IF rising_edge(clk) THEN

            CASE signal_br IS
                WHEN "10" =>
                    IF (ZF = NOT bit_predict) THEN
                        Flush_MEM <= '1';
                        predicted_out <= NOT bit_predict;
                    END IF;
                WHEN "11" =>
                    Flush_MEM <= '1';
                WHEN OTHERS =>
                    Flush_MEM <= '0';
            END CASE;
        END IF;
    END PROCESS;
END IMP;