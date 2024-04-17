LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

entity Tt_mini_processor is
end Tt_mini_processor;


architecture Behavioral of Tt_mini_processor is

    component mini_processor IS
        GENERIC (bits : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
            wePC : IN STD_LOGIC := '0';
            weR : IN STD_LOGIC := '0';
            weDD1, weDD2 : IN STD_LOGIC := '0'
        );
    END component;
    component register_file IS
generic ( bits : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_in1 : IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        data_out1 : OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        data_out2 : OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        write_enable : IN STD_LOGIC;
        read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END component;

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    signal data_out : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');
    signal wePC : STD_LOGIC := '0';
    signal weR : STD_LOGIC := '0';
    signal weDD1, weDD2 : STD_LOGIC := '0';


    -- Clock process definitions
    constant clk_period : time := 10 ns;

begin
    
        -- Clock process definitions
        clk_process : process
        begin
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end process;
    
        -- Instantiate the mini_processor
        UUT : mini_processor
        GENERIC MAP (bits => 16)
        PORT MAP (
            clk => clk,
            reset => reset,
            data_in => data_in,
            data_out => data_out,
            wePC => wePC,
            weR => weR,
            weDD1 => weDD1,
            weDD2 => weDD2
        );

        -- Stimulus process
        stim_proc : process
        --reset is  enabled for one clock cycle
        begin
--             writing in register in first 5 places
--             000 010 010 111 0000  0970
-- 111 111 111 111 0000  FFF0
-- 111 111 111 111 0000  FFF0
-- 100 001 010 011 0000  8530
-- 000 100 100 000 0000  1200



    
    end Behavioral;