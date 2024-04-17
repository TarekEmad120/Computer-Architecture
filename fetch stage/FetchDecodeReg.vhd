library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity FetchDecodeReg is
    port (
        clk : in std_logic;
        reset : in std_logic;
        Interrupt : in std_logic;
        IntermediateEnable : in std_logic;

        pc : in std_logic_vector(31 downto 0);
        instructionIn : in std_logic_vector(15 downto 0);
    
        instructionOut: out std_logic_vector(15 downto 0);
        PC_data : out std_logic_vector(31 downto 0);
        Interruptflag : out std_logic
    );
end entity FetchDecodeReg;

architecture FetchDecodeReg_Arch of FetchDecodeReg is


    begin
        process(clk, reset)
        begin
            if reset = '1' then
                PC_data <= (others => '0');
                instructionOut <= (others => '0');
                Interruptflag <= '0';
            elsif rising_edge(clk) then
                if IntermediateEnable = '1' then
                    PC_data <= x"00000000";
                    instructionOut <= x"0000" ;
                    Interruptflag <= '0';

                elsif Interrupt = '1' then
                    --assging pc to pc_data using contactenation
                    PC_data <=pc;
                    instructionOut <= b"1110_0000_0000_0000";
                    Interruptflag <= '1';
                else
                    PC_data <=pc;
                    instructionOut <= instructionIn;
                    Interruptflag <= '0';
                end if;
            end if;
        end process;
end architecture FetchDecodeReg_Arch;