LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY Decode_Execute IS

PORT (
    clk,reset,enable : IN STD_LOGIC;
    dataIn1,dataIn2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
    func_in: IN STD_LOGIC_VECTOR(2 DOWNTO 0); --
    alu_control_in: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --
    RA_In:In STD_LOGIC_VECTOR(31 DOWNTO 0); --
    RD_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0); --
    RS1_In,RS2_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- to forward unit

    RA_OUT:OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    alu_control_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --
    func_out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    dataOut1,dataOut2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    RD_Out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
    RS1_out,RS2_out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);

END Decode_Execute;

ARCHITECTURE IMP OF Decode_Execute IS

    
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            RD_Out<= (OTHERS => '0');
            func_out<= (OTHERS => '0');
            alu_control_out<= (OTHERS => '0');
            dataOut1<= (OTHERS => '0');
            dataOut2<= (OTHERS => '0');
            RA_OUT<= (OTHERS => '0');
            RS1_out<= (OTHERS => '0');
            RS2_out<= (OTHERS => '0');
        ELSIF clk'EVENT AND clk = '1' THEN
            IF enable = '1' THEN
              RD_Out<=RD_In;
              func_out<=func_in;
              alu_control_out<=alu_control_in;
              dataOut1 <= dataIn1;
              dataOut2 <= dataIn2;
              RA_OUT<=RA_IN;
              RS1_out<=RS1_In;
              RS2_out<=RS2_In; 
            END IF;
        END IF;
    END PROCESS;
  
END IMP;