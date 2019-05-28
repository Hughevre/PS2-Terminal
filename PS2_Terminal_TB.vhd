----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.05.2019 19:15:20
-- Design Name: 
-- Module Name: PS2_Terminal_TB - Behavioral
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

entity PS2_Terminal_TB is
    constant Period     : time := 50 ns; -- 20 MHz System Clock
    constant BitPeriod  : time := 60 us; -- Kbd Clock is 16.7 kHz max
end PS2_Terminal_TB;

architecture Behavioral of PS2_Terminal_TB is
    Component PS2_Terminal
    Port ( Clk        : in    std_logic; -- System Clock
		   Reset      : in    std_logic; -- System Reset
		   PS2_Clk    : in std_logic; -- Keyboard Clock Line
		   PS2_Data   : in std_logic; -- Keyboard Data Line
		   D_0        : out   std_logic;
           D_1        : out   std_logic;
           D_2        : out   std_logic;
           D_3        : out   std_logic;
           D_4        : out   std_logic;
           D_5        : out   std_logic;
           D_6        : out   std_logic;
           D_7        : out   std_logic);
	end component;
	
	signal Clk        : std_logic := '0';
	signal Reset      : std_logic;
	signal PS2_Clk    : std_logic := 'H';
	signal PS2_Data   : std_logic := 'H';
	signal D_0        : std_logic := '0';
	signal D_1        : std_logic := '0';
	signal D_2        : std_logic := '0';
	signal D_3        : std_logic := '0';
	signal D_4        : std_logic := '0';
	signal D_5        : std_logic := '0';
	signal D_6        : std_logic := '0';
	signal D_7        : std_logic := '0';
	
    type Code_A is
        record
		  Code : std_logic_vector (7 downto 0);
		  Err  : Std_logic; -- note: '1' => parity error
	end record;
	
	type Codes_Table_T is array (natural range <>) of Code_A;
	
	constant Codes_Table : Codes_Table_T 
	 := ( (x"A5",'0'), (x"5A",'0'), (x"00",'0'), (x"FF",'0'),
	 (x"12",'0'), (x"34",'0'), (x"56",'1'), (x"56",'0'),
	 (x"78",'0'), (x"BC",'0') );
	 
	 signal Succeeded : boolean := true;
	 
	 function Reduction(A : STD_LOGIC_VECTOR) return STD_LOGIC is
        variable S : STD_LOGIC := '1';
    begin
        for i in A'range loop
            S := S xor A(i);
        end loop;
        return S;
    end function;
begin
    UUT: PS2_Terminal port map ( 
             Clk => Clk,
			 Reset => Reset,
			 PS2_Clk => PS2_Clk,
			 PS2_Data => PS2_Data,
			 D_0 => D_0, 
			 D_1 => D_1, 
			 D_2 => D_2, 
			 D_3 => D_3,
			 D_4 => D_4, 
			 D_5 => D_5, 
			 D_6 => D_6, 
			 D_7 => D_7);
			 
			 Clk <= not Clk after (Period / 2);
			 Reset <= '1', '0' after Period;
			  
	Emit: process is
	   procedure SendCode ( D : std_logic_vector(7 downto 0); Err : std_logic := '0') is
	       begin
			 PS2_Clk  <= 'H';
			 PS2_Data <= 'H';
			 -- (1) verify that Clk was Idle (high) at least for 50 us.
			 wait for (BitPeriod / 2);
				 -- Start bit
				 PS2_Data <= '0';
				 
			 wait for (BitPeriod / 2);
				 PS2_Clk <= '0'; 
				 
			 wait for (BitPeriod / 2);
				 PS2_Clk <= '1';
			 
			 -- Data Bits
			 for i in 0 to 7 loop
				 PS2_Data <= D(i);
				 wait for (BitPeriod / 2);
					 PS2_Clk <= '0'; wait for (BitPeriod / 2);
					 PS2_Clk <= '1';
			 end loop;
			 
			 -- Odd Parity bit
			 PS2_Data <= Err xor not Reduction(D);
			 
			 wait for (BitPeriod / 2);
				 PS2_Clk <= '0'; wait for (BitPeriod / 2);
				 PS2_Clk <= '1';
				 -- Stop bit
				 PS2_Data <= '1';
				 
			 wait for (BitPeriod / 2);
				 PS2_Clk <= '0'; wait for (BitPeriod / 2);
				 PS2_Clk <= '1';
				 PS2_Data <= 'H';
				
			wait for (BitPeriod * 3);
	end procedure SendCode; 
	begin 
	   Wait for 60ns;
			 -- Send the Test Frames
			 for i in Codes_Table'range loop
				SendCode (Codes_Table(i).Code, Codes_Table(i).Err);
			 end loop;
			 
			 
			 if not Succeeded then
			     report "End of simulation : " & Lf &
				 " There have been errors in the Data / Err read !"
				 severity failure;
			 else
				 report Lf & " SUCCESSFULL End of simulation : " & Lf &
				 " There has been no (zero) error !" & Lf & Ht
				 severity note;
				 report "End of Simulation" severity failure;
			 end if;
	end process Emit;
end Behavioral;
