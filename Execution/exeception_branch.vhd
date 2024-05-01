LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ExeceptionBranch IS
    PORT (
        clk: IN std_logic;
        signal_br: IN std_logic_vector (1 downto 0);
        bit_predict: IN std_logic;
        Flush_F : OUT std_logic
    );
END ExeceptionBranch;

ARCHITECTURE IMP OF ExeceptionBranch IS
    -- SIGNAL signal_br_reg : std_logic_vector(1 downto 0); 
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN 
            -- signal_br_reg <= signal_br;
            
            CASE signal_br IS
                WHEN "01" =>
                    Flush_F <= '1';
                WHEN "00" =>
                    Flush_F <= '0';
                WHEN OTHERS =>
                   
                    Flush_F <= '0'; 
            END CASE;
        END IF;
    END PROCESS;
END IMP;
