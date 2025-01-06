library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LogicalStep_Lab4_top IS
    PORT (
        clkin_50    : in    std_logic;                         
        rst_n       : in    std_logic;                         
        pb_n        : in    std_logic_vector(3 downto 0);      
        sw          : in    std_logic_vector(7 downto 0);      
        leds        : out   std_logic_vector(7 downto 0);     

        seg7_data   : out   std_logic_vector(6 downto 0);      
        seg7_char1  : out   std_logic;                         
        seg7_char2  : out   std_logic
    );
END LogicalStep_Lab4_top;
	 
ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
    -- Component declarations
    COMPONENT segment7_mux
        PORT (
            clk     : in    std_logic := '0';
            DIN2    : in    std_logic_vector(6 downto 0);    
            DIN1    : in    std_logic_vector(6 downto 0);    
            DOUT    : out   std_logic_vector(6 downto 0);    
            DIG2    : out   std_logic;                       
            DIG1    : out   std_logic                        
        );
    END COMPONENT;

    COMPONENT clock_generator
        PORT (
            sim_mode    : in    boolean;               
            reset       : in    std_logic;            
            clkin       : in    std_logic;            
            sm_clken    : out   std_logic;            
            blink       : out   std_logic             
        );
    END COMPONENT;

    COMPONENT pb_filters
        PORT (
            clkin               : in    std_logic;                      
            rst_n               : in    std_logic;                      
            rst_n_filtered      : out   std_logic;                      
            pb_n                : in    std_logic_vector(3 downto 0);  
            pb_n_filtered       : out   std_logic_vector(3 downto 0)   
        );
    END COMPONENT;
    
    COMPONENT synchronizer
        PORT (
            clk     : in  std_logic;
            reset   : in  std_logic;
            din     : in  std_logic;
            dout    : out std_logic
        );
    END COMPONENT;
    
    COMPONENT holding_register
        PORT (
            clk             : in  std_logic;
            reset           : in  std_logic;
            register_clr    : in  std_logic;
            din             : in  std_logic;
            dout            : out std_logic
        );
    END COMPONENT;
    
    COMPONENT pb_inverters
        PORT (
            rst_n           : in  std_logic;                     
            rst             : out std_logic;                      
            pb_n_filtered   : in  std_logic_vector(3 downto 0);  
            pb              : out std_logic_vector(3 downto 0)   
        );
    END COMPONENT;
    
    COMPONENT SM 
        PORT (
            clk_in          : in  std_logic;
            reset           : in  std_logic;
            NS_IN           : in  std_logic;
            EW_IN           : in  std_logic;
            Blink           : in  std_logic;
            NS_R            : out std_logic;
            NS_A            : out std_logic;
            NS_G            : out std_logic;
            EW_R            : out std_logic;
            EW_A            : out std_logic;
            EW_G            : out std_logic;
            NS_CLR          : out std_logic;
            EW_CLR          : out std_logic;
            NS_G_DISPLAY    : out std_logic;
            EW_G_DISPLAY    : out std_logic;
            state           : out std_logic_vector (3 downto 0)
        );
    END COMPONENT;
    
    -- Constant declaration
    CONSTANT sim_mode        : boolean := FALSE;  -- Simulation mode flag

    -- Signal declarations
    SIGNAL synch_rst          : std_logic;        -- Synchronized reset signal from synchronizer
    SIGNAL sm_clken, blink_sig: std_logic;        -- Clock enable and blink signals
    SIGNAL pb_n_filtered, pb  : std_logic_vector(3 downto 0);  -- Filtered pushbutton signal and unfiltered 
    SIGNAL rst                : std_logic;        -- Reset signal
    SIGNAL rst_n_filtered     : std_logic;        -- Filtered reset signal
    SIGNAL north_clear, east_clear: std_logic;    -- Clear signals for north and east sides
    SIGNAL next_state         : std_logic;        -- Next state signal
    SIGNAL state_count        : integer range 0 to 15 := 0;  -- State counter for all 16 states
    SIGNAL blink              : std_logic;        -- Blink signal
    SIGNAL north_r_out, east_r_out: std_logic;    -- Output signals for north and east requests
    SIGNAL syn_north, syn_east: std_logic;        -- Synchronized signals for north and east requests
    SIGNAL syn_rst            : std_logic;        -- Synchronized reset signal
    SIGNAL north_out, east_out: std_logic_vector(6 downto 0);  -- Output signals for north and east LEDs
    SIGNAL east_r, east_a, east_g, north_r, north_a, north_g: std_logic; -- Signals for LED outputs for North South Side and East West Side

BEGIN
    -- Component instantiations and their connections

    -- Instance 0: Pushbutton filters
    INST0: pb_filters PORT MAP (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered); -- filters inputs
    
    -- Instance 1: Pushbutton inverters
    INST1: pb_inverters PORT MAP (rst_n_filtered, rst, pb_n_filtered, pb); -- invertes buttons from active low to active high polarity
    
    -- Instance 2: Seg7 mux
    INST2: segment7_mux PORT MAP (clkin_50, north_out, east_out, seg7_data, seg7_char2, seg7_char1); -- signal outputs for displayed on 7 segment display
    
    -- Instance 3: Clock generator
    INST3: clock_generator PORT MAP (sim_mode, syn_rst, clkin_50, sm_clken, blink);
    
    -- Instance 4: Button synchronizer
    INST4: synchronizer PORT MAP (clkin_50, '0', rst, syn_rst); -- synchronizes inputs
    
    -- Instance 5: NorthSouth pushbutton synchronizer
    INST5: synchronizer PORT MAP (clkin_50, syn_rst, pb(0), syn_north);
    
    -- Instance 6: EastWest pushbutton synchronizer
    INST6: synchronizer PORT MAP (clkin_50, syn_rst, pb(1), syn_east);
    
    -- Instance 7: EastWest holding register
    INST7: holding_register PORT MAP (clkin_50, syn_rst, east_clear, syn_east, east_r_out); -- inputs from EW a
    
    -- Instance 8: NorthWest holding register
    INST8: holding_register PORT MAP (clkin_50, syn_rst, north_clear, syn_north, north_r_out); --
    
    -- Instance 9: State machine (MEALY)
    INST9: SM PORT MAP (sm_clken, syn_rst, north_r_out, east_r_out, blink,
                        north_r, north_a, north_g, east_r, east_a, east_g,
                        north_clear, east_clear, leds(0), leds(2), leds(7 downto 4));

    
    leds(1) <= north_r_out;  -- North side request LED assigned to LED1
    leds(3) <= east_r_out;   -- East side request LED assigned to LED3

    -- Concatenate signals for north and east LED outputs (green amber and red)
    north_out <= north_a & "00" & north_g & "00" & north_r;
    east_out  <= east_a  & "00" & east_g & "00" & east_r;

END SimpleCircuit;
