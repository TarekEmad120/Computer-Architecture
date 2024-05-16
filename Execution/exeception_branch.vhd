LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ExeceptionBranch IS
    PORT (
        clk : IN STD_LOGIC;
        signal_br : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        bit_predict : IN STD_LOGIC;
        Flush_F : OUT STD_LOGIC
    );
END ExeceptionBranch;

ARCHITECTURE IMP OF ExeceptionBranch IS
    -- SIGNAL signal_br_reg : std_logic_vector(1 downto 0); 
BEGIN
    PROCESS (signal_br, bit_predict)
    BEGIN
        -- IF rising_edge(clk) THEN
        -- signal_br_reg <= signal_br;

        CASE signal_br IS
            WHEN "01" =>
                Flush_F <= '1';
            WHEN "10" =>
                IF (bit_predict = '1') THEN
                    Flush_F <= '1';
                ELSE
                    Flush_F <= '0';
                END IF;
            WHEN OTHERS =>

                Flush_F <= '0';
        END CASE;
        -- END IF;
    END PROCESS;
END IMP;