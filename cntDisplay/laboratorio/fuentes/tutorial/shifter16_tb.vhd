-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity shifter16_tb is

end shifter16_tb;

-------------------------------------------------------------------------------

architecture sim of shifter16_tb is
  signal CLK_i         : std_logic := '0';
  signal rst_i         : std_logic := '1';
  signal ce_i          : std_logic := '1';
  signal direction_i   : std_logic := '0';
  signal polarity_i    : std_logic := '0';
  signal shifter_out_i : std_logic_vector(15 downto 0);

begin  -- sim

  DUT : entity work.shifter16
    port map (
      clk         => clk_i,
      rst         => rst_i,
      ce          => ce_i,
      direction   => direction_i,
      polarity    => polarity_i,
      shifter_out => shifter_out_i);

  rst_i <= '0'       after 123 ns;
  clk_i <= not clk_i after 5 ns;

  process
  begin  -- process
    wait for 333 ns;
    wait until clk_i = '0';
    ce_i        <= '0';
    wait for 33 ns;
    wait until clk_i = '0';
    ce_i        <= '1';
    wait for 33 ns;
    wait until clk_i = '0';
    direction_i <= '1';
    wait for 233 ns;
    wait until clk_i = '0';
    polarity_i  <= '1';
    wait for 233 ns;
    wait until clk_i = '0';
    direction_i <= '0';
    wait for 233 ns;
    report "fin controlado de la simulación" severity failure;
  end process;


end sim;

-------------------------------------------------------------------------------
