----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hubert Zaj¹czkowski
-- 
-- Create Date: 23.05.2019 17:52:09
-- Design Name: 
-- Module Name: PS2_Host_Emulator - RTL
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

entity PS2_Host_Emulator is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           PS2_Clk      : in    STD_LOGIC;
           PS2_Data     : in    STD_LOGIC;
           Scan_Err     : out   STD_LOGIC;
           Scan_Code    : out   STD_LOGIC_VECTOR (7 downto 0));
end PS2_Host_Emulator;

architecture Structural of PS2_Host_Emulator is
    component PS2_Receiver is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           PS2_Clk      : in    STD_LOGIC;
           PS2_Data     : in    STD_LOGIC;
           Scan_Err     : out   STD_LOGIC;
           Scan_Code    : out   STD_LOGIC_VECTOR (7 downto 0);
           Scan_End     : out   STD_LOGIC);
    end component;
    
    component PS2_Driver is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           Scan_Code    : in    STD_LOGIC_VECTOR (7 downto 0);
           Scan_End     : in    STD_LOGIC;
           K_Code       : out   STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal I_Scan_Code  : STD_LOGIC_VECTOR(7 downto 0);
    signal I_Scan_End   : STD_LOGIC;
begin
    Rcv     : PS2_Receiver port map (Clk => Clk, Reset => Reset, PS2_Clk => PS2_Clk, PS2_Data => PS2_Data, 
                                     Scan_Err => Scan_Err, Scan_Code => I_Scan_Code, Scan_End => I_Scan_End);
                                
    Drv     : PS2_Driver port map (Clk => Clk, Reset => Reset, Scan_Code => I_Scan_Code, Scan_End => I_Scan_End, K_Code => Scan_Code);
end Structural;
