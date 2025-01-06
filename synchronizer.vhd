library ieee;
use ieee.std_logic_1164.all;



entity synchronizer is port (

			clk			: in std_logic; -- global clock 
			reset		: in std_logic;	 -- Reset 
			din			: in std_logic; -- input
			dout		: out std_logic    -- synchronized output
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); -- 2 bits to store previous state and current state of synchronized data
	
   

BEGIN

sync_process: process(clk)
	begin
	
	if (rising_edge(clk)) then -- register is based on the global clock as we are using a positive edge triggered flip flop
	
		sreg(1) <= sreg(0);	-- changing the output of the second register
		
		if (reset = '1') then	-- in the case which reset is applied, first registar changes to 0
			sreg(0) <= '0';
		else
			sreg(0) <= din;	-- changing the value of the first register
		end if;
	end if;
	
	dout <= sreg(1);	-- output synchronized from the second registar
end process;

end;
