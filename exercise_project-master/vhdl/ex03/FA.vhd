library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is 
	Port(
		A:  in  STD_LOGIC;
		B:  in  STD_LOGIC;
		CI: in  STD_LOGIC;
		S:  out STD_LOGIC;
		CO: out STD_LOGIC
	);
end entity FullAdder;

architecture Behavioral of FullAdder is 
begin 
	process (A, B , CI)
	begin
		S <= A xor B xor CI;
		CO <= (A and B) or (B and CI) or (A and CI);
	end process;
end architecture Behavioral;

