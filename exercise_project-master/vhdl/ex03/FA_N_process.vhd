library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NbitFA is 
    Generic (N : integer := 8 ); -- Default bit-width
    Port(
        A  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        CI : in  STD_LOGIC;
        S  : out STD_LOGIC_VECTOR(N-1 downto 0);
        CO : out STD_LOGIC
    );
end entity NbitFA;

architecture Behavioral of NbitFA is 
begin 
    process (A, B, CI)
        variable sum : UNSIGNED(N downto 0);
        variable carry: UNSIGNED(0 downto 0);
    begin
    	if CI = '1' then 
    		carry := "1";
	else 
		carry := "0";
    	end if;
    	
        sum := ('0' & UNSIGNED(A)) + ('0' & UNSIGNED(B)) + carry;
        S   <= STD_LOGIC_VECTOR(sum(N-1 downto 0));
        CO  <= sum(N);
    end process;
end architecture Behavioral;


