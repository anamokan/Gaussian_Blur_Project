----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2024 11:12:07 PM
-- Design Name: 
-- Module Name: image_processing_block - Behavioral
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

entity image_processing_block is
  Generic(
    IMG_WIDTH: positive := 1100;
    IMG_HEIGHT: positive := 720;
     
    KERNEL_ADDR_WIDTH : positive := 12;
    KERNEL_DATA_WIDTH: positive := 16;
     
    IMG_BRAM_DATA_WIDTH: positive := 8;
    IMG_BRAM_ADDR_WIDTH: positive := 16 
     
  );
  Port ( 
  ------ Clocking and reset interface ------
    clk: in std_logic;
    reset: in std_logic;
    
  ------ Control --------------------------- 
    start: in std_logic;
  
  ------ AXI Lite input --------------------  
    kernel_size_i: in std_logic_vector(4 downto 0);

  ------ Img BRAM interface ----------------    
    img_bram_en_o: out std_logic;
    img_bram_we_o: out std_logic_vector(3 downto 0);
    img_bram_raddr_o: out std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    img_bram_rdata_i: in std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0); 
    img_bram_raddr_b_o: out std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    img_bram_rdata_b_i: in std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0); 
 
  ------ Kernel BRAM interface -------------  
    kernel_bram_en_o: out std_logic;
    kernel_bram_raddr_o: out std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0);
    kernel_bram_rdata_i: in std_logic_vector(KERNEL_DATA_WIDTH - 1 downto 0);
    
    
  ------ Status ----------------------------  
    ready: out std_logic;    
    
  ------ AXI Stream ------------------------
     --- IPB to DDR ---    
    axi_wdata_o: out std_logic_vector(15 downto 0);
    axi_wvalid_o: out std_logic;     
    axi_wready_i: in std_logic;
    axi_wlast_o: out std_logic;    
     --- DDR to IPB ---    
    axi_rvalid_i: in std_logic;    
    axi_rready_o: out std_logic;
    axi_rlast_i: in std_logic
  );
end image_processing_block;

architecture Behavioral of image_processing_block is
    
    signal loop_en_s, l_loop_end_s, i_loop_end_s, j_loop_end_s, kl_loop_init_s: std_logic;
    signal kern_size_delay_s, rready_ctrl_s: std_logic;
    signal switch_read_mode_s: std_logic;
    signal sumPix_rst_s: std_logic_vector(1 downto 0);
    
begin

datapath: entity work.data_path
    Generic map(
        IMG_WIDTH => IMG_WIDTH,
        IMG_HEIGHT => IMG_HEIGHT,
     
        KERNEL_ADDR_WIDTH => KERNEL_ADDR_WIDTH,
        KERNEL_DATA_WIDTH => KERNEL_DATA_WIDTH,
     
        IMG_BRAM_DATA_WIDTH => IMG_BRAM_DATA_WIDTH,
        IMG_BRAM_ADDR_WIDTH => IMG_BRAM_ADDR_WIDTH
 
    )
    Port map(
        clk => clk,
        reset => reset,
        kernel_size_i => kernel_size_i,
        kernel_bram_addr_read_o => kernel_bram_raddr_o,
        kernel_bram_data_read_i => kernel_bram_rdata_i,
        img_bram_addr_read_o => img_bram_raddr_o,
        img_bram_data_read_i => img_bram_rdata_i,
        img_bram_addr_read_b_o => img_bram_raddr_b_o,
        img_bram_data_read_b_i => img_bram_rdata_b_i,        
        sumPix_rst_i => sumPix_rst_s,
        loop_en_i => loop_en_s,
        kl_loop_init_i => kl_loop_init_s,
        kern_size_delay_o => kern_size_delay_s,     
        l_loop_end_o => l_loop_end_s,
        i_loop_end_o => i_loop_end_s,
        j_loop_end_o => j_loop_end_s,
        switch_read_mode_i => switch_read_mode_s,
        rready_ctrl_i => rready_ctrl_s, 
        dram_data_write_o => axi_wdata_o,        
        axi_rvalid_i => axi_rvalid_i
    );


controlpath: entity work.control_path
    Port map(
        clk => clk,
        reset => reset,
        start => start,
        ready => ready,
        img_bram_en_o => img_bram_en_o,
        img_bram_we_o => img_bram_we_o,
        kernel_bram_en_o => kernel_bram_en_o,
        sumPix_rst_o => sumPix_rst_s,
        loop_en_o => loop_en_s,
        kern_size_delay_i => kern_size_delay_s,
        kl_loop_init_o => kl_loop_init_s,
        l_loop_end_i => l_loop_end_s, 
        i_loop_end_i => i_loop_end_s,
        j_loop_end_i => j_loop_end_s,
        switch_read_mode_o => switch_read_mode_s,  
        wvalid_o => axi_wvalid_o,
        wready_i => axi_wready_i,
        wlast_o => axi_wlast_o,           
        rready_ctrl_o => rready_ctrl_s,
        rready_o => axi_rready_o,
        rlast_i => axi_rlast_i,
        rvalid_i => axi_rvalid_i
    );


end Behavioral;
