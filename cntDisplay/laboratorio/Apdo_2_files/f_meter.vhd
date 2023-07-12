library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity f_meter is
  port(
    CLK      : in  std_logic;
    RST      : in  std_logic;
    F_OUT    : in  std_logic;
    F_MED_OK : out std_logic;
    F_MED    : out std_logic_vector(15 downto 0));
end f_meter;

architecture rtl of f_meter is


begin  -- rtl



end rtl;
