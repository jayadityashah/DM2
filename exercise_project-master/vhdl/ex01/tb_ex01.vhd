-- tb_ex01.vhd

-- Testbench for modeling an 8-bit multiplexer using VHDL-2008

 

library ieee;

use ieee.std_logic_1164.all;

 

entity tb_ex01 is

  -- Testbench has no ports

end tb_ex01;

 

architecture behavioral of tb_ex01 is

 

  -- Signal declarations

  signal A : bit_vector(7 downto 0) := "00000000";  -- 8-bit input A

  signal B : bit_vector(7 downto 0) := "11111111";  -- 8-bit input B

  signal Q : bit_vector(7 downto 0);                  -- 8-bit output

  signal S : bit := '0';                            -- Selector signal

 

  -- Constant declaration (example)

  constant CLK_PERIOD : time := 10 ns;

 

begin

 

  -- Process to model the multiplexer functionality

  mux_process: process(A, B, S)

  begin

    if S = '0' then

      Q <= A;

    else

      Q <= B;

    end if;

  end process mux_process;

 

  -- Stimulus process to test the multiplexer

  stimulus: process

  begin

    -- Initial stimulus

    A <= "00001111";

    B <= "11110000";

    S <= '0';

    wait for 20 ns;

 

    S <= '1';

    wait for 20 ns;

 

    -- Change input values to further test functionality

    A <= "10101010";

    B <= "01010101";

    S <= '0';

    wait for 20 ns;

 

    S <= '1';

    wait for 20 ns;

 

    -- End simulation

    wait;

  end process stimulus;

 

end behavioral;
