
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity signal_generator is
  port ( RST        : in  std_logic;
         CLK        : in  std_logic;
         DATO_RX    : in  std_logic_vector (7 downto 0);
         DATO_RX_OK : in  std_logic;
         DOUT       : out std_logic_vector (11 downto 0);
         F_OUT      : out std_logic;
         DOUT_OK    : out std_logic);
end signal_generator;

architecture rtl of signal_generator is



begin

end;
