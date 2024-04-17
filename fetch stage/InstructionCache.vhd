LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;



-- the memory modulenis 4k of 16 bit words with 16 bit address
entity InstructionMemory is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           address : in  STD_LOGIC_VECTOR (11 downto 0);
           data : out  STD_LOGIC_VECTOR (15 downto 0));
end InstructionMemory;

architecture Behavioral of InstructionMemory is

type memory is array (0 to 4095) of std_logic_vector(15 downto 0);
signal ram : memory;

begin

process(clk, reset)
    file file_handle : text open read_mode is "F:\Computer Archectiture\project\Computer-Architecture\Instructions.txt";
    variable line : line;
    variable value : std_logic_vector(15 downto 0);
    variable address : integer;
    variable i : integer;
    begin
        if reset = '1' then
            for i in 0 to 4095 loop
                ram(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if endfile(file_handle) then
                file_close(file_handle);
                file_open(file_handle, "C:/Users/Owner/Desktop/Computer Architecture Project/Instructions.txt");
            end if;
            readline(file_handle, line);
            read(line, value);
            read(line, address);
            ram(address) <= value;
        end if;
    end process;


    data <= ram(conv_integer(address));

end Behavioral;

