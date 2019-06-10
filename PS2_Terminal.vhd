----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hubert Zaj¹czkowski
-- 
-- Create Date: 23.05.2019 19:13:59
-- Design Name: 
-- Module Name: PS2_Terminal - RTL
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

entity PS2_Terminal is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           PS2_Clk      : in    STD_LOGIC;
           PS2_Data     : in    STD_LOGIC;
           Ds           : out   STD_LOGIC_VECTOR (7 downto 0));
end PS2_Terminal;

architecture Structural of PS2_Terminal is
    component PS2_Host_Emulator is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           PS2_Clk      : in    STD_LOGIC;
           PS2_Data     : in    STD_LOGIC;
           Scan_Err     : out   STD_LOGIC;
           Scan_Code    : out   STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component LED_Driver is
    Port ( Scan_Code    : in    STD_LOGIC_VECTOR (7 downto 0);
           Scan_Err     : in    STD_LOGIC;
           Ds           : out   STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal I_Scan_Err       : STD_LOGIC;
    signal I_Scan_Code      : STD_LOGIC_VECTOR (7 downto 0);
begin
    Host    : PS2_Host_Emulator port map (Clk => Clk, Reset => Reset, PS2_Clk => PS2_Clk, PS2_Data => PS2_Data, 
                                          Scan_Err => I_Scan_Err, Scan_Code => I_Scan_Code);

    LED_Drv : LED_Driver port map (Scan_Code => I_Scan_Code, Scan_Err => I_Scan_Err, Ds => Ds); 
end Structural;
