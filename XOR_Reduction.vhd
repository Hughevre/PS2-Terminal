----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.05.2019 14:37:34
-- Design Name: 
-- Module Name: XOR_Reduction - Behavioral
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

entity XOR_Reduction is
    Generic ( N        : integer);
    Port    ( Slv      : in    STD_LOGIC_VECTOR(N - 1 downto 0);
              En       : in    STD_LOGIC; 
              Res      : out   STD_LOGIC);
end XOR_Reduction;

architecture Behavioral of XOR_Reduction is
    signal I_Res : STD_LOGIC;
begin
    process (Slv)
        variable V_Res : std_logic := '1';
    begin
        for i in Slv'range loop
            V_Res := V_Res xor Slv(i);
        end loop;
        I_Res <= V_Res;
    end process;
    
    with En select Res <=
        I_Res when '1',
        '0' when others;
end Behavioral;
