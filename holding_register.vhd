library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic; -- global clock
			reset				: in std_logic;    -- reset input
			register_clr		: in std_logic; -- clear nput for register
			din					: in std_logic; -- synchronized input
			dout				: out std_logic    -- Pending Request output
  );
 end holding_register;
 
 architecture circuit of holding_register is
 
	Signal sreg				: std_logic; --Signal for holding the register value
	signal ff_out :std_logic; -- 


BEGIN


processHolding: process(clk)
	begin
	
	ff_out  <= (sreg OR din) AND NOT(register_clr); -- 
	
	if (rising_edge(clk)) then	-- registar utilize rising edge flip flop
		
		if (reset = '1') then	-- asynchronous clear the output signal based on pb(3)
			sreg <= '0';
		else
			sreg <= ff_out;	-- changing the value of the output signal
		end if;
	end if;
	
	dout <= sreg;	-- final output signal being updated based on the sreg signal

end process;

 

	

end;