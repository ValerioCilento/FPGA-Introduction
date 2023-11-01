LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

entity AAC2M2P1 is port (                 	
   CP: 	 in std_logic; 	                    -- clock
   SR:   in std_logic;                      -- Active low, synchronous reset
   P:    in std_logic_vector(3 downto 0);   -- Parallel input
   PE:   in std_logic;                      -- Parallel Enable (Load)
   CEP:  in std_logic;                      -- Count enable parallel input
   CET:  in std_logic;                      -- Count enable trickle input
   Q:    out std_logic_vector(3 downto 0);            			
   TC:   out std_logic                      -- Terminal Count
);            		
end AAC2M2P1;

architecture behavioural of AAC2M2P1 is

--signal temp : std_logic_vector(3 downto 0);

begin 

	counter_proc: process(CP,SR,P,PE,CEP,CET) is
	begin
		if rising_edge(CP) then
			if SR = '0' then  -- Synchronous reset (overlaps other inputs)
				Q <= "0000";

			elsif PE = '0' then  -- Load parallel inputs
				Q <= P;
				if (CET = '1') and (Q = "1111") then  -- Terminal count check
					TC <= '1';
					Q <= "0000";
				else 
					TC <= '0';
				end if;

			elsif (CEP = '1') and (CET = '1') and (PE = '1') then  -- Count instruction
				Q <= Q + 1;
				if Q = "1111" then  -- Terminal count check
					TC <= '1';
					Q <= "0000";
				else 
					TC <= '0';
				end if;

			else 
				Q <= Q;  -- Maintain current state
			end if;
		end if;
	end process counter_proc;
end behavioural;
	