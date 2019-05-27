----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2019 19:06:04
-- Design Name: 
-- Module Name: LED_Driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_Driver is
    Port ( Scan_Code    : in    STD_LOGIC_VECTOR (7 downto 0);
           Scan_Err     : in    STD_LOGIC;
           D_0          : out   STD_LOGIC;
           D_1          : out   STD_LOGIC;
           D_2          : out   STD_LOGIC;
           D_3          : out   STD_LOGIC;
           D_4          : out   STD_LOGIC;
           D_5          : out   STD_LOGIC;
           D_6          : out   STD_LOGIC;
           D_7          : out   STD_LOGIC);
end LED_Driver;

architecture Data_Flow of LED_Driver is
    signal Error_O : STD_LOGIC_VECTOR (7 downto 0);
begin
    with Scan_Err select Error_O <= 
        Scan_Code when '1',
        "00000000" when others;
        
    D_0 <= Error_O(0);
    D_1 <= Error_O(1);
    D_2 <= Error_O(2);
    D_3 <= Error_O(3);
    D_4 <= Error_O(4);
    D_5 <= Error_O(5);
    D_6 <= Error_O(6);
    D_7 <= Error_O(7);
end Data_Flow;
