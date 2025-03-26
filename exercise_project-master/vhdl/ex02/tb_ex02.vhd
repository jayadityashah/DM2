-- tb_ex02.vhd
-- Testbench for multiplexer with correct bit_vector file I/O

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;  -- Required for reading bit_vectors correctly

entity tb_ex02 is
end tb_ex02;

architecture behavioral of tb_ex02 is

  -- Signals
  signal A, B, Q : bit_vector(7 downto 0);
  signal S : bit;
  
  -- Component Declaration
  component multiplexer
    port (
      A : in bit_vector(7 downto 0);
      B : in bit_vector(7 downto 0);
      S : in bit;
      Q : out bit_vector(7 downto 0)
    );
  end component;

  -- File I/O Declarations
  file input_file : text open read_mode is "../../assets/ex02/input.txt";
  file output_file : text open write_mode is "../../assets/ex02/output.txt";

begin

  -- Instantiate the multiplexer
  UUT: multiplexer
    port map (
      A => A,
      B => B,
      S => S,
      Q => Q
    );

  -- File I/O process
  process
    variable line_in, line_out : line;
    variable A_var, B_var, Q_var : bit_vector(7 downto 0);
    variable S_var : bit;
  begin
    -- Read input file line by line
    while not endfile(input_file) loop
      readline(input_file, line_in);
      
      -- Read A (bit_vector) correctly
      read(line_in, A_var);
      
      -- Read B (bit_vector) correctly
      read(line_in, B_var);
      
      -- Read S (single bit)
      read(line_in, S_var);

      -- Assign values to signals
      A <= A_var;
      B <= B_var;
      S <= S_var;
      
      -- Wait for 10ns before writing output
      wait for 10 ns;
      
      -- Write Q to output file

      -- Write must be passed a variable (they act as varabiles in python), signals acts as hardware counterparts that cannot be used as a parameter to the write function. 
      Q_var := Q;
      write(line_out, Q_var);
      writeline(output_file, line_out);
    end loop;
    
    -- End simulation
    wait;
  end process;

end behavioral;

