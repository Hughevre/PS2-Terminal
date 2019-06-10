----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hubert Zaj¹czkowski
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
           Ds           : out   STD_LOGIC_VECTOR (7 downto 0));
end LED_Driver;

architecture Data_Flow of LED_Driver is
    signal Driver : STD_LOGIC_VECTOR (7 downto 0);
begin
    with Scan_Err select Driver <= 
        Scan_Code when '0',
        "00000000" when others;
        
    Ds <= Driver;
end Data_Flow;
