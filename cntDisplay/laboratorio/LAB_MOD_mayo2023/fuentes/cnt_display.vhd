library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_display is
  port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    DATO_BCD    : in  std_logic_vector(15 downto 0);
    DATO_BCD_OK : in  std_logic;
    AND_30      : out std_logic_vector(3 downto 0);
    DP          : out std_logic;
    SEG_AG      : out std_logic_vector(6 downto 0));
end cnt_display;

architecture rtl of cnt_display is
    signal registro : unsigned (15 downto 0);
    signal comparadorRegistro : unsigned (15 downto 0);
    --constant cte_disp : integer := 1e5;   ---para implementacion, Este es el perido de refresco de loes 4 display. en (ms). va en funcion del puesto. 
    constant cte_disp : integer := 16e2;  --para simulacion. 
    
    signal pre_out : std_logic;
    signal contador : unsigned (1 downto 0);
    signal salidaMultiplexor4a1 : unsigned (3 downto 0);

begin  -- rtl
    DP <= '1';
    --registro
    process (all)
    begin
        if (rst = '1') then 
            registro <= (others => '0');
        elsif clk'event and clk = '1' then 
            if DATO_BCD_OK = '1' then 
                registro <= unsigned(DATO_BCD);
            end if;
        end if;
     end process;
     
     --comparadorRegistro
     process (registro)
     begin
        if (registro(3 downto 0) > 9) or (registro(7 downto 4) > 9) or (registro(11 downto 8) > 9) or (registro(15 downto 12) > 9) then 
            comparadorRegistro <= x"fabc";
        else     
            comparadorRegistro <= registro;  
            for i in 3 downto 1 loop
                if (registro (i*4+3 downto i*4) = x"0") then 
                    comparadorRegistro (i*4+3 downto i*4) <= x"d";
                else 
                    exit;
                end if;
            end loop;
        end if;
     end process;
     
     --prescaler
     process (all)
        constant contadorMaximo : integer := cte_disp/4;
        variable counter_reg : integer range 0 to contadorMaximo;
     begin
        if rst = '1' then 
            counter_reg := 0;
            pre_out <= '0';
        elsif clk'event and clk = '1' then 
            counter_reg := counter_reg + 1;
            if counter_reg = contadorMaximo then 
                pre_out <= '1';
                counter_reg := 0;
            else
                pre_out <= '0';
            end if;
        end if;
     end process;
     
     --contador
    process (all)
    begin
        if rst = '1' then 
            contador <= "00";
        elsif clk'event and clk = '1' then 
            if (pre_out = '1') then
                contador <= contador + 1;
            end if;
        end if;    
    end process;
    
    --multiplexor 4 a 1. 
    process (contador, comparadorRegistro)
    begin
        case contador is
            when "00" => 
                salidaMultiplexor4a1 <= comparadorRegistro (15 downto 12); 
            when "01" =>
                salidaMultiplexor4a1 <= comparadorRegistro (11 downto 8);
            when "10" => 
                salidaMultiplexor4a1 <= comparadorRegistro (7 downto 4);
            when "11" =>
                salidaMultiplexor4a1 <= comparadorRegistro (3 downto 0);
            when others =>
                null;
        end case;
    end process;
    
    --decodificador 7 segmentos
    process (salidaMultiplexor4a1)
    begin
        case salidaMultiplexor4a1 is
            when "0000"=> SEG_AG <="1000000";  -- '0'   este es el orden de los LED: gfedcba. (6 downto 0).
            when "0001"=> SEG_AG <="1111001";  -- '1' 
            when "0010"=> SEG_AG <="0100100";  -- '2'
            when "0011"=> SEG_AG <="0110000";  -- '3'
            when "0100"=> SEG_AG <="0011001";  -- '4' 
            when "0101"=> SEG_AG <="0010010";  -- '5'
            when "0110"=> SEG_AG <="0000010";  -- '6'
            when "0111"=> SEG_AG <="1111000";  -- '7'
            when "1000"=> SEG_AG <="0000000";  -- '8'
            when "1001"=> SEG_AG <="0011000";  -- '9'
            when "1010"=> SEG_AG <="1000000";  -- --  'O'    
            when "1011"=> SEG_AG <="1000111";           --L (
            when "1100"=> SEG_AG <="0001000";           --A 
            when "1101"=> SEG_AG <="1111111";           --"espacio"
            when "1111"=> SEG_AG <="1110110";  -- H
            when others =>  SEG_AG <= "1111111";
        end case;
    end process;
    
    --decodificador 2 a 4.
    process (contador)
    begin
        case contador is
            when "00" =>
                AND_30 <= "0111";  --display que muestra el dato de mayor peso. 
            when "01" =>
                AND_30 <= "1011";
            when "10" =>
                AND_30 <= "1101";
            when "11" =>
                AND_30 <= "1110";
            when others => null;
        end case;
    end process;
end rtl;

