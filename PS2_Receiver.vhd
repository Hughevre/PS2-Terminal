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
use IEEE.Numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2_Receiver is
    Port ( Clk          : in    STD_LOGIC;
           Reset        : in    STD_LOGIC;
           PS2_Clk      : in    STD_LOGIC;
           PS2_Data     : in    STD_LOGIC;
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
    
    type PS2_Receiver_States is (Idle, Shift, Load);
                                 
    signal Falling_Edge_PS2             : STD_LOGIC;
    signal C_Flt_Reg, C_Flt_Next        : STD_LOGIC_VECTOR (7 downto 0); 
    signal Fall_Flt_Reg, Fall_Flt_Next  : STD_LOGIC;                            
    signal State_Reg, State_Next        : PS2_Receiver_States;
    signal Count_0                      : STD_LOGIC;
    signal Cnt_Reg, Cnt_Next            : UNSIGNED (3 downto 0);
    signal Received_Data                : STD_LOGIC_VECTOR (9 downto 0);
    signal Received_Data_Next           : STD_LOGIC_VECTOR (9 downto 0);  
    signal R_XOR_Out                    : STD_LOGIC;    
begin
    --Filter registers
    process (Clk, Reset)
    begin
        if Reset = '1' then
            C_Flt_Reg    <= (others => '0');
            Fall_Flt_Reg <= '0';
        elsif rising_edge(Clk) then
            C_Flt_Reg    <= C_Flt_Next;
            Fall_Flt_Reg <= Fall_Flt_Next;
        end if;
    end process;
    
    --Filter outputs
    C_Flt_Next <= PS2_Clk & C_Flt_Reg (7 downto 1); --Shifting register. Glitches shorter than 8 consecutives Clk ticks wiped out
    with C_Flt_Reg select Fall_Flt_Next <=
        '1' when "11111111",
        '0' when "00000000",
        Fall_Flt_Reg when others;
    Falling_Edge_PS2 <= Fall_Flt_Reg and (not Fall_Flt_Next);
    
    --Control path: state register
    process (Clk, Reset)
    begin
        if Reset = '1' then
            State_Reg <= Idle;
        elsif rising_edge(Clk) then
            State_Reg <= State_Next;
        end if;
    end process;
    
    --Control path: next state logic
    process (State_Reg, PS2_Data, Falling_Edge_PS2, Count_0)
    begin
        State_Next <= State_Reg;
        case State_Reg is 
        when Idle =>
            if Falling_Edge_PS2 = '1' and PS2_Data = '0' then --Start bit
                State_Next <= Shift;
            end if;
        when Shift =>
            if Falling_Edge_PS2 = '1' then
                if Count_0 = '1' then
                    State_Next <= Load;
                end if;
            end if;
        when Load =>
            State_Next <= Idle;
        end case;
    end process;
    
    --Control path: output logic
    Scan_End  <= '1' when State_Reg = Load else '0';
    
    --Data path: functional unit
    R_XOR: Reduction_XOR
        generic map (N => 8)
        port map    (D => Received_Data (7 downto 0), O => R_XOR_Out);
        
    --Data path: data register
    process (Clk, Reset)
    begin
        if Reset = '1' then
            Received_Data <= (others => '0');
            Cnt_Reg       <= (others => '0');
        elsif rising_edge(Clk) then
            Received_Data <= Received_Data_Next;
            Cnt_Reg       <= Cnt_Next;
        end if;
    end process;
    
    --Data path: routing multiplexer
    process (State_Reg, PS2_Data, Received_Data, Cnt_Reg, Falling_Edge_PS2)
    begin
        Received_Data_Next <= Received_Data;
        Cnt_Next           <= Cnt_Reg;
        case State_Reg is
            when Idle =>
                Received_Data_Next <= (others => '0');
                Cnt_Next <= "1001";
            when Shift =>
                if Falling_Edge_PS2 = '1' then
                    Received_Data_Next <= PS2_Data & Received_Data (9 downto 1);
                    Cnt_Next <= Cnt_Reg - 1;
                end if;
            when Load =>
         end case;
    end process;
    
    --Data path: output
    Count_0 <= '1' when State_Reg = Shift and Cnt_Reg = 0 else '0';
    Scan_Err <= R_XOR_Out xor not Received_Data(8) when State_Reg = Load else '0';
    Scan_Code <= Received_Data (7 downto 0) when State_Reg = Load else (others => '0');
end RTL;
