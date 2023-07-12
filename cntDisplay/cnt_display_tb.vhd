-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity cnt_display_tb is

end cnt_display_tb;

-------------------------------------------------------------------------------

architecture sim of cnt_display_tb is

  constant CNT1 : time:= 20 us;                 -- Indicar valor

  signal CLK_i         : std_logic := '0';
  signal RST_i         : std_logic;
  signal DATO_BCD_i    : std_logic_vector(15 downto 0):= X"3456";
  signal DATO_BCD_OK_i : std_logic := '0';
  signal AND_30_i      : std_logic_vector(3 downto 0);
  signal DP_i          : std_logic;
  signal SEG_AG_i      : std_logic_vector(6 downto 0);

begin  -- sim

  DUT : entity work.cnt_display
    port map (
      CLK         => CLK_i,
      RST         => RST_i,
      DATO_BCD    => DATO_BCD_i,
      DATO_BCD_OK => DATO_BCD_OK_i,
      AND_30      => AND_30_i,
      DP          => DP_i,
      SEG_AG      => SEG_AG_i);

  UD : entity work.display
    port map (
      SEG_AG => SEG_AG_i,
      AND_30 => AND_30_i);


  RST_i <= '1', '0'  after 133ns;--133 ns;
  --RST_i <= not RST_i after 1000000ns;
  
  CLK_i <= not CLK_i after 5 ns;

  process
  begin  -- process
    
    wait for 142 ns;
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"198F";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;


    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"2987";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"0987";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"0087";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"0007";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"0000";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"7987";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"8987";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '1';
    DATO_BCD_i    <= X"9987";-- Indicar valor
    wait until CLK_i = '0';
    DATO_BCD_OK_i <= '0';
    wait for CNT1;

    report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;
end sim;

-------------------------------------------------------------------------------
