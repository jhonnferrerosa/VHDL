
library ieee;
use ieee.std_logic_1164.all;

entity prescaler_tb is

end prescaler_tb;

architecture sim of prescaler_tb is

  signal clk_i     : std_logic := '0';
  signal rst_i     : std_logic := '1';
  signal pre_out_i : std_logic;
  signal T_pre_out : time;
begin  -- sim

  DUT : entity work.prescaler
    port map (
      clk     => clk_i,
      rst     => rst_i,
      pre_out => pre_out_i);


  rst_i <= '0'       after 123 ns;
  clk_i <= not clk_i after 5 ns;

  P1             : process
    variable aux : time;
  begin  -- process    
    wait until pre_out_i = '1';
    T_pre_out <= now-aux;
    aux := now;

  end process P1;

  p2             : process
    variable aux : time;
  begin  -- process    
    wait for 1 us;  
    report "Fin de la simulación" severity failure;
  end process P2;

end sim;

-------------------------------------------------------------------------------
