-- multiplexer.vhd
-- 8-bit multiplexer entity
library ieee;
use ieee.std_logic_1164.all;
-- use std_logic_vector instead of bit_vector
entity multiplexer is
  port (
    A : in bit_vector(7 downto 0);
    B : in bit_vector(7 downto 0);
    S : in bit;
    Q : out bit_vector(7 downto 0)
  );
end multiplexer;

architecture rtl of multiplexer is
begin
  mux_process: process(A, B, S)
  begin
    if S = '0' then
      Q <= A;
    else
      Q <= B;
    end if;
  end process mux_process;
end rtl;

