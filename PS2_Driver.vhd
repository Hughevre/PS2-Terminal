----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hubert Zaj�czkowski
-- 
-- Create Date: 23.05.2019 18:30:26
-- Design Name: 
-- Module Name: PS2_Driver - RTL
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

entity PS2_Driver is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           Scan_Code    : in    STD_LOGIC_VECTOR (7 downto 0);
           Scan_End     : in    STD_LOGIC;
           K_Code       : out   STD_LOGIC_VECTOR (7 downto 0));
end PS2_Driver;

architecture RTL of PS2_Driver is
    signal O_Buf_State_Reg : STD_LOGIC_VECTOR (7 downto 0);
begin
    process (Reset, Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                O_Buf_State_Reg <= (others => '0');
            elsif Scan_End = '1' then
                O_Buf_State_Reg <= Scan_Code;
            end if;
        end if;
    end process;
    
   K_Code <= O_Buf_State_Reg;
end RTL;
