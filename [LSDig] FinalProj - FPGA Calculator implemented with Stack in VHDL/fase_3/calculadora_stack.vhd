library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity calculadora_stack is
	port(CLOCK_50 : in  std_logic;
		  SW       : in std_logic_vector(3 downto 0);
		  KEY      : in std_logic_vector(3 downto 0);
		  HEX0     : out std_logic_vector(6 downto 0);
		  HEX1     : out std_logic_vector(6 downto 0);
		  HEX2     : out std_logic_vector(6 downto 0);
		  HEX3     : out std_logic_vector(6 downto 0);
		  HEX4     : out std_logic_vector(6 downto 0);
		  HEX5     : out std_logic_vector(6 downto 0);
		  HEX6     : out std_logic_vector(6 downto 0);
		  HEX7     : out std_logic_vector(6 downto 0);
		  LEDR     : out std_logic_vector(3 downto 0);
		  LEDG     : out std_logic_vector(8 downto 8));
end calculadora_stack;

architecture behav of calculadora_stack is 
	
	signal s_SW, s_KEY : std_logic_vector(3 downto 0);
	signal s_SW0, s_SW1, s_SW2, s_SW3, s_KEY0, s_KEY1, s_KEY2, s_KEY3, s_KEY0_final, s_KEY1_final, s_KEY2_final, s_KEY3_final : std_logic;
	signal s_not_KEY0, s_not_KEY1, s_not_KEY2, s_not_KEY3 : std_logic;
	signal s_complete_pos, s_complete_calc, s_hasSpace, s_hasOperands, s_reset : std_logic;
	signal en_posOperando, en_posOperador, en_eliminarPos, en_verPilha, en_operando, en_operador, en_valOperando, en_valOperador, en_stackOperando, en_stackOperador : std_logic;
	
begin

	------------------------------------------------
	--                CONTROLPATH                 --
	------------------------------------------------
	
	control : entity work.controlpath(fsm)
				port map(clock            => CLOCK_50,
							SW               => s_SW,
							KEY              => s_KEY,
							complete_pos     => s_complete_pos,
							complete_calc     => s_complete_calc,
							hasSpace         => s_hasSpace,
							hasOperands      => s_hasOperands,
							en_eliminarPos   => en_eliminarPos,
							en_verPilha      => en_verPilha,
							en_operando      => en_operando,
							en_operador      => en_operador,
							en_valOperando   => en_valOperando,
							en_valOperador   => en_valOperador,
							en_stackOperando => en_stackOperando,
							en_stackOperador => en_stackOperador,
							en_posOperando   => en_posOperando,
							en_posOperador   => en_posOperador,
							reset            => s_reset);
							
	------------------------------------------------
	--                  DATAPATH                  --
	------------------------------------------------
							
	data : entity work.datapath(behav)
				port map(clock            => CLOCK_50,
							reset            => s_reset,
							SW               => s_SW(3 downto 2),
							KEY              => s_KEY(3 downto 1),
							en_eliminarPos   => en_eliminarPos,
							en_verPilha      => en_verPilha,
							en_operando      => en_operando,
							en_operador      => en_operador,
							en_valOperando   => en_valOperando,
							en_valOperador   => en_valOperador,
							en_stackOperando => en_stackOperando,
							en_stackOperador => en_stackOperador,
							en_posOperando   => en_posOperando,
							en_posOperador   => en_posOperador,
							complete_pos     => s_complete_pos,
							complete_calc    => s_complete_calc,
							hasSpace         => s_hasSpace,
							hasOperands      => s_hasOperands,
							HEX0             => HEX0,
							HEX1             => HEX1,
							HEX2             => HEX2,
							HEX3             => HEX3,
							HEX4             => HEX4,
							HEX5             => HEX5,
							HEX6             => HEX6,
							HEX7             => HEX7,
							LEDR             => LEDR,
							LEDG             => LEDG);
							
							
	-- Fazer NOT KEY pelo facto de KEY ser active low
	s_not_KEY0 <= not KEY(0);
	s_not_KEY1 <= not KEY(1);
	s_not_KEY2 <= not KEY(2);
	s_not_KEY3 <= not KEY(3);
	
	------------------------------------------------
	--           DEBOUNCERS & REGISTOS            --
	------------------------------------------------
	
	s_KEY <= s_KEY3_final & s_KEY2_final & s_KEY1_final & s_KEY0_final;
	s_SW <= s_SW3 & s_SW2 & s_SW1 & s_SW0;
							
	debouncerKEY0 : entity work.Debouncer(Behavioral)
				port map(refClk => CLOCK_50,
							dirtyIn   => s_not_KEY0,
							pulsedOut  => s_KEY0);
							
	debouncerKEY1 : entity work.Debouncer(Behavioral)
				port map(refClk => CLOCK_50,
							dirtyIn   => s_not_KEY1,
							pulsedOut  => s_KEY1);
							
	debouncerKEY2 : entity work.Debouncer(Behavioral)
				port map(refClk => CLOCK_50,
							dirtyIn   => s_not_KEY2,
							pulsedOut  => s_KEY2);
							
	debouncerKEY3 : entity work.Debouncer(Behavioral)
				port map(refClk => CLOCK_50,
							dirtyIn   => s_not_KEY3,
							pulsedOut  => s_KEY3);
							
	registerKEY0 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => s_KEY0,
							output => s_KEY0_final);
							
	registerKEY1 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => s_KEY1,
							output => s_KEY1_final);
							
	registerKEY2 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => s_KEY2,
							output => s_KEY2_final);
							
	registerKEY3 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => s_KEY3,
							output => s_KEY3_final);
							
	registerSW0 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => SW(0),
							output => s_SW0);
							
	registerSW1 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => SW(1),
							output => s_SW1);
							
	registerSW2 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => SW(2),
							output => s_SW2);
							
	registerSW3 : entity work.Register_1bit(behav)
				port map(clk => CLOCK_50,
							input => SW(3),
							output => s_SW3);

end behav;