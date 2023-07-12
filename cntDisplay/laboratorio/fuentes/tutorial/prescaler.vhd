library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    pre_out : out std_logic);
end prescaler;


architecture for_prescaler of prescaler is

  constant CLKDIV      : integer := 5e6;   -- para la implementación  --10ns * 5*10^6 = 50ms
  --constant CLKDIV      : integer := 25;  -- para la simulación
  signal   counter_reg : integer range 0 to CLKDIV-1;
begin  -- for_prescaler

  process (all)
  begin  -- process
    if rst = '1' then
      counter_reg   <= 0;
    elsif clk'event and clk = '1' then
      if counter_reg = CLKDIV-1 then
        counter_reg <= 0;
      else
        counter_reg <= counter_reg+1;
      end if;
    end if;
  end process;

  process (all)
  begin  -- process
    if rst = '1' then
      pre_out   <= '0';
    elsif clk'event and clk = '1' then
      if counter_reg = CLKDIV-1 then
        pre_out <= '1';
      else
        pre_out <= '0';
      end if;
    end if;
  end process;

end for_prescaler;
