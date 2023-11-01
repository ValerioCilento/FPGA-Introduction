LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RAM128_32 IS
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END RAM128_32;

architecture rtl of RAM128_32 is
subtype t_word is std_logic_vector(31 downto 0);
type t_ram is array(0 to 127) of t_word;
signal ram : t_ram;
begin
	ram_wr: process(clock) is
	begin
		if(rising_edge(clock) and wren = '1') then
			ram(to_integer(unsigned(address))) <= data;
		end if;
	end process ram_wr;
	
	q <= ram(to_integer(unsigned(address)));

end rtl;

