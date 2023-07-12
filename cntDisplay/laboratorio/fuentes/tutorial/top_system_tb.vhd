-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity top_system_tb is

end top_system_tb;

-------------------------------------------------------------------------------

architecture sim of top_system_tb is

  
  signal clk_i     : std_logic := '0';
  signal rst_i       : std_logic := '1';
  signal polarity_i  : std_logic := '0';
  signal direction_i : std_logic := '0';
  signal led_i       : std_logic_vector(15 downto 0);

begin  -- sim

  DUT :entity work.top_system
    port map (
      clk     => clk_i,
      rst       => rst_i,
      polarity  => polarity_i,
      direction => direction_i,
      led       => led_i);

  rst_i   <= '0'         after 123 ns;
  clk_i <= not clk_i after 5 ns;

  process
  begin  -- process

    direction_i <= '0';
    polarity_i  <= '0';
    wait for 5 us;
    direction_i <= '0';
    polarity_i  <= '1';
    wait for 5 us;
    direction_i <= '1';
    polarity_i  <= '0';
    wait for 5 us;
    direction_i <= '1';
    polarity_i  <= '1';
    wait for 5 us;
    report "fin controlado de la simulación" severity failure;
  end process;


end sim;

-------------------------------------------------------------------------------
