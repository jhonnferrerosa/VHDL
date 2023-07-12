library ieee;
use ieee.std_logic_1164.all;


entity top_system is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    polarity  : in  std_logic;
    direction : in  std_logic;
    led       : out std_logic_vector(15 downto 0));
end top_system;

architecture rtl of top_system is

  signal pre_out : std_logic;

begin

  press : entity work.prescaler
    port map (
      clk     => clk,
      rst     => rst,
      pre_out => pre_out);

  shiff : entity work.shifter16
    port map (
      clk         => pre_out,
      rst         => rst,
      ce          => '1',            --diseño asíncrono
   -- ce          => pre_out,        --diseño síncrono
      polarity    => polarity,
      direction   => direction,
      shifter_out => led);
end;
