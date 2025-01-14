----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/11/2024 05:46:15 PM
-- Design Name: 
-- Module Name: apply_gaussian_top_tb - Behavioral
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
use std.textio.all;
use work.txt_util.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity apply_gaussian_top_tb is
--  Port ( );
end apply_gaussian_top_tb;

architecture Behavioral of apply_gaussian_top_tb is
    
    constant DRAM_DATA_WIDTH: positive := 8;
 
    constant DRAM_SIZE: positive := 792000;
    
    type ram_type is array(0 to DRAM_SIZE-1) of std_logic_vector(DRAM_DATA_WIDTH - 1 downto 0);
	
	--constant dram_depth : natural := 792000;
    
    constant KERNEL_DATA_WIDTH: positive := 16;
 
    constant KERNEL_SIZE: positive := 9;

    constant IMG_BRAM_SIZE: positive := 2160;

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

    --constant IMG_BRAM_SIZE_25: positive := 18000;

    type rom_type_25 is array(0 to KERNEL_SIZE_25 - 1) of std_logic_vector(KERNEL_DATA_WIDTH_25 - 1 downto 0);
        
    constant KERNEL_CONTENT_25: rom_type_25 := (
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
	
	--  file text_file : text open read_mode is "/home/amokan/Documents/4_godina/PROJEKAT/II_deo/naopacke_pa_binarno.txt";
	  file text_file : text open read_mode is "../../../../../dram_bin.txt";
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
 
    
	

    signal clk_s, reset_s, start_s, ready_s: std_logic;
    signal X_img_data_s: std_logic_vector(7 downto 0);
    signal X_img_addr_s: std_logic_vector(15 downto 0);
    signal X_img_en_s: std_logic;
    signal X_img_we_s: std_logic_vector(3 downto 0);
    signal kernel_en_s: std_logic;
    signal kernel_we_s: std_logic_vector(3 downto 0);
    signal kernel_addr_s: std_logic_vector(9 downto 0);
    signal kernel_data_s: std_logic_vector(15 downto 0);
    signal kernel_size_in_s: std_logic_vector(4 downto 0);
    signal dram_we_s: std_logic;
    signal dram_data_s: std_logic_vector(7 downto 0);
    signal dram_addr_s : std_logic_vector(21 downto 0);
    signal axi_read_init_s, axi_rready_s, axi_read_last_s, axi_rvalid_s: std_logic;
    signal axi_burst_len_s: std_logic_vector(7 downto 0);
    signal axi_raddr_s: std_logic_vector(21 downto 0);
    signal img_bram_waddr_s: std_logic_vector(15 downto 0);
    signal img_wdata_s: std_logic_vector(7 downto 0);
    signal axi_write_init_s: std_logic;
    -- da li je ovo legalno
    constant dram_content: ram_type := init_dram;
    constant dram_content3: ram_type := init_dram3;

begin

clk_gen: process
begin
    clk_s <= '0', '1' after 5 ns;
    wait for 10 ns;
end process;

stim_gen: process

begin
    reset_s <= '1';
    start_s <= '0';
    wait for 25 ns;
    reset_s <= '0';
    wait until falling_edge(clk_s);
    X_img_en_s <= '1';
    X_img_we_s <= "1111";
    for j in 0 to 2 loop
    for i in 0 to 719 loop
        X_img_addr_s <= conv_std_logic_vector(j*720+i, X_img_addr_s'length);
        X_img_data_s <= dram_content(j*720 + i);
        wait until falling_edge(clk_s);
    end loop;
    end loop;
    X_img_en_s <= '0';
    X_img_we_s <= "0000";
    
    wait until falling_edge(clk_s);
    kernel_en_s <= '1';
    kernel_we_s <= "1111";
    for i in 0 to KERNEL_SIZE - 1 loop
        kernel_addr_s <= conv_std_logic_vector(i, kernel_addr_s'length);
        kernel_data_s <= KERNEL_CONTENT(i);
        wait until falling_edge(clk_s);
    end loop;
    kernel_en_s <= '0';
    kernel_we_s <= "0000";    

    reset_s <= '1';    
    wait until falling_edge(clk_s);
    reset_s <= '0';
    start_s <= '1';
    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    kernel_size_in_s <= "00011";
    wait until falling_edge(clk_s);
    start_s <= '0';

for j in 0 to 1096 loop
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';
    
    for i in 0 to 255 loop
        img_wdata_s <= dram_content(2160+j*720+i);
        if(i = 255) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;

    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';
 
 
    for i in 256 to 511 loop
        img_wdata_s <= dram_content(2160+j*720+i);
        if(i = 511) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;

    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';    

    for i in 512 to 719 loop
        img_wdata_s <= dram_content(2160+j*720+i);
        if(i = 719) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;


    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';

end loop;    
    wait until ready_s = '1';
    wait until rising_edge(clk_s);
    wait until rising_edge(clk_s);
    
    reset_s <= '1';
    start_s <= '0';
    wait for 25 ns;
    reset_s <= '0';
    wait until falling_edge(clk_s);
    X_img_en_s <= '1';
    X_img_we_s <= "1111";
    for j in 0 to 24 loop
    for i in 0 to 719 loop
        X_img_addr_s <= conv_std_logic_vector(j*720+i, X_img_addr_s'length);
        X_img_data_s <= dram_content3(j*720 + i);
        wait until falling_edge(clk_s);
    end loop;
    end loop;
    X_img_en_s <= '0';
    X_img_we_s <= "0000";
    
    wait until falling_edge(clk_s);
    kernel_en_s <= '1';
    kernel_we_s <= "1111";
    for i in 0 to KERNEL_SIZE_25 - 1 loop
        kernel_addr_s <= conv_std_logic_vector(i, kernel_addr_s'length);
        kernel_data_s <= KERNEL_CONTENT_25(i);
        wait until falling_edge(clk_s);
    end loop;
    kernel_en_s <= '0';
    kernel_we_s <= "0000";    

    reset_s <= '1';    
    wait until falling_edge(clk_s);
    reset_s <= '0';
    start_s <= '1';
    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    kernel_size_in_s <= "11001";
    wait until falling_edge(clk_s);
    start_s <= '0';
 

for j in 0 to 1074 loop
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';
    
    for i in 0 to 255 loop
        img_wdata_s <= dram_content3(18000+j*720+i);
        if(i = 255) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;

    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';
 
 
    for i in 256 to 511 loop
        img_wdata_s <= dram_content3(18000+j*720+i);
        if(i = 511) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;

    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';
    
    wait until axi_read_init_s = '1';
    wait until rising_edge(clk_s);
    axi_rvalid_s <= '1';    

    for i in 512 to 719 loop
        img_wdata_s <= dram_content3(18000+j*720+i);
        if(i = 719) then
            axi_read_last_s <= '1';        
        end if;
        wait until rising_edge(clk_s);   
        
    end loop;


    axi_read_last_s <= '0';
    axi_rvalid_s <= '0';

end loop;    
    wait until ready_s = '1';
            
    wait;
end process;


output_gen: process
variable text_line : line;
begin
    wait until axi_write_init_s = '1';
    wait until rising_edge(clk_s);  
    wait until rising_edge(clk_s);   
    if(kernel_size_in_s = "00011") then
 	  write(text_line, str(dram_data_s));			
	   writeline(text_file_out, text_line);   
    end if; 		

    
end process;


output_gen25: process
variable text_line : line;
begin
    wait until axi_write_init_s = '1';
    wait until rising_edge(clk_s);  
    wait until rising_edge(clk_s);    		
	if(kernel_size_in_s = "11001") then
	   write(text_line, str(dram_data_s));			
	   writeline(text_file_out25, text_line);
	end if;   
    
end process;


--Ovo je DUV

duv: entity work.apply_gaussian_top 
Port map( 
    ---------- Clocking and reset interface----------
    clk => clk_s,
    reset => reset_s,

    ---------- Input ------------
    kernel_size_i => kernel_size_in_s,

    ---------- Command interface ----------
    start => start_s,

    ---------- IPB to DRAM interface  ----------
   -- dram_we_o => dram_we_s,
    dram_waddr_o => dram_addr_s,
    dram_wdata_o => dram_data_s,

    ---- IMG BRAM to DRAM -----
    img_en_i => X_img_en_s,
    img_we_i => X_img_we_s,
    img_waddr_b_i => X_img_addr_s,
    img_wdata_b_i => X_img_data_s,
    
    ---- IPB READS DRAM ----
    img_wdata_i => img_wdata_s,

    ---- KERNEL BRAM to CPU ----
    kernel_en_i => kernel_en_s,
    kernel_we_i => kernel_we_s,
    kernel_waddr_i => kernel_addr_s,
    kernel_wdata_i => kernel_data_s,

    ---------- Status interface ----------
    ready_o => ready_s, 
    
    -- AXI read dram --
    axi_read_init_o => axi_read_init_s,
    axi_burst_len_o => axi_burst_len_s,
   -- axi_rready_o => axi_rready_s,
    axi_read_last_i => axi_read_last_s,
    axi_raddr_o => axi_raddr_s,
    axi_rvalid_i => axi_rvalid_s,
    
    -- AXI writes dram --
    axi_write_init_o => axi_write_init_s
           
  );

end Behavioral;
