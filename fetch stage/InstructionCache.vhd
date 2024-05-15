LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

-- the memory modulenis 4k of 16 bit words with 16 bit address

ENTITY InstructionMemory IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF InstructionMemory IS

    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : memory_array;
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN

    instruction_memory : PROCESS (clk, reset, address) IS
        FILE memory_file : text;
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF (RESET = '1') THEN
            -- RAM <= (OTHERS => (OTHERS => '0'));
            data <= (OTHERS => '0');
            INITIAL_FLAG <= '1';
        ELSIF (initial_flag = '1') THEN
            file_open(memory_file, "D:\Arc_project\Computer-Architecture\Instructions.txt", read_mode);
            FOR i IN 0 TO 4095 LOOP
                IF NOT endfile(memory_file) THEN
                    readline(memory_file, file_line);
                    read(file_line, temp_data);
                    ram(i) <= temp_data;
                    -- ELSE
                    --     file_close(memory_file);

                END IF;
            END LOOP;
            initial_flag <= '0';

        ELSE
            data <= ram(to_integer(unsigned(address)));
        END IF;

    END PROCESS instruction_memory;
END ARCHITECTURE;