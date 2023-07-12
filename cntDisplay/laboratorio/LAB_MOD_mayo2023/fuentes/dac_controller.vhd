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
    signal registroDesplazamiento : std_logic_vector (15 downto 0); 
    signal cnt_bits : unsigned (4 downto 0);
    type fsm_type is (st0, st1, st2, st3, st4, stExtra);
    signal estado, prox_estado : fsm_type; 
    signal miClockEnable : std_logic; 
    signal miShift : std_logic; 
    signal miSCLK : std_logic;
    signal miSYNC : std_logic; 
begin
    
    --registro desplazamiento. 
    process (all)  
        variable miEspera : unsigned (4 downto 0); --esta variable, es para cumplir con el requisito que pide el enunciado de la practica: 
        --mientras se este enviando un dato al DAC, se ignorara toda activacion del puerto DOUT_OK.  (4 downto 0) cuenta hasta 31. 
    begin
        if (rst = '1') then
            registroDesplazamiento <= x"0000";
            miEspera := (others => '0');
        elsif clk'event and clk = '1' then
            if (miEspera = 0) then
                if (DOUT_OK = '1') then 
                    registroDesplazamiento <= x"0" &  DOUT; 
                end if;
            end if;
            if (miShift = '1') then
                registroDesplazamiento <= registroDesplazamiento(14 downto 0) & '0';
                miEspera := miEspera + 1;
                if (miEspera >= 16) then   --en el caso de que se hayan 16 pulsos de miShift, permito la entrada de DOUT_OK. 
                    miEspera := (others => '0');
                end if;
            end if;   
        end if;
    end process;
    DIN <= registroDesplazamiento(15);
    
    --maquina de estados, calculo de prox_estado. 
    process (estado, DOUT_OK, cnt_bits)
    begin   
        prox_estado <= estado;
        case estado is 
                when st0 => 
                    if (DOUT_OK ='1') then
                        prox_estado <= st1;
                    end if;
                when st1 =>
                    prox_estado <= st2;
                when st2 =>
                    prox_estado <= stExtra;
                when stExtra =>
                    prox_estado <= st3;
                when st3 =>
                    prox_estado <= st4;
                when st4 =>
                    if (cnt_bits >= 15) then
                        prox_estado <= st0;
                    else
                        prox_estado <= st1;
                    end if;
       end case;
    end process;
    --maquina de estados, registro seguencial. 
    process (all)
    begin 
        if (rst = '1') then
            estado <= st0;
        elsif clk'event and clk = '1' then
            estado <= prox_estado;
        end if;
    end process; 
    --maquina de estados, calcludo de las salidas. 
    miClockEnable <= '1' when (estado = st4) else '0';  --antes estaba en el estado st2.  
    miShift <= '1' when (estado = st4) else '0'; 
    miSCLK <= '1' when ((estado = st1) or (estado = st2) or (estado = stExtra)) else '0';   
    miSYNC <= '1' when (estado = st0) else '0'; 
     
    --coontador. 
    process (all)  
    begin
        if (rst = '1') then
            cnt_bits <= (others => '0');
        elsif clk'event and clk = '1' then
            if (cnt_bits >= 16) then
                cnt_bits <= (others => '0');
            else
                if (miClockEnable = '1') then
                    cnt_bits <= cnt_bits + 1;
                end if;
            end if;
        end if;
    end process;
    
    --biestable D, sclk. 
    process (all)
    begin
        if (rst = '1') then
            SCLK <= '0';
        elsif (clk'event and clk = '1') then
            SCLK <= miSCLK;
        end if;
    end process; 
    
    --biestable D, SYNC. 
    process (all)
    begin
        if (rst = '1') then
            SYNC <= '0';
        elsif (clk'event and clk = '1') then
            SYNC <= miSYNC;
        end if;      
    end process;
end;


