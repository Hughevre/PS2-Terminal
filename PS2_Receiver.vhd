----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hubert Zaj¹czkowski
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
           PS2_Clk      : in STD_LOGIC;
           PS2_Data     : in STD_LOGIC;
           Scan_Err     : out   STD_LOGIC;
           Scan_Code    : out   STD_LOGIC_VECTOR (7 downto 0);
           Scan_End     : out   STD_LOGIC);
end PS2_Receiver;

architecture RTL of PS2_Receiver is
    component Reduction_XOR is
        Generic ( N :       integer);
        Port    ( D : in    STD_LOGIC_VECTOR (N-1 downto 0);
                  O : out   STD_LOGIC);
    end component;
    
    type PS2_Receiver_States is (Idle, Start, Data_1, Data_2, 
                                 Data_3, Data_4, Data_5, Data_6,
                                 Data_7, Data_8, Parity, Stop);
                                 
    signal State_Reg, State_Next    : PS2_Receiver_States;
    signal Received_Data            : STD_LOGIC_VECTOR (7 downto 0); 
    signal Data_In_Enable           : STD_LOGIC;
    signal P_Reg, P_Next            : STD_LOGIC;
    signal R_XOR_Out                : STD_LOGIC;    
begin
    --Data path: functional unit
    R_XOR: Reduction_XOR
        generic map (N => 8)
        port map    (D => Received_Data, O => R_XOR_Out);
        
    --Data path: rolling register
    process (PS2_Clk, Reset)
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
    end process;
    
    --Control path: state register
    process (PS2_Clk, Reset)
    begin
        if Reset = '1' then
            State_Reg <= Idle;
        elsif falling_edge(PS2_Clk) then
            State_Reg <= State_Next;
        end if;
    end process;
    
    --Control path: next state logic
    process (State_Reg, PS2_Data)
    begin
    Data_In_Enable <= '0';
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
        when Stop =>
            if PS2_Data = '1' then
                State_Next <= Idle;
            else
                State_Next <= Stop; --If failure
            end if;
        end case;
    end process;
    
    --Control path: output logic
    Scan_End  <= '1' when State_Reg = Stop else '0';
    Scan_Code <= Received_Data when State_Reg = Stop else (others => '0');
    
    --Data path: data register
    process (PS2_Clk, Reset)
    begin
        if Reset = '1' then
            P_Reg <= '0';
        elsif falling_edge(PS2_Clk) then
            P_Reg <= P_Next;
        end if;
    end process;
    
    --Data path: routing multiplexer
    process (State_Reg, R_XOR_Out, PS2_Data)
    begin
        P_Next <= P_Reg;
        case State_Reg is
            when Idle =>
                P_Next <= '0';
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
                P_Next <= R_XOR_Out xor not PS2_Data;
            when Stop =>
         end case;
    end process;
    
    --Data path: output
    Scan_Err <= P_Reg;
end RTL;
