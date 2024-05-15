LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY hazarddectionunit IS
    PORT (
        oldRD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        currentRS1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        currentRS2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEMRead : IN STD_LOGIC;
        WriteBack : IN STD_LOGIC;
        stall : OUT STD_LOGIC
    );

END hazarddectionunit;

ARCHITECTURE Behavioral OF hazarddectionunit IS
BEGIN
    PROCESS (oldRD, currentRS1, currentRS2, MEMRead, WriteBack)
    BEGIN
        IF (MEMRead = '1' AND WriteBack = '1' AND (oldRD = currentRS1 OR oldRD = currentRS2)) THEN
            stall <= '1';
        ELSE
            stall <= '1';
        END IF;
    END PROCESS;
END Behavioral;