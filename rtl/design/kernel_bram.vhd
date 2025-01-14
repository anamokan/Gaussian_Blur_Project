----------------------------------------------------------------------------------
-- Company: y24-g03
-- Engineers: Power_Puff_Girls 
-- Create Date: 23.07.2024 21:01:16
-- Design Name: 
-- Module Name: exp_rom - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kernel_bram is
    generic (
        WIDTH: positive := 16; --  I = 2, W = 16 signed
        SIZE: positive := 625; 
        SIZE_WIDTH: positive := 10 -- vezano za adresu 
    );
    port (
        clk : in std_logic;
        
        --- IPB interface ---
        en: in std_logic;
        addr: in std_logic_vector(SIZE_WIDTH - 1 downto 0);
        data: out std_logic_vector(WIDTH - 1 downto 0);
        
        --- CPU interface ---
        en_b: in std_logic;
        we_b: in std_logic_vector(3 downto 0);
        addr_b: in std_logic_vector(SIZE_WIDTH - 1 downto 0);
        data_b: in std_logic_vector(WIDTH - 1 downto 0)
    );
end kernel_bram;

architecture Behavioral of kernel_bram is

    type ram_type is array(0 to SIZE - 1) of std_logic_vector(WIDTH - 1 downto 0);
    signal RAM: ram_type;
    
    attribute ram_style: string;
    attribute ram_style of RAM: signal is "block";
begin
  
    process(clk)
    begin
        if(rising_edge(clk)) then
            if (en = '1') then
                data <= RAM(to_integer(unsigned(addr)));
            end if;
        end if;        
    end process;
    
    process(clk)
    begin
        if(rising_edge(clk)) then
            if (en_b = '1') then
                if (we_b /= "0000") then
                    RAM(to_integer(unsigned(addr_b))) <= data_b;
                end if;
            end if;
        end if;         
    end process;
    
    
    
end Behavioral;
