library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity signal_generator is
  port ( RST        : in  std_logic;
         CLK        : in  std_logic;
         DATO_RX    : in  std_logic_vector (7 downto 0);
         DATO_RX_OK : in  std_logic;
         DOUT       : out std_logic_vector (11 downto 0);
         F_OUT      : out std_logic;  --esta es la frecuencia mas lenta, la que determina el periodo de la onda.  
         DOUT_OK    : out std_logic);
end signal_generator;

architecture rtl of signal_generator is
    signal cnt : unsigned (19 downto 0);
    signal frecuenciaSenal : unsigned (5 downto 0);
    signal ganancia : unsigned (3 downto 0);
    signal nivelContinua : unsigned (5 downto 0);
    signal selectorFormaOnda : unsigned (2 downto 0);
    signal address : unsigned (7 downto 0);
    signal dientesSierra : unsigned (7 downto 0);
    signal triangular : unsigned (7 downto 0);
    signal cuadrada : unsigned (7 downto 0);
    signal cuadrada25porciento : unsigned (7 downto 0);
    signal cuadrada75porciento : unsigned (7 downto 0);
    signal onda : unsigned (7 downto 0);
    signal ondaMultiplicada : unsigned (11 downto 0); 
    
    --señales para llamar la entidad del seno. 
    signal miADDR :  std_logic_vector(7 downto 0);
    signal miDOUTseno : std_logic_vector(7 downto 0);
    
--- aux = Onda(255)  * Gani(15)  + DC(63)   * 64
 
begin
    --importacion de la funcion Seno. 
    DUT : entity work.seno
        port map (
            CLK => CLK,
            ADDR => miADDR,
            DOUT => miDOUTseno);
     
-------VALORES POR DEFECTO DE LA SEÑAL GENERADA. 
             --Granancia = 3.
             --Tipo de señal.  sinoidal. "001110"
             --Frecuencia.  "000001"   ---alomejor hay que dejar una frecuencia mas alta para que la temporal, se vea rapido el dibujo de la onda. 
             --Nivel de continua (DC)  = 0. 
    --registro, decodificaRx. 
    process (all)  
    begin
        if rst = '1' then
            ganancia <= x"3";
            selectorFormaOnda <= "110";
            frecuenciaSenal <= (0 => '1', others => '0');
            nivelContinua <= (others => '0');
        elsif clk'event and clk = '1' then
            if (DATO_RX_OK = '1') then
                if (unsigned(DATO_RX(7 downto 6)) = 2) then 
                    ganancia <= unsigned (DATO_RX(3 downto 0));
                elsif (unsigned(DATO_RX(7 downto 6)) = 0) then
                    selectorFormaOnda <= unsigned (DATO_RX(2 downto 0));
                elsif (unsigned(DATO_RX(7 downto 6)) = 1) then
                    frecuenciaSenal <= unsigned(DATO_RX (5 downto 0));
                else
                    nivelContinua <= unsigned (DATO_RX(5 downto 0));
                end if;
            end if; 
        end if;
    end process;
    
    ---contador.   1048576 es el valor maximo que puede alcanzar. si frecuanciaSenal = 1 1111, cuenta cada  63.  
    process (all)
    begin
        if rst = '1' then 
            cnt <= (others => '0');
        elsif clk'event and clk = '1' then
            cnt <= cnt + frecuenciaSenal;
        end if;   
    end process;
    
    --combinacional T. Lo que hace esto es quedarse con los bits mas signficativos de cnt. para que se vea la cuenta en los dos valores hexagesimal
    -- de address. Un ejemplo: cuando va por la cuenta cnt = ae011, lo que hace address es quedarse con "ae" solamente. 
    address <= cnt (19 downto 12);
    
    ---generacion de las formas de onda. 
    process (all)
    begin
        if rst = '1' then
            dientesSierra <= (others => '0');
            triangular <= (others => '0');
            cuadrada <= (others => '0');
            cuadrada25porciento <= (others => '0');
            cuadrada75porciento <= (others => '0');
            miADDR <= (others => '0');
        elsif clk'event and clk = '1' then
            dientesSierra <= address;
            triangular <= address(7 downto 1) & '0';
            cuadrada <= (others => '0');
            cuadrada25porciento <= (others => '0');
            cuadrada75porciento <= (others => '0');
            miADDR <= std_logic_vector(address);
            if (address(7 downto 7) = 1) then
                triangular <= not(address(7 downto 1)) & '0';
            end if;
            if (address(7 downto 7) = 1) then
                cuadrada <= (others => '1');
            end if;
            if (address(7 downto 6) >= 3) then
                cuadrada25porciento <= (others => '1');
            end if; 
            if (address(7 downto 6) >= 1) then
                cuadrada75porciento <= (others => '1');
            end if;
        end if;
    end process;
    
    --Modulo F_OUT.
    process (all)  
        variable miEspera : std_logic; 
    begin
        if (rst = '1') then
            F_OUT <= '0';
        elsif clk'event and clk = '1' then 
            if (address(7) = '0') and (miEspera = '1') then      
                F_OUT <= '1';
                if (F_OUT = '1') then 
                    F_OUT <= '0';
                    miEspera := '0';
                end if;
            end if;
            if (address(7) = '1') then 
                miEspera := '1';
            end if;
        end if;
    end process;
    
    --Modulo DOUT. 
    process (all)
        variable miEspera : std_logic; 
    begin
        if (rst = '1') then
            DOUT_OK <= '0'; 
            miEspera := '0'; 
        elsif clk'event and clk = '1' then 
            if (address (0) = '1') and (miEspera = '1') then
                DOUT_OK <= '1';
                if (DOUT_OK = '1') then
                    DOUT_OK <= '0';
                    miEspera := '0';  
                end if; 
            end if;
            if (address (0) = '0') and (miEspera = '0') then 
                DOUT_OK <= '1';
                if (DOUT_OK = '1') then
                    DOUT_OK <= '0';
                    miEspera := '1';
                end if; 
            end if; 
        end if;
    end process; 
    
    --multiplexor. --CUIDADO: Cuando La seleccion de la onda, sea una onda que No existe, este valor saldra cero. Por ejemlo "000".  
    process (selectorFormaOnda, cuadrada75porciento, cuadrada25porciento, cuadrada, dientesSierra, triangular, miDOUTseno)
    begin
        onda <= x"00";  
        case selectorFormaOnda is
            when "001" =>
                onda <= cuadrada75porciento;
            when "010" => 
                onda <= cuadrada25porciento;
            when "011" => 
                onda <= cuadrada;
            when "100" => 
                onda <= dientesSierra; 
            when "101" =>
                onda <= triangular;
            when "110" =>
                onda <= unsigned (miDOUTseno); 
            when others => null;
        end case;
    end process;
    
    --modulo ganancia. 1010*2= 10100  1010*3=11110  1010*4=101000  1010*5=110010  1010*111100  1010*111=1000110.
    process (onda, ganancia)
        variable ondaAux : integer;
        variable gananciaAux : integer;
        variable ondaMultiplicadaAux : integer;  
    begin 
        ondaAux := to_integer (onda);
        gananciaAux := to_integer (ganancia);
        ondaMultiplicadaAux := ondaAux * gananciaAux;
        ondaMultiplicada <= to_unsigned (ondaMultiplicadaAux, 12);
    end process; 
    
    --modulo offset
    process (ondaMultiplicada, nivelContinua)
        variable DOUTaux : Integer;
    begin
        DOUTaux := to_integer (nivelContinua) * 64; 
        DOUTaux := to_integer (ondaMultiplicada) + DOUTaux;
        if (DOUTaux > 4095) then
            DOUTaux := 4095;
        end if;
        DOUT <= std_logic_vector(to_unsigned(DOUTaux, 12));
    end process;
end;
