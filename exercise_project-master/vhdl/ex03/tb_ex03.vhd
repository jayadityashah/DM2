library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity tb_ex03 is
end entity tb_ex03;

architecture Behavioral of tb_ex03 is
    constant N : integer := 8;
    
    -- Signals for inputs common to both adders
    signal A, B : STD_LOGIC_VECTOR(N-1 downto 0);
    
    -- DUT1: Structural (Ripple-Carry with full adders)
    signal S1 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal CO1: STD_LOGIC;
    
    -- DUT2: Process-based adder (NbitFA) with a CI port now connected to '0'
    signal S2 : STD_LOGIC_VECTOR(N-1 downto 0);
    signal CO2: STD_LOGIC;
    
begin
    -- Instantiate DUT1 (structural adder)
    DUT1: entity work.RippleCarryAdder_Nbit
        Generic map (N => N)
        Port map (
            A  => A,
            B  => B,
            S  => S1,
            CO => CO1
        );
    
    -- Instantiate DUT2 (process-based adder), tying CI to '0'
    DUT2: entity work.NbitFA
        Generic map (N => N)
        Port map (
            A  => A,
            B  => B,
            CI => '0',   -- tie carry-in to '0'
            S  => S2,
            CO => CO2
        );
    
    -- Testbench process: read inputs from CSV, drive DUTs, and write outputs to CSV.
    process
        file input_file  : text open read_mode is "input.txt";
        file output_file : text open write_mode is "output.txt";
        variable L         : line;
        variable out_line  : line;
        variable a_int, b_int : integer;
        variable comma     : character;
    begin
        while not endfile(input_file) loop
            -- Read one line from the input file
            readline(input_file, L);
            -- Read first integer value (A)
            read(L, a_int);
            -- Read the separating comma (assumed to be present)
            read(L, comma);
            -- Read second integer value (B)
            read(L, b_int);
            
            -- Apply the input values (convert integer to 8-bit std_logic_vector)
            A <= std_logic_vector(to_unsigned(a_int, N));
            B <= std_logic_vector(to_unsigned(b_int, N));
            
            wait for 10 ns;  -- Wait 10 ns for the adders to process the inputs
            
            -- Reset out_line for a new output (allocate a new empty string)
            out_line := new string'("");
            -- Prepare output line in CSV format: A,B,S1,CO1,S2,CO2
            write(out_line, integer'image(a_int));
            write(out_line, string'(","));  -- write comma as string literal
            write(out_line, integer'image(b_int));
            write(out_line, string'(","));
            write(out_line, integer'image(to_integer(unsigned(S1))));
            write(out_line, string'(","));
            write(out_line, std_logic'image(CO1));
            write(out_line, string'(","));
            write(out_line, integer'image(to_integer(unsigned(S2))));
            write(out_line, string'(","));
            write(out_line, std_logic'image(CO2));
            writeline(output_file, out_line);
        end loop;
        wait;
    end process;
    
end architecture Behavioral;






