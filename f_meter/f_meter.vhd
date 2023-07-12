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

architecture rtl of f_meter is  --hay que medir la contidad de pulsos en 1 Hz
    constant T_PUERTA : integer := 1e5; --para simulacion 1ms(1e5), es cada ms que se hace la medicións. 
    --constant T_PUERTA : integer := 1e8;  --para implememtacion (1e8). porque la implemetacion es cada segundo 
    signal contadortiempobase : integer := 0;
    signal pre_out : std_logic; 
    signal contadorbcd : unsigned (15 downto 0);
   
begin  -- rtl
    --prescalerSegundos
    process (all)  
    begin
        if rst = '1' then 
            contadortiempobase <= 0;
            pre_out <= '0';
        elsif clk'event and clk = '1' then
            contadortiempobase <= contadortiempobase + 1;
            if contadortiempobase >= T_PUERTA-1 then
                contadortiempobase <= 0;
                pre_out <= '1';
            else
                pre_out <= '0';
            end if;
        end if;
    end process;
    
    --contador BCD 
    process (all)
        variable unidades, decenas, centenas, millar : unsigned (3 downto 0);
    begin
        if rst = '1' then   
            unidades := x"0";
            decenas := x"0";
            centenas := x"0";
            millar := x"0";
            contadorbcd <= (others => '0');
        elsif clk'event and clk = '1' then 
            if pre_out = '1' then 
                unidades := x"0";
                decenas := x"0";
                centenas := x"0";
                millar := x"0";
            else 
                if F_OUT = '1' then 
                    unidades := unidades + 1;
                    if unidades > 9 then 
                        unidades := x"0";
                        decenas := decenas + 1;
                        if decenas >9 then 
                            decenas := x"0";
                            centenas := centenas + 1;
                            if centenas > 9 then 
                                centenas := x"0";
                                millar := millar + 1;
                                if millar > 9 then 
                                    millar := x"a";  
                                end if;
                            end if;
                        end if;
                    end if;
                end if; 
            end if;
            contadorbcd <= millar & centenas & decenas & unidades;
        end if;
    end process;

    process (all)
    begin
        if rst = '1' then 
            F_MED <= (others => '0');
        elsif clk'event and clk = '1' then 
            if pre_out  = '1' then 
                F_MED <= std_logic_vector (contadorbcd);
            end if;
        end if;
    end process;
    
    process (all)
    begin
        if rst = '1' then 
            F_MED_OK <= '0';
        elsif clk'event and clk = '1' then 
            if pre_out = '1' then 
                F_MED_OK <= '1';
            else
                F_MED_OK <= '0';
            end if;
        end if;
    end process;
end rtl;
