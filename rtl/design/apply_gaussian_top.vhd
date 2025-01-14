----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/20/2024 07:08:37 PM
-- Design Name: 
-- Module Name: apply_gaussian_top - Behavioral
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

entity apply_gaussian_top is
  Generic(
    IMG_WIDTH: positive := 1100;
    IMG_HEIGHT: positive := 720;
     
    KERNEL_ADDR_WIDTH : positive := 12;
    KERNEL_DATA_WIDTH: positive := 16;
    KERNEL_SIZE: positive := 625;
      
    IMG_BRAM_DATA_WIDTH: positive := 8;
    IMG_BRAM_ADDR_WIDTH: positive := 16; 
    IMG_BRAM_SIZE: positive := 18000
  );  
  Port( 
    ---------- Clocking and reset interface----------
    clk: in std_logic;
    reset: in std_logic;  
    
    ---------- AXI Lite Input ------------
    kernel_size_i: in std_logic_vector(4 downto 0);
    
    ---------- AXI Lite - Command interface ---------
    start: in std_logic;
    
    ---------- AXI Lite Status interface ----------
    ready_o: out std_logic;                 
    
    ---------- Kernel BRAM to CPU -------------------
    kernel_en_i: in std_logic;
    kernel_we_i: in std_logic_vector(3 downto 0);
    kernel_waddr_i: in std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0);
    kernel_wdata_i: in std_logic_vector(KERNEL_DATA_WIDTH - 1 downto 0);
    


    ---------- AXI Stream ---------------------------
    --- IP to DDR ---    
    axi_wdata_o: out std_logic_vector(31 downto 0);
    axi_wvalid_o: out std_logic;     
    axi_wready_i: in std_logic;
    axi_wlast_o: out std_logic;    
    --- DDR to IP ---    
    axi_rdata_i: in std_logic_vector(31 downto 0);   
    axi_rvalid_i: in std_logic;    
    axi_rready_o: out std_logic;
    axi_rlast_i: in std_logic
       
  );
end apply_gaussian_top;

architecture Behavioral of apply_gaussian_top is


    
    ----- kernel BRAM to IPB -----
    signal kernel_en_s: std_logic;
    signal kernel_raddr_s: std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0);
    signal kernel_rdata_s: std_logic_vector(KERNEL_DATA_WIDTH - 1 downto 0);
    
    
    ----- IMG BRAM to IPB -----
    signal img_bram_en_s: std_logic;
    signal img_bram_we_s: std_logic_vector(3 downto 0);
    signal img_bram_raddr_s: std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    signal img_bram_rdata_s: std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0);
    signal img_bram_raddr_b_s: std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    signal img_bram_rdata_b_s: std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0);

    signal ready_s: std_logic;
    signal start_s: std_logic;   
    signal axi_wready_s, axi_wvalid_s, axi_wlast_s, axi_rready_s, axi_rvalid_s, axi_rlast_s: std_logic;
    signal axi_rdata_s: std_logic_vector(31 downto 0);       
    signal axi_wdata_s: std_logic_vector(15 downto 0);

begin

ipb1: entity work.image_processing_block
    Generic map(
        IMG_WIDTH => IMG_WIDTH,
        IMG_HEIGHT => IMG_HEIGHT,
        KERNEL_ADDR_WIDTH => KERNEL_ADDR_WIDTH,
        KERNEL_DATA_WIDTH => KERNEL_DATA_WIDTH,
        IMG_BRAM_ADDR_WIDTH => IMG_BRAM_ADDR_WIDTH,
        IMG_BRAM_DATA_WIDTH => IMG_BRAM_DATA_WIDTH
    )
    Port map(
        clk => clk,
        reset => reset,
        start => start_s,
        kernel_size_i => kernel_size_i,
        ready => ready_s,
        kernel_bram_en_o => kernel_en_s,
        kernel_bram_raddr_o => kernel_raddr_s,
        kernel_bram_rdata_i => kernel_rdata_s,
        img_bram_en_o => img_bram_en_s,
        img_bram_we_o => img_bram_we_s,
        img_bram_raddr_o => img_bram_raddr_s,
        img_bram_rdata_i => img_bram_rdata_s,
        img_bram_raddr_b_o => img_bram_raddr_b_s,
        img_bram_rdata_b_i => img_bram_rdata_b_s,        
        axi_wdata_o => axi_wdata_s,
        axi_rready_o => axi_rready_o,
        axi_rlast_i => axi_rlast_s,
        axi_rvalid_i => axi_rvalid_s,
        axi_wvalid_o => axi_wvalid_s,
        axi_wready_i => axi_wready_s,
        axi_wlast_o => axi_wlast_s            
    );
    
kernel_bram: entity work.kernel_bram
    Generic map(
        WIDTH => KERNEL_DATA_WIDTH,
        SIZE_WIDTH => KERNEL_ADDR_WIDTH,
        SIZE => KERNEL_SIZE
    )
    Port map(
        clk => clk,
        en => kernel_en_s,
        addr => kernel_raddr_s,
        data => kernel_rdata_s,    
        en_b => kernel_en_i,
        we_b => kernel_we_i,
        addr_b => kernel_waddr_i,
        data_b => kernel_wdata_i
    );  
    
     
    
img_bram1: entity work.img_bram
    Generic map(
        DATA_WIDTH => IMG_BRAM_DATA_WIDTH,
        ADDR_WIDTH => IMG_BRAM_ADDR_WIDTH,
        SIZE => IMG_BRAM_SIZE
    )
    Port map(
        clk => clk,
        en => img_bram_en_s,
        we => img_bram_we_s,
        addr => img_bram_raddr_s,
        data_o => img_bram_rdata_s,
        data_i => axi_rdata_s(15 downto 8),
        en_b => img_bram_en_s,
        we_b => img_bram_we_s,
        addr_b => img_bram_raddr_b_s,
        data_b_i => axi_rdata_s(7 downto 0),
        data_b_o => img_bram_rdata_b_s
    );       
    
ready_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            ready_o <= '1';
        else
            ready_o <= ready_s;    
        end if;
    end if;
end process;      


start_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            start_s <= '0';
        else
            start_s <= start;    
        end if;
    end if;
end process; 



rvalid_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_rvalid_s <= '0';
        else
            axi_rvalid_s <= axi_rvalid_i;    
        end if;
    end if;
end process; 


rlast_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_rlast_s <= '0';
        else
            axi_rlast_s <= axi_rlast_i;    
        end if;
    end if;
end process; 

rdata_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_rdata_s <= (others => '0');
        else
            axi_rdata_s <= axi_rdata_i;    
        end if;
    end if;    
end process;

wready_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_wready_s <= '0';
        else
            axi_wready_s <= axi_wready_i;    
        end if;
    end if;
end process; 


wdata_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_wdata_o <= (others => '0');
        else
            axi_wdata_o <= "0000000000000000"&axi_wdata_s;    
        end if;
    end if;    
end process;


wvalid_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_wvalid_o <= '0';
        else
            axi_wvalid_o <= axi_wvalid_s;    
        end if;
    end if;
end process;  



wlast_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            axi_wlast_o <= '0';
        else
            axi_wlast_o <=  axi_wlast_s;    
        end if;
    end if;
end process;  



end Behavioral;
