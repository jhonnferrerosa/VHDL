library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter16 is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    ce          : in  std_logic;
    direction   : in  std_logic;
    polarity    : in  std_logic;
    shifter_out : out std_logic_vector(15 downto 0));
end shifter16;

architecture rtl of shifter16 is
  signal c_out   : unsigned(3 downto 0);
  signal shf_aux : std_logic_vector(15 downto 0);
begin  --  
-- contador  mod 16
  process (all)
  begin  -- process
    if rst = '1' then
      c_out     <= (others => '0');
    elsif clk'event and clk = '1' then
      if ce = '1' then
        if direction = '1' then
          c_out <= c_out-1;
        else
          c_out <= c_out+1;
        end if;
      end if;
    end if;
  end process;

--decodificador 4:16
  process(all)
    variable a_int : integer;
  begin
    a_int := to_integer(c_out);
    for i in 0 to 15 loop
      if (i = a_int) then
        shf_aux(i) <= '1';
      else
        shf_aux(i) <= '0';
      end if;
    end loop;
  end process;

  shifter_out <= shf_aux when polarity = '1'else (not shf_aux);

end;
