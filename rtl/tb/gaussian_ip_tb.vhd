----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2024 11:01:55 PM
-- Design Name: 
-- Module Name: gaussian_ip_tb - Behavioral
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
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use std.textio.all;
use work.txt_util.all;

entity gaussian_ip_tb is
--  Port ( );
end gaussian_ip_tb;

architecture Behavioral of gaussian_ip_tb is
    
    constant DRAM_DATA_WIDTH: positive := 8;
    constant DRAM_SIZE: positive := 792000;   
    type ram_type is array(0 to DRAM_SIZE-1) of std_logic_vector(DRAM_DATA_WIDTH - 1 downto 0);
	  
    constant KERNEL_DATA_WIDTH: positive := 16;
    constant KERNEL_SIZE: positive := 9;
    type rom_type is array(0 to KERNEL_SIZE - 1) of std_logic_vector(KERNEL_DATA_WIDTH - 1 downto 0);
    
    constant KERNEL_CONTENT: rom_type := (
		B"0001001100111011",
		B"0001111110110100",
		B"0001001100111011",
		B"0001111110110100",
		B"0011010001000101",
		B"0001111110110100",
		B"0001001100111011",
		B"0001111110110100",
		B"0001001100111011"
        );
    
    constant KERNEL_DATA_WIDTH_25: positive := 16;
    constant KERNEL_SIZE_25: positive := 625;
    type rom_type_25 is array(0 to KERNEL_SIZE_25 - 1) of std_logic_vector(KERNEL_DATA_WIDTH_25 - 1 downto 0);
        
    constant KERNEL_CONTENT_25: rom_type_25 := (
		B"0000000000000000", B"0000000000000000", B"0000000000000000", B"0000000000000001", B"0000000000000001",
		B"0000000000000010", B"0000000000000010", B"0000000000000011", B"0000000000000100", B"0000000000000101",
		B"0000000000000110", B"0000000000000111", B"0000000000000111", B"0000000000000111", B"0000000000000110",
		B"0000000000000101", B"0000000000000100", B"0000000000000011", B"0000000000000010", B"0000000000000010",
		B"0000000000000001", B"0000000000000001", B"0000000000000000", B"0000000000000000", B"0000000000000000",
		B"0000000000000000", B"0000000000000000", B"0000000000000001", B"0000000000000001", B"0000000000000010",
		B"0000000000000011", B"0000000000000101", B"0000000000000111", B"0000000000001001", B"0000000000001011",
		B"0000000000001101", B"0000000000001110", B"0000000000001111", B"0000000000001110", B"0000000000001101",
		B"0000000000001011", B"0000000000001001", B"0000000000000111", B"0000000000000101", B"0000000000000011",
        B"0000000000000010", B"0000000000000001", B"0000000000000001", B"0000000000000000", B"0000000000000000",
		B"0000000000000000",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000110",
		B"0000000000001001",
		B"0000000000001101",
		B"0000000000010001",
		B"0000000000010110",
		B"0000000000011001",
		B"0000000000011100",
		B"0000000000011101",
		B"0000000000011100",
		B"0000000000011001",
		B"0000000000010110",
		B"0000000000010001",
		B"0000000000001101",
		B"0000000000001001",
		B"0000000000000110",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000000",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000111",
		B"0000000000001011",
		B"0000000000010001",
		B"0000000000011000",
		B"0000000000100000",
		B"0000000000100111",
		B"0000000000101110",
		B"0000000000110010",
		B"0000000000110100",
		B"0000000000110010",
		B"0000000000101110",
		B"0000000000100111",
		B"0000000000100000",
		B"0000000000011000",
		B"0000000000010001",
		B"0000000000001011",
		B"0000000000000111",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000111",
		B"0000000000001100",
		B"0000000000010011",
		B"0000000000011101",
		B"0000000000101001",
		B"0000000000110110",
		B"0000000001000011",
		B"0000000001001110",
		B"0000000001010110",
		B"0000000001011001",
		B"0000000001010110",
		B"0000000001001110",
		B"0000000001000011",
		B"0000000000110110",
		B"0000000000101001",
		B"0000000000011101",
		B"0000000000010011",
		B"0000000000001100",
		B"0000000000000111",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000011",
		B"0000000000000110",
		B"0000000000001011",
		B"0000000000010011",
		B"0000000000011111",
		B"0000000000101110",
		B"0000000001000001",
		B"0000000001010110",
		B"0000000001101011",
		B"0000000001111101",
		B"0000000010001001",
		B"0000000010001101",
		B"0000000010001001",
		B"0000000001111101",
		B"0000000001101011",
		B"0000000001010110",
		B"0000000001000001",
		B"0000000000101110",
		B"0000000000011111",
		B"0000000000010011",
		B"0000000000001011",
		B"0000000000000110",
		B"0000000000000011",
		B"0000000000000010",
		B"0000000000000010",
		B"0000000000000101",
		B"0000000000001001",
		B"0000000000010001",
		B"0000000000011101",
		B"0000000000101110",
		B"0000000001000101",
		B"0000000001100001",
		B"0000000010000001",
		B"0000000010100000",
		B"0000000010111011",
		B"0000000011001110",
		B"0000000011010100",
		B"0000000011001110",
		B"0000000010111011",
		B"0000000010100000",
		B"0000000010000001",
		B"0000000001100001",
		B"0000000001000101",
		B"0000000000101110",
		B"0000000000011101",
		B"0000000000010001",
		B"0000000000001001",
		B"0000000000000101",
		B"0000000000000010",
		B"0000000000000011",
		B"0000000000000111",
		B"0000000000001101",
		B"0000000000011000",
		B"0000000000101001",
		B"0000000001000001",
		B"0000000001100001",
		B"0000000010001001",
		B"0000000010110110",
		B"0000000011100010",
		B"0000000100001000",
		B"0000000100100010",
		B"0000000100101011",
		B"0000000100100010",
		B"0000000100001000",
		B"0000000011100010",
		B"0000000010110110",
		B"0000000010001001",
		B"0000000001100001",
		B"0000000001000001",
		B"0000000000101001",
		B"0000000000011000",
		B"0000000000001101",
		B"0000000000000111",
		B"0000000000000011",
		B"0000000000000100",
		B"0000000000001001",
		B"0000000000010001",
		B"0000000000100000",
		B"0000000000110110",
		B"0000000001010110",
		B"0000000010000001",
		B"0000000010110110",
		B"0000000011110001",
		B"0000000100101011",
		B"0000000101011110",
		B"0000000110000001",
		B"0000000110001101",
		B"0000000110000001",
		B"0000000101011110",
		B"0000000100101011",
		B"0000000011110001",
		B"0000000010110110",
		B"0000000010000001",
		B"0000000001010110",
		B"0000000000110110",
		B"0000000000100000",
		B"0000000000010001",
		B"0000000000001001",
		B"0000000000000100",
		B"0000000000000101",
		B"0000000000001011",
		B"0000000000010110",
		B"0000000000100111",
		B"0000000001000011",
		B"0000000001101011",
		B"0000000010100000",
		B"0000000011100010",
		B"0000000100101011",
		B"0000000101110101",
		B"0000000110110100",
		B"0000000111011111",
		B"0000000111101110",
		B"0000000111011111",
		B"0000000110110100",
		B"0000000101110101",
		B"0000000100101011",
		B"0000000011100010",
		B"0000000010100000",
		B"0000000001101011",
		B"0000000001000011",
		B"0000000000100111",
		B"0000000000010110",
		B"0000000000001011",
		B"0000000000000101",
		B"0000000000000110",
		B"0000000000001101",
		B"0000000000011001",
		B"0000000000101110",
		B"0000000001001110",
		B"0000000001111101",
		B"0000000010111011",
		B"0000000100001000",
		B"0000000101011110",
		B"0000000110110100",
		B"0000000111111101",
		B"0000001000110000",
		B"0000001001000001",
		B"0000001000110000",
		B"0000000111111101",
		B"0000000110110100",
		B"0000000101011110",
		B"0000000100001000",
		B"0000000010111011",
		B"0000000001111101",
		B"0000000001001110",
		B"0000000000101110",
		B"0000000000011001",
		B"0000000000001101",
		B"0000000000000110",
		B"0000000000000111",
		B"0000000000001110",
		B"0000000000011100",
		B"0000000000110010",
		B"0000000001010110",
		B"0000000010001001",
		B"0000000011001110",
		B"0000000100100010",
		B"0000000110000001",
		B"0000000111011111",
		B"0000001000110000",
		B"0000001001100111",
		B"0000001001111010",
		B"0000001001100111",
		B"0000001000110000",
		B"0000000111011111",
		B"0000000110000001",
		B"0000000100100010",
		B"0000000011001110",
		B"0000000010001001",
		B"0000000001010110",
		B"0000000000110010",
		B"0000000000011100",
		B"0000000000001110",
		B"0000000000000111",
		B"0000000000000111",
		B"0000000000001111",
		B"0000000000011101",
		B"0000000000110100",
		B"0000000001011001",
		B"0000000010001101",
		B"0000000011010100",
		B"0000000100101011",
		B"0000000110001101",
		B"0000000111101110",
		B"0000001001000001",
		B"0000001001111010",
		B"0000001010001110",
		B"0000001001111010",
		B"0000001001000001",
		B"0000000111101110",
		B"0000000110001101",
		B"0000000100101011",
		B"0000000011010100",
		B"0000000010001101",
		B"0000000001011001",
		B"0000000000110100",
		B"0000000000011101",
		B"0000000000001111",
		B"0000000000000111",
		B"0000000000000111",
		B"0000000000001110",
		B"0000000000011100",
		B"0000000000110010",
		B"0000000001010110",
		B"0000000010001001",
		B"0000000011001110",
		B"0000000100100010",
		B"0000000110000001",
		B"0000000111011111",
		B"0000001000110000",
		B"0000001001100111",
		B"0000001001111010",
		B"0000001001100111",
		B"0000001000110000",
		B"0000000111011111",
		B"0000000110000001",
		B"0000000100100010",
		B"0000000011001110",
		B"0000000010001001",
		B"0000000001010110",
		B"0000000000110010",
		B"0000000000011100",
		B"0000000000001110",
		B"0000000000000111",
		B"0000000000000110",
		B"0000000000001101",
		B"0000000000011001",
		B"0000000000101110",
		B"0000000001001110",
		B"0000000001111101",
		B"0000000010111011",
		B"0000000100001000",
		B"0000000101011110",
		B"0000000110110100",
		B"0000000111111101",
		B"0000001000110000",
		B"0000001001000001",
		B"0000001000110000",
		B"0000000111111101",
		B"0000000110110100",
		B"0000000101011110",
		B"0000000100001000",
		B"0000000010111011",
		B"0000000001111101",
		B"0000000001001110",
		B"0000000000101110",
		B"0000000000011001",
		B"0000000000001101",
		B"0000000000000110",
		B"0000000000000101",
		B"0000000000001011",
		B"0000000000010110",
		B"0000000000100111",
		B"0000000001000011",
		B"0000000001101011",
		B"0000000010100000",
		B"0000000011100010",
		B"0000000100101011",
		B"0000000101110101",
		B"0000000110110100",
		B"0000000111011111",
		B"0000000111101110",
		B"0000000111011111",
		B"0000000110110100",
		B"0000000101110101",
		B"0000000100101011",
		B"0000000011100010",
		B"0000000010100000",
		B"0000000001101011",
		B"0000000001000011",
		B"0000000000100111",
		B"0000000000010110",
		B"0000000000001011",
		B"0000000000000101",
		B"0000000000000100",
		B"0000000000001001",
		B"0000000000010001",
		B"0000000000100000",
		B"0000000000110110",
		B"0000000001010110",
		B"0000000010000001",
		B"0000000010110110",
		B"0000000011110001",
		B"0000000100101011",
		B"0000000101011110",
		B"0000000110000001",
		B"0000000110001101",
		B"0000000110000001",
		B"0000000101011110",
		B"0000000100101011",
		B"0000000011110001",
		B"0000000010110110",
		B"0000000010000001",
		B"0000000001010110",
		B"0000000000110110",
		B"0000000000100000",
		B"0000000000010001",
		B"0000000000001001",
		B"0000000000000100",
		B"0000000000000011",
		B"0000000000000111",
		B"0000000000001101",
		B"0000000000011000",
		B"0000000000101001",
		B"0000000001000001",
		B"0000000001100001",
		B"0000000010001001",
		B"0000000010110110",
		B"0000000011100010",
		B"0000000100001000",
		B"0000000100100010",
		B"0000000100101011",
		B"0000000100100010",
		B"0000000100001000",
		B"0000000011100010",
		B"0000000010110110",
		B"0000000010001001",
		B"0000000001100001",
		B"0000000001000001",
		B"0000000000101001",
		B"0000000000011000",
		B"0000000000001101",
		B"0000000000000111",
		B"0000000000000011",
		B"0000000000000010",
		B"0000000000000101",
		B"0000000000001001",
		B"0000000000010001",
		B"0000000000011101",
		B"0000000000101110",
		B"0000000001000101",
		B"0000000001100001",
		B"0000000010000001",
		B"0000000010100000",
		B"0000000010111011",
		B"0000000011001110",
		B"0000000011010100",
		B"0000000011001110",
		B"0000000010111011",
		B"0000000010100000",
		B"0000000010000001",
		B"0000000001100001",
		B"0000000001000101",
		B"0000000000101110",
		B"0000000000011101",
		B"0000000000010001",
		B"0000000000001001",
		B"0000000000000101",
		B"0000000000000010",
		B"0000000000000010",
		B"0000000000000011",
		B"0000000000000110",
		B"0000000000001011",
		B"0000000000010011",
		B"0000000000011111",
		B"0000000000101110",
		B"0000000001000001",
		B"0000000001010110",
		B"0000000001101011",
		B"0000000001111101",
		B"0000000010001001",
		B"0000000010001101",
		B"0000000010001001",
		B"0000000001111101",
		B"0000000001101011",
		B"0000000001010110",
		B"0000000001000001",
		B"0000000000101110",
		B"0000000000011111",
		B"0000000000010011",
		B"0000000000001011",
		B"0000000000000110",
		B"0000000000000011",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000111",
		B"0000000000001100",
		B"0000000000010011",
		B"0000000000011101",
		B"0000000000101001",
		B"0000000000110110",
		B"0000000001000011",
		B"0000000001001110",
		B"0000000001010110",
		B"0000000001011001",
		B"0000000001010110",
		B"0000000001001110",
		B"0000000001000011",
		B"0000000000110110",
		B"0000000000101001",
		B"0000000000011101",
		B"0000000000010011",
		B"0000000000001100",
		B"0000000000000111",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000111",
		B"0000000000001011",
		B"0000000000010001",
		B"0000000000011000",
		B"0000000000100000",
		B"0000000000100111",
		B"0000000000101110",
		B"0000000000110010",
		B"0000000000110100",
		B"0000000000110010",
		B"0000000000101110",
		B"0000000000100111",
		B"0000000000100000",
		B"0000000000011000",
		B"0000000000010001",
		B"0000000000001011",
		B"0000000000000111",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000000",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000100",
		B"0000000000000110",
		B"0000000000001001",
		B"0000000000001101",
		B"0000000000010001",
		B"0000000000010110",
		B"0000000000011001",
		B"0000000000011100",
		B"0000000000011101",
		B"0000000000011100",
		B"0000000000011001",
		B"0000000000010110",
		B"0000000000010001",
		B"0000000000001101",
		B"0000000000001001",
		B"0000000000000110",
		B"0000000000000100",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000011",
		B"0000000000000101",
		B"0000000000000111",
		B"0000000000001001",
		B"0000000000001011",
		B"0000000000001101",
		B"0000000000001110",
		B"0000000000001111",
		B"0000000000001110",
		B"0000000000001101",
		B"0000000000001011",
		B"0000000000001001",
		B"0000000000000111",
		B"0000000000000101",
		B"0000000000000011",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000010",
		B"0000000000000010",
		B"0000000000000011",
		B"0000000000000100",
		B"0000000000000101",
		B"0000000000000110",
		B"0000000000000111",
		B"0000000000000111",
		B"0000000000000111",
		B"0000000000000110",
		B"0000000000000101",
		B"0000000000000100",
		B"0000000000000011",
		B"0000000000000010",
		B"0000000000000010",
		B"0000000000000001",
		B"0000000000000001",
		B"0000000000000000",
		B"0000000000000000",
		B"0000000000000000"
        );      
	----------------------------------------
	impure function init_dram return ram_type is
	  file text_file : text open read_mode is "/home/amokan/Documents/4_godina/PROJEKAT/II_deo/naopacke_pa_binarno.txt";
	  variable text_line : line;
	  variable dram_content : ram_type;
    begin   
        for i in 0 to DRAM_SIZE - 1 loop
            readline(text_file,text_line);
            dram_content(i) := to_std_logic_vector(string(text_line));           
        end loop;		
	    return dram_content;
    end function;
-----------------------------------------------------------------
file text_file_out : text open write_mode is "/home/amokan/Documents/4_godina/PROJEKAT/II_deo/results_rtl.txt";
-----------------------

	impure function init_dram3 return ram_type is
	  file text_file : text open read_mode is "/home/amokan/Documents/4_godina/PROJEKAT/II_deo/results_rtl3.txt";
	  variable text_line : line;
	  variable dram_content3 : ram_type;
    begin
        for i in 0 to DRAM_SIZE - 1 loop
            readline(text_file,text_line);
            dram_content3(i) := to_std_logic_vector(string(text_line));           
        end loop;
	    return dram_content3;  
    end function;
-----------------------------------------------------------------
file text_file_out25 : text open write_mode is "/home/amokan/Documents/4_godina/PROJEKAT/II_deo/results_rtl25.txt"; 
 
        
    constant dram_content: ram_type := init_dram;
    constant dram_content3: ram_type := init_dram3;

    signal kernel_en_s: std_logic := '0';
    signal kernel_we_s: std_logic_vector(3 downto 0) := (others => '0');
    signal kernel_addr_s: std_logic_vector(11 downto 0) := (others => '0');
    signal kernel_data_s: std_logic_vector(31 downto 0) := (others => '0');
    
    signal axis_wdata_s, axis_rdata_s: std_logic_vector(31 downto 0) := (others => '0');
    signal axis_wvalid_s, axis_wready_s, axis_wlast_s, axis_rvalid_s, axis_rready_s, axis_rlast_s: std_logic := '0';
    
    signal clk_s: std_logic;
    signal laxi_aresetn_s: std_logic := '0';
    signal laxi_awaddr_s, laxi_araddr_s: std_logic_vector(3 downto 0)  := (others => '0'); 
    signal laxi_awprot_s, laxi_arprot_s: std_logic_vector(2 downto 0)  := (others => '0');
    signal laxi_awvalid_s, laxi_awready_s, laxi_wvalid_s, laxi_wready_s: std_logic := '0';
    signal laxi_wdata_s, laxi_rdata_s: std_logic_vector(31 downto 0) := (others => '0');
    signal laxi_wstrb_s: std_logic_vector(3 downto 0):= (others => '0');
    signal laxi_bresp_s, laxi_rresp_s: std_logic_vector(1 downto 0):= (others => '0');
    signal laxi_bvalid_s, laxi_bready_s: std_logic := '0';
    signal laxi_arvalid_s, laxi_arready_s, laxi_rvalid_s, laxi_rready_s: std_logic := '0';   
    
    constant START_REG_ADDR_C: positive := 0;
    constant KERNEL_SIZE_ADDR_C: positive := 4; 
    constant RESET_REG_ADDR_C: positive := 8;
    constant READY_REG_ADDR_C: positive := 12;
    
    constant AXI_DATA_WIDTH	: integer	:= 32;
    constant AXI_ADDR_WIDTH	: integer	:= 4;
    
    shared variable kernel_cnt: integer := 0;
    shared variable dma_flag: integer := 0;

begin

dut: entity work.apply_gaussian_blur_v1_0
    Port map(
        kernel_bram_en_i => kernel_en_s,
        kernel_bram_we_i => kernel_we_s,
        kernel_bram_addr_i => kernel_addr_s,
        kernel_bram_data_i => kernel_data_s,
        
        axis_wdata_o => axis_wdata_s,
        axis_wvalid_o => axis_wvalid_s,     
        axis_wready_i => axis_wready_s,
        axis_wlast_o => axis_wlast_s,    
        axis_rdata_i => axis_rdata_s,   
        axis_rvalid_i => axis_rvalid_s,   
        axis_rready_o => axis_rready_s,
        axis_rlast_i => axis_rlast_s,
        
 		s00_axi_aclk	=> clk_s,
		s00_axi_aresetn	=> laxi_aresetn_s,
		s00_axi_awaddr	=> laxi_awaddr_s,
		s00_axi_awprot	=> laxi_awprot_s,
		s00_axi_awvalid	=> laxi_awvalid_s,
		s00_axi_awready	=> laxi_awready_s,
		s00_axi_wdata	=> laxi_wdata_s,
		s00_axi_wstrb	=> laxi_wstrb_s,
		s00_axi_wvalid	=> laxi_wvalid_s,
		s00_axi_wready	=> laxi_wready_s,
		s00_axi_bresp	=> laxi_bresp_s,
		s00_axi_bvalid	=> laxi_bvalid_s,
		s00_axi_bready	=> laxi_bready_s,
		s00_axi_araddr	=> laxi_araddr_s,
		s00_axi_arprot	=> laxi_arprot_s,
		s00_axi_arvalid	=> laxi_arvalid_s,
		s00_axi_arready	=> laxi_arready_s,
		s00_axi_rdata	=> laxi_rdata_s,
		s00_axi_rresp	=> laxi_rresp_s,
		s00_axi_rvalid	=> laxi_rvalid_s,
		s00_axi_rready => laxi_rready_s     
    );
    
    
clk_gen: process
begin
    clk_s <= '0', '1' after 5 ns;
    wait for 10 ns;
end process;





data_gen: process(clk_s)
variable counter : integer := 2160;
variable counter_25: integer := 18000;
variable init_i: integer := 0;
variable init_j: integer := 0;
variable init_i25: integer := 0;
variable init_j25: integer := 0;
begin
    if(rising_edge(clk_s)) then
        if(dma_flag = 0) then
            if(init_j <= 2 and init_i <= 359)then
                axis_rvalid_s <= '1';
                if(axis_rready_s = '1') then
                    if(init_j = 2 and init_i = 359) then
                        axis_rlast_s <= '1';
                    else
                        axis_rlast_s <= '0';
                    end if;        
                        axis_rdata_s <= "0000000000000000"&dram_content(init_j*720 + 2*init_i)&dram_content(init_j*720+ 2*init_i + 1);                                
                    if(init_i = 359) then
                        init_i := 0;
                        init_j := init_j + 1;
                    else
                        init_i := init_i + 1;    
                    end if;
                end if;
            else
               -- init_i := 0;
               -- init_j := 0;
                axis_rvalid_s <= '0';
                axis_rlast_s <= '0';
                axis_rdata_s <= (others => '0');
          --      dma_flag := 1;
            end if;
        elsif(dma_flag = 1) then
            if(counter < 791999) then
                axis_rvalid_s <= '1';   
                if(counter = 791998) then
                    axis_rlast_s <= '1';
                else
                    axis_rlast_s <= '0';
                end if;                      
                if(axis_rready_s = '1') then
                    axis_rdata_s <= "0000000000000000"&dram_content(counter)&dram_content(counter+1);
                    counter := counter + 2;
                else
                    counter := counter;
                end if;         
            else
                --counter := 18000;
                axis_rvalid_s <= '0';
                axis_rlast_s <= '0';
                axis_rdata_s <= (others => '0');
            --    dma_flag := 3;
            end if;    
        elsif(dma_flag = 2) then    
            if(init_j25 <= 24 and init_i25 <= 359)then
                axis_rvalid_s <= '1';
                if(axis_rready_s = '1') then
                    if(init_j25 = 24 and init_i25 = 359) then
                        axis_rlast_s <= '1';
                    else
                        axis_rlast_s <= '0';
                    end if;        
                        axis_rdata_s <= "0000000000000000"&dram_content3(init_j25*720 + 2*init_i25)&dram_content3(init_j25*720+ 2*init_i25 + 1);                             
                    if(init_i25 = 359) then
                        init_i25 := 0;
                        init_j25 := init_j25 + 1;
                    else
                        init_i25 := init_i25 + 1;    
                    end if;
                end if;
            else
                --init_i := 0;
                --init_j := 0;
                axis_rvalid_s <= '0';
                axis_rlast_s <= '0';
                axis_rdata_s <= (others => '0');
               -- dma_flag := 5;
            end if;    
        elsif(dma_flag = 3) then
            if(counter_25 < 791999) then
                axis_rvalid_s <= '1';  
                if(counter_25 = 791998) then
                    axis_rlast_s <= '1';
                else
                    axis_rlast_s <= '0';
                end if;     
                if(axis_rready_s = '1') then
                    axis_rdata_s <= "0000000000000000"&dram_content3(counter_25)&dram_content3(counter_25+1);
                    counter_25 := counter_25 + 2;
                else
                    counter_25 := counter_25;
                end if;           
            else
                --counter := 0;
                axis_rvalid_s <= '0';
                axis_rlast_s <= '0';
                axis_rdata_s <= (others => '0');
              --  dma_flag := 7;
            end if;          
        else
            --counter := 2160;
            axis_rvalid_s <= '0';
            axis_rlast_s <= '0';            
            axis_rdata_s <= (others => '0');
           -- dma_flag := 5;
        end if;        
    end if;
end process;




stim_gen: process
variable cnt : integer := 2160;
variable axi_read_data_v: std_logic_vector(31 downto 0);
begin    

----------------------------- 3x3 -----------------------------------------------------------------

-------------- AXI Lite reset ---------------
    laxi_aresetn_s <= '0';
    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;
    laxi_aresetn_s <= '1';
    wait until falling_edge(clk_s);
    
    laxi_awaddr_s <= conv_std_logic_vector(RESET_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(1, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    
    wait until falling_edge(clk_s); 
    laxi_awaddr_s <= conv_std_logic_vector(RESET_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 
    

-------------- KERNEL BRAM INIT ---------------

    wait until rising_edge(clk_s);    
    kernel_en_s <= '1';
    kernel_we_s <= "1111";
    for i in 0 to KERNEL_SIZE - 1 loop
        kernel_addr_s <= conv_std_logic_vector(i*4, kernel_addr_s'length);
        kernel_data_s <= "0000000000000000"&KERNEL_CONTENT(i);
        wait until rising_edge(clk_s);
    end loop;
    kernel_en_s <= '0';
    kernel_we_s <= "0000";   
    
    -------------- IMG BRAM INIT ---------------

    
    wait until rising_edge(clk_s);
--    for j in 0 to 2 loop
--    for i in 0 to 359 loop
--       axis_rvalid_s <= '1';
--       if axis_rready_s = '1' then
--        if(j = 2 and i = 359) then
--            axis_rlast_s <= '1';
--        else
--            axis_rlast_s <= '0';
--        end if;        
--        axis_rdata_s <= dram_content(j*720 + 2*i)&dram_content(j*720+ 2*i + 1);
--        wait until rising_edge(clk_s);
--       else
--            wait until axis_rready_s = '1';
--       end if;  
--    end loop;
--    end loop;    
--    axis_rvalid_s <= '0';   
--    axis_rlast_s <= '0';
    wait until axis_rlast_s = '1';

    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    dma_flag := 1;
    
--    laxi_aresetn_s <= '0';
--    for i in 1 to 2 loop
--        wait until falling_edge(clk_s);
--    end loop;
--    laxi_aresetn_s <= '1';
--    wait until rising_edge(clk_s);
    
    ------------ AXI Lite write kernel size ---------------
    
    laxi_awaddr_s <= conv_std_logic_vector(KERNEL_SIZE_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(3, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 


    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;

    -------------- AXI Lite write start ---------------

    laxi_awaddr_s <= conv_std_logic_vector(START_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(1, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';   
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 

    axis_wready_s <= '1';
    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;
    
    -------------- AXI Stream cache add ---------------
               
--    axis_rvalid_s <= '1';
--    while(axis_rlast_s /= '1') loop
--        if(cnt = 791998) then
--            axis_rlast_s <= '1';
--        else
--            axis_rlast_s <= '0';
--        end if;    
--        if(axis_rready_s = '1') then
--            axis_rdata_s <= dram_content(cnt)&dram_content(cnt+1);
--            cnt := cnt + 2;
--        else
--            cnt := cnt;
--        end if;  
--        wait until rising_edge(clk_s);
--    end loop;
--    axis_rvalid_s <= '0';
--    axis_rlast_s <= '0';

  --  wait until axis_wlast_s <= '1';
  --  wait until rising_edge(clk_s);
  --  axis_wready_s <= '0';
    
    -------------- AXI Lite read READY ---------------
    
    --wait until dma_flag = 3;
    wait until axis_rlast_s = '1';


    
    loop
        if(axis_wlast_s = '1') then
            axis_wready_s <= '0';
        end if;    
        wait until falling_edge(clk_s);
        laxi_araddr_s <= conv_std_logic_vector(READY_REG_ADDR_C, AXI_ADDR_WIDTH);
        laxi_arvalid_s <= '1';
        laxi_rready_s <= '1';
        wait until laxi_arready_s = '1';
        axi_read_data_v := laxi_rdata_s;
        wait until laxi_arready_s = '0';
        wait until falling_edge(clk_s);    
          
        laxi_araddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);
        laxi_arvalid_s <= '0';
        laxi_rready_s <= '0';
        
        if(axi_read_data_v(0) = '1') then
            exit;
        else
            wait for 50 ns;
        end if;
    end loop;        
    
    ----------------------------- 25x25 -----------------------------------------------------------------
    -------------- AXI Lite reset ---------------
    kernel_cnt := 1;
 
   
   -- wait until falling_edge(clk_s);  
   -- laxi_aresetn_s <= '0';
   -- for i in 1 to 5 loop
   --     wait until falling_edge(clk_s);
   -- end loop;
   -- laxi_aresetn_s <= '1';
    wait until falling_edge(clk_s);
    laxi_awaddr_s <= conv_std_logic_vector(RESET_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(1, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    
    wait until falling_edge(clk_s); 
    laxi_awaddr_s <= conv_std_logic_vector(RESET_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 
    
    
   dma_flag := 2;

    ------------- Kernel BRAM init ---------------
    wait until rising_edge(clk_s);    
    kernel_en_s <= '1';
    kernel_we_s <= "1111";
    for i in 0 to KERNEL_SIZE_25 - 1 loop
        kernel_addr_s <= conv_std_logic_vector(i*4, kernel_addr_s'length);
        kernel_data_s <= "0000000000000000"&KERNEL_CONTENT_25(i);
        wait until rising_edge(clk_s);
    end loop;
    kernel_en_s <= '0';
    kernel_we_s <= "0000";   
    
    -------------- IMG BRAM INIT ---------------
    
--    wait until rising_edge(clk_s);
--    for j in 0 to 24 loop
--    for i in 0 to 359 loop
--       axis_rvalid_s <= '1';
--       if axis_rready_s = '1' then
--        if(j = 24 and i = 359) then
--            axis_rlast_s <= '1';
--        else
--            axis_rlast_s <= '0';
--        end if;        
--        axis_rdata_s <= dram_content3(j*720 + 2*i)&dram_content3(j*720+ 2*i + 1);
--        wait until rising_edge(clk_s);
--       else
--            wait until axis_rready_s = '1';
--       end if;    
--    end loop;
--    end loop;
--    axis_rlast_s <= '0';   
--    axis_rvalid_s <= '0';  
    --wait until dma_flag = 5;
    wait until axis_rlast_s = '1';

    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s); 
    wait until rising_edge(clk_s);
    cnt := 18000;
    

--    laxi_aresetn_s <= '0';
--    for i in 1 to 2 loop
--        wait until falling_edge(clk_s);
--    end loop;
--    laxi_aresetn_s <= '1';
--    wait until rising_edge(clk_s);
    dma_flag := 3;
    
    -------------- AXI Lite write kernel size ---------------
    
    laxi_awaddr_s <= conv_std_logic_vector(KERNEL_SIZE_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(25, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';    
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 


    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;

    -------------- AXI Lite write start ---------------
    
    laxi_awaddr_s <= conv_std_logic_vector(START_REG_ADDR_C, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '1';
    laxi_wdata_s <= conv_std_logic_vector(1, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '1';   
    laxi_wstrb_s <= "1111";
    laxi_bready_s <= '1';
    wait until laxi_awready_s = '1';
    wait until laxi_awready_s = '0';
    wait until falling_edge(clk_s);    
    laxi_awaddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);     
    laxi_awvalid_s <= '0';
    laxi_wdata_s <= conv_std_logic_vector(0, AXI_DATA_WIDTH);     
    laxi_wvalid_s <= '0';   
    laxi_wstrb_s <= "0000";
    wait until laxi_bvalid_s = '0';
    wait until falling_edge(clk_s); 
    laxi_bready_s <= '0';
    wait until falling_edge(clk_s); 

    axis_wready_s <= '1';
    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;
               
    -------------- AXI Stream cache add ---------------
--    wait until rising_edge(clk_s);
--    axis_rvalid_s <= '1';
--    while(axis_rlast_s /= '1') loop
--        if(cnt = 791998) then
--            axis_rlast_s <= '1';
--        else
--            axis_rlast_s <= '0';
--        end if;    
--        if(axis_rready_s = '1') then
--            axis_rdata_s <= dram_content3(cnt)&dram_content3(cnt+1);
--            cnt := cnt + 2;
--        else
--            cnt := cnt;
--        end if;    
--    wait until rising_edge(clk_s);
--    end loop;
--    axis_rlast_s <= '0';
--    axis_rvalid_s <= '0';
    
    ------------ AXI Lite read READY ---------------
     wait until axis_rlast_s = '1';


    
    loop
        if(axis_wlast_s = '1') then
            axis_wready_s <= '0';
        end if; 
        wait until falling_edge(clk_s);
        laxi_araddr_s <= conv_std_logic_vector(READY_REG_ADDR_C, AXI_ADDR_WIDTH);
        laxi_arvalid_s <= '1';
        laxi_rready_s <= '1';
        wait until laxi_arready_s = '1';
        axi_read_data_v := laxi_rdata_s;
        wait until laxi_arready_s = '0';
        wait until falling_edge(clk_s);    
          
        laxi_araddr_s <= conv_std_logic_vector(0, AXI_ADDR_WIDTH);
        laxi_arvalid_s <= '0';
        laxi_rready_s <= '0';
        
        if(axi_read_data_v(0) = '1') then
            exit;
        else
            wait for 50 ns;
        end if;
    end loop;        
   
    wait;
end process;


output_gen: process
variable text_line : line;
variable pixel_cnt: positive := 0;
begin

    wait until axis_wvalid_s = '1'; 
    wait until rising_edge(clk_s);   
    if(kernel_cnt = 0) then
 	  write(text_line, str(axis_wdata_s(15 downto 8)));			
	  writeline(text_file_out, text_line);   
	  write(text_line, str(axis_wdata_s(7 downto 0)));			
	  writeline(text_file_out, text_line);
	  --pixel_cnt := pixel_cnt + 1;
	else
 	  write(text_line, str(axis_wdata_s(15 downto 8)));			
	  writeline(text_file_out25, text_line);   
	  write(text_line, str(axis_wdata_s(7 downto 0)));			
	  writeline(text_file_out25, text_line); 	     
    end if; 		

    
end process;




end Behavioral;
