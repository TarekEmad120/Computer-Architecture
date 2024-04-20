library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;

  -- the memory modulenis 4k of 16 bit words with 16 bit address

entity InstructionMemory is
  port (clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        address : in  STD_LOGIC_VECTOR(11 downto 0);
        data    : out STD_LOGIC_VECTOR(15 downto 0));
end entity;

architecture Behavioral of InstructionMemory is

    TYPE memory_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : memory_array;
    SIGNAL initial_flag : STD_LOGIC := '1';
BEGIN

    instruction_memory : PROCESS (clk,reset,address) IS
        FILE memory_file : text;
        VARIABLE file_line : line;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF (RESET = '1') THEN
            -- RAM <= (OTHERS => (OTHERS => '0'));
            data <= (OTHERS => '0');
            INITIAL_FLAG <= '1';
        ELSIF (initial_flag = '1') THEN
            file_open(memory_file, "D:/Arc_project/Computer-Architecture/Instructions.txt",  read_mode);
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

