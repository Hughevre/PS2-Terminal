----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2019 18:38:27
-- Design Name: 
-- Module Name: PS2_Receiver - Behavioral
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

entity PS2_Receiver is
    Port ( Reset        : in    STD_LOGIC;
           PS2_Clk      : inout STD_LOGIC;
           PS2_Data     : inout STD_LOGIC;
           Scan_Err     : out   STD_LOGIC;
           Scan_Code    : out   STD_LOGIC_VECTOR (7 downto 0);
           Scan_End     : out   STD_LOGIC);
end PS2_Receiver;

architecture RTL of PS2_Receiver is
    component XOR_Reduction is
        Generic ( N        :       integer);
        Port    ( Slv      : in    STD_LOGIC_VECTOR(N - 1 downto 0);
                  En       : in    STD_LOGIC; 
                  Res      : out   STD_LOGIC);
    end component;
    
    type PS2_Receiver_States is (Idle, Start, Data_1, Data_2, 
                                 Data_3, Data_4, Data_5, Data_6,
                                 Data_7, Data_8, Parity, Stop);
                                 
    signal State_Reg, State_Next    : PS2_Receiver_States;
    
    signal Received_Data            : STD_LOGIC_VECTOR (7 downto 0); 
    
    signal Data_In_Enable           : STD_LOGIC;
    signal Parity_From_R            : STD_LOGIC;
    signal XOR_R_Enable             : STD_LOGIC;
    signal Reg_Parity               : STD_LOGIC;
begin
    XOR_R: XOR_Reduction
        generic map(N => 8)
        port map(Slv => Received_Data, En => XOR_R_Enable, Res => Parity_From_R);
        
    Shift_Reg: process (Reset, PS2_Clk)
    begin
        if Reset = '1' then
            Received_Data <= (others => '0');
        elsif falling_edge(PS2_Clk) then
            if Data_In_Enable = '1' then
                Received_Data(7) <= PS2_Data;
                Shift:
                for i in 7 downto 1 loop
                    Received_Data(i - 1) <= Received_Data(i);
                end loop;
            end if;
        end if;
    end process Shift_Reg;
    
    Alter_State: process (PS2_Clk, Reset)
    begin
        if Reset = '1' then
            State_Reg <= Idle;
        elsif falling_edge(PS2_Clk) then
            State_Reg <= State_Next;
        end if;
    end process Alter_State;
    
    Receive_Data: process (State_Reg, PS2_Data)
    begin
    Data_In_Enable <= '0';
    XOR_R_Enable <= '0';
        case State_Reg is 
        when Idle =>
            if PS2_Data = '0' then --Start bit
                State_Next <= Start;
            else 
                State_Next <= Idle;
            end if;
        when Start =>
            Data_In_Enable <= '1';
            State_Next <= Data_1;
        when Data_1 =>
            Data_In_Enable <= '1';
            State_Next <= Data_2;
        when Data_2 =>
            Data_In_Enable <= '1';
            State_Next <= Data_3;
        when Data_3 =>
            Data_In_Enable <= '1';
            State_Next <= Data_4;
        when Data_4 =>
            Data_In_Enable <= '1';
            State_Next <= Data_5;
        when Data_5 =>
            Data_In_Enable <= '1';
            State_Next <= Data_6;
        when Data_6 =>
            Data_In_Enable <= '1';
            State_Next <= Data_7;
        when Data_7 =>
            Data_In_Enable <= '1';
            State_Next <= Data_8;
        when Data_8 =>
            State_Next <= Parity;
        when Parity =>
            State_Next <= Stop;
            XOR_R_Enable <= '1';
        when Stop =>
            if PS2_Data = '1' then
                State_Next <= Idle;
            else
                State_Next <= Start;
            end if;
        when others =>
            State_Next <= Idle;
        end case;
    end process Receive_Data;
    
    Decode_Output: process (State_Reg, PS2_Data)
    begin
    Scan_Err <= '0';
    Scan_Code <= (others => '0');
    Scan_End <= '0';
    case State_Reg is 
        when Idle =>
        when Start =>
        when Data_1 =>
        when Data_2 =>
        when Data_3 =>
        when Data_4 =>
        when Data_5 =>
        when Data_6 =>
        when Data_7 =>
        when Data_8 =>
        when Parity =>
            Reg_Parity <= Parity_From_R xor PS2_Data;
        when Stop =>
            Scan_Err <= Reg_Parity;
            Scan_End <= '1';
            Scan_Code <= Received_Data;
     end case;    
    end process Decode_Output;
end RTL;
