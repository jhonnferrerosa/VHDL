library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity receiver is
  port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    RX          : in  std_logic;
    DATO_RX     : out std_logic_vector(7 downto 0);
    ERROR_RECEP : out std_logic;    
    DATO_RX_OK  : out std_logic);
end receiver;
--codigo inicio  encriptación
`protect begin_protected
`protect version = 2
`protect encrypt_agent = "XILINX"
`protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`protect begin_commonblock
`protect control error_handling="delegated"
`protect end_commonblock
`protect begin_toolblock
`protect rights_digest_method="sha256"
`protect key_keyowner = "Xilinx", key_keyname= "xilinxt_2017_05", key_method = "rsa", key_block
ve6YCIcD77NjfoxURi7+H+gw9iUPgqq1052HA9f6uGNM7oXmTrhSEWIbENISE0Lc/429/MQ1Ljm4
aisZVpGb22hyYRz9QQ5qcam4MmHva+BjsvJqS8F0c5hCpUei/BLH42nW5CVoW4yJ8/NjLm29eDkC
C40QSOdkqA159Q+rwRJcVz6OIcrjnUKa51GeaKxOMQMV0Wtz0portdXvoxCUAD0uk/RlE69AIPgx
4R8DjnkF4iuoJIF5msBnYe0/iCTEHCV06N6MvTmQwThWqx5ooA5awr2wzwIgI0+iCeJv8lZj5AvJ
Y0OKPAoDdWNCfG2kH2IuSKDd8CLdFKJLucMOJw==

`protect control xilinx_configuration_visible = "false"
`protect control xilinx_enable_modification = "false"
`protect control xilinx_enable_probing = "false"
`protect end_toolblock="wp+DNzA3kmyae/hQOAkuWciq4XEVTRPfdj0LYLoLOm0="
`protect data_method = "AES128-CBC"
`protect encoding = (enctype = "BASE64", line_length = 76, bytes = 5744)
`protect data_block
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
`protect end_protected
