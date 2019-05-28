----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.05.2019 17:31:54
-- Design Name: 
-- Module Name: Reduction_XOR - Behavioral
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

entity Reduction_XOR is
    Generic ( N :       integer);
    Port    ( D : in    STD_LOGIC_VECTOR (N-1 downto 0);
              O : out   STD_LOGIC);
end Reduction_XOR;

architecture Behavioral of Reduction_XOR is
    function Reduction(A : STD_LOGIC_VECTOR) return STD_LOGIC is
        variable S : STD_LOGIC := '1';
    begin
        for i in A'range loop
            S := S xor A(i);
        end loop;
        return S;
    end function;
begin
    O <= Reduction(D);
end Behavioral;
