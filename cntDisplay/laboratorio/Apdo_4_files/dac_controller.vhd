library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_controller is
  port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    DOUT    : in  std_logic_vector(11 downto 0);
    DOUT_OK : in  std_logic;
    SYNC    : out std_logic;
    SCLK    : out std_logic;
    DIN     : out std_logic);
end dac_controller;

architecture RTL of dac_controller is

begin

end;
