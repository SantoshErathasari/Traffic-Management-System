library ieee;
use ieee.std_logic_1164.all;

entity SM is
    port (
		  clk_in : in std_logic; -- Global Clock
        reset : in std_logic; -- reset
        NS_IN : in std_logic; -- input from North South side
        EW_IN : in std_logic; -- input from East West side
		  Blink : in std_logic; --
        NS_R : out std_logic; -- North south side red light
		  NS_A : out std_logic; -- North south side amber light
		  NS_G : out std_logic; -- North south side green light
		  EW_R : out std_logic; -- East West side red light
		  EW_A : out std_logic; -- East West side red light
		  EW_G : out std_logic; -- East West side red light
		  EW_CLR, NS_CLR: out std_logic; -- clears for both outputs
		  NS_G_DISPLAY, EW_G_DISPLAY : out std_logic; -- outputs from the state machine (whenever green led, output is 1)
		  state		: out std_logic_vector(3 downto 0) -- the 4 bit state numbers (numbering all 16 states 0-15)
    );
end SM;

architecture behavior of SM is
    -- S definitions
    type States is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15); -- all 16 states of the State machine
    signal current_S, next_S : States; -- signals for the current and next states

 
begin
Register_Section: PROCESS (clk_in)
begin
    -- S machine process
	 if (rising_edge(clk_in)) then
        if (reset = '1') then
            current_S <= S0;  -- Initial S after reset
			elsif (reset ='0') then
            current_S <= next_S;  -- S transition
        end if;
	end if;
    end process;
	 
-- logic for state transitions
Transition_Section: process (current_S)
    
    begin
        case current_S is
            when S0 =>
                if ((NS_IN = '0') and (EW_IN ='1')) then --jump to state 6 (amber on NS side) if pb(1) pressed (EW side is requested)
                    next_S <= S6; 
                else
                    next_S <= S1; --otherwise continue as normal
                end if;

            when S1 =>
                if ((NS_IN = '0') and (EW_IN ='1'))  then --jump to state 6 (amber on NS side) if pb(1) pressed (EW side is requested)
                    next_S <= S6;
                else
                    next_S <= S2; --otherwise continue as normal
                end if;
					 
				when S2 =>
					next_S <= S3;
				
				when S3 =>
					next_S <= S4;
					
				when S4 =>
					next_S <= S5;
					
				when S5 =>
					next_S <= S6;
					
				when S6 =>
					next_S <= S7;
					
				when S7 =>
					next_S <= S8;
					
            when S8 =>
                if ((NS_IN = '1') and (EW_IN ='0'))  then --jump to state 14 (amber on EW side) if pb(0) pressed (NS side is requested) 
                    next_S <= S14; 
                    
                else
                    next_S <= S9; --otherwise continue as normal
                end if;

            when S9 =>
                if ((NS_IN = '1') and (EW_IN ='0'))  then --jump to state 14 (amber on EW side) if pb(0) pressed (NS side is requested)
                    next_S <= S14; --otherwise continue as normal
                   
                else
                    next_S <= S10; --otherwise continue as normal
                   
                end if;
				when S10 =>
					next_S <= S11;
					
				when S11 =>
					next_S <= S12;
					
				when S12 =>
					next_S <= S13;
					
				when S13 =>
					next_S <= S14;
				
            when S14 =>
                next_s <=s15;
					 
				when S15 =>
                next_s <=s0; -- when state 15 is reached, go back to start

        end case;
    end process;

    -- EW and NS light assignment
   Decoder_Section: process (current_S)
    begin

	 
        case current_S is
            WHEN S0 =>
            NS_R <= '0';
				NS_A <= '0';
				NS_G <= blink; -- the green signal will be blink on the north side at state 0
				EW_R <= '1';   -- the East West side is at red during state 0
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "0000"; -- state number 0
					 
				WHEN S1 =>
                 NS_R <= '0';
				NS_A <= '0';
				NS_G <= blink; -- the green signal will be blinking when the blink_signal is inputed
				EW_R <= '1';   -- the East West side is at red during state 1
				EW_A <= '0';   
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "0001"; -- state number 1
					 
				WHEN S2 =>
                NS_R <= '0';
				NS_A <= '0';
				NS_G <= '1'; -- Green signal on North South Side is on in state 2
				EW_R <= '1'; ---- the East West side is at red during state 2
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '1';
				EW_G_DISPLAY <= '0';
				state <= "0010"; -- state number 2
					 
				WHEN S3 =>
            NS_R <= '0';
				NS_A <= '0';
				NS_G <= '1'; -- Green signal on North South Side is on in state 3
				EW_R <= '1'; -- the East West side is at red during state 3
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '1';
				EW_G_DISPLAY <= '0';
				state <= "0011"; -- state number 3
					 
				WHEN S4 =>
                NS_R <= '0';
				NS_A <= '0';
				NS_G <= '1'; -- Green signal on North South Side is on in state 4
				EW_R <= '1'; -- the East West side is at red during state 4
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '1';
				EW_G_DISPLAY <= '0';
				state <= "0100"; -- state number 4
					 
					 
				WHEN S5 =>
                 NS_R <= '0';
				NS_A <= '0';
				NS_G <= '1'; -- Green signal on North South Side is on in state 5
				EW_R <= '1'; -- the East West side is at red during state 5
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '1';
				EW_G_DISPLAY <= '0';
				state <= "0101"; -- state number 5
				
            when S6 =>
             NS_R <= '0';
				NS_A <= '1'; -- Amber signal on North South Side is on in state 6
				NS_G <= '0'; 
				EW_R <= '1'; -- the East West side is at red during state 6
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '1';
				NS_CLR <= '1';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "0110"; -- state number 6
					
            when S7 =>
                 NS_R <= '0';
				NS_A <= '1'; -- Amber signal on North South Side is on in state 7
				NS_G <= '0'; 
				EW_R <= '1'; -- the East West side is at red during state 7
				EW_A <= '0';
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "0111"; -- state number 7
					 
            when S8 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 8
				NS_A <= '0';
				NS_G <= '0'; 
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= Blink; -- the East West side is blinking during state 8
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "1000"; -- state number 8
					 
            when S9 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 9
				NS_A <= '0';
				NS_G <= '0'; -- the green signal will be blinking when the blink_signal is inputed
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= Blink; -- the East West side is blinking during state 9
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "1001"; -- state number 9
					 
					 
            when S10 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 10
				NS_A <= '0';
				NS_G <= '0'; 
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= '1'; -- the East West side is green during state 10
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '1';
				state <= "1010"; -- state number 10
					 
            when S11 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 11
				NS_A <= '0';
				NS_G <= '0'; 
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= '1'; -- the East West side is green during state 10
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '1';
				state <= "1011"; -- state number 11
				
            when S12 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 8
				NS_A <= '0';
				NS_G <= '0';
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= '1'; -- the East West side is green during state 10
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '1';
				state <= "1100"; -- state number 12

            when S13 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 13
				NS_A <= '0';
				NS_G <= '0'; 
				EW_R <= '0';
				EW_A <= '0';
				EW_G <= '1';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '1';
				state <= "1101"; -- state number 13
					 
            when S14 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 14
				NS_A <= '0'; 
				NS_G <= '0'; 
				EW_R <= '0'; 
				EW_A <= '1'; -- the East West side is amber during state 14
				EW_G <= '0'; 
				EW_CLR <= '1';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "1110"; -- state number 14
					 
            when S15 =>
            NS_R <= '1'; -- red signal on North South Side is on in state 15
				NS_A <= '0'; 
				NS_G <= '0'; 
				EW_R <= '0'; 
				EW_A <= '1'; -- the East West side is amber during state 15
				EW_G <= '0';
				EW_CLR <= '0';
				NS_CLR <= '0';
				NS_G_DISPLAY <= '0';
				EW_G_DISPLAY <= '0';
				state <= "1111"; -- state number 15
				
            
        end case;
    end process;

end architecture behavior;