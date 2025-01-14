library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apply_gaussian_blur_v1_0 is
	generic (
		-- Users to add parameters here
		IMG_WIDTH: positive := 1100;
		IMG_HEIGHT: positive := 720;
		 
		KERNEL_ADDR_WIDTH : positive := 12;
		KERNEL_DATA_WIDTH: positive := 16;
		KERNEL_SIZE: positive := 625;
		
		IMG_BRAM_DATA_WIDTH: positive := 8;
		IMG_BRAM_ADDR_WIDTH: positive := 16; 
		IMG_BRAM_SIZE: positive := 18000; 
         
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
		kernel_bram_en_i: std_logic;
		kernel_bram_we_i: std_logic_vector(3 downto 0);
		kernel_bram_addr_i: std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0);
		kernel_bram_data_i: std_logic_vector(31 downto 0);
		---------- AXI Stream ---------------------------
		--- IP to DDR ---    
		axis_wdata_o: out std_logic_vector(31 downto 0);
		axis_wvalid_o: out std_logic;     
		axis_wready_i: in std_logic;
		axis_wlast_o: out std_logic;    
		--- DDR to IP ---    
		axis_rdata_i: in std_logic_vector(31 downto 0);   
		axis_rvalid_i: in std_logic;    
		axis_rready_o: out std_logic;
		axis_rlast_i: in std_logic;        
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end apply_gaussian_blur_v1_0;

architecture arch_imp of apply_gaussian_blur_v1_0 is

	-- component declaration
	component apply_gaussian_blur_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        start_o: out std_logic;
        kernel_size_o: out std_logic_vector(4 downto 0);
        reset_o: out std_logic;
        ready_i: in std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component apply_gaussian_blur_v1_0_S00_AXI;

    component apply_gaussian_top is
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
    end component apply_gaussian_top;

    signal start_s, ready_s, reset_s, reset_lite_s: std_logic;
    signal kernel_size_s: std_logic_vector(4 downto 0);
    signal kernel_bram_addr_s: std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0);
    signal kernel_bram_data_s: std_logic_vector(KERNEL_DATA_WIDTH - 1 downto 0);

begin

-- Instantiation of Axi Bus Interface S00_AXI
apply_gaussian_blur_v1_0_S00_AXI_inst : apply_gaussian_blur_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    start_o => start_s,
	    kernel_size_o => kernel_size_s,
	    reset_o => reset_lite_s,
	    ready_i => ready_s,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
apply_gaussian_top_inst: apply_gaussian_top
    generic map(
        IMG_WIDTH => IMG_WIDTH,
        IMG_HEIGHT => IMG_HEIGHT,
         
        KERNEL_ADDR_WIDTH => KERNEL_ADDR_WIDTH,
        KERNEL_DATA_WIDTH => KERNEL_DATA_WIDTH,
        KERNEL_SIZE => KERNEL_SIZE,
        
        IMG_BRAM_DATA_WIDTH => IMG_BRAM_DATA_WIDTH,
        IMG_BRAM_ADDR_WIDTH => IMG_BRAM_ADDR_WIDTH,
        IMG_BRAM_SIZE => IMG_BRAM_SIZE
         
    )
    port map(
        clk => s00_axi_aclk,
        reset => reset_s,
        start => start_s,
        ready_o => ready_s,
        kernel_size_i => kernel_size_s,
        kernel_en_i => kernel_bram_en_i,
        kernel_we_i => kernel_bram_we_i,
        kernel_waddr_i => kernel_bram_addr_s,
        kernel_wdata_i => kernel_bram_data_s,
        axi_wdata_o => axis_wdata_o,
        axi_wvalid_o => axis_wvalid_o,
        axi_wready_i => axis_wready_i,
        axi_wlast_o => axis_wlast_o,
        axi_rdata_i => axis_rdata_i,
        axi_rvalid_i => axis_rvalid_i,
        axi_rready_o => axis_rready_o,
        axi_rlast_i => axis_rlast_i       
    );
    
    kernel_bram_data_s <= kernel_bram_data_i(KERNEL_DATA_WIDTH - 1 downto 0); 
    kernel_bram_addr_s <= std_logic_vector(shift_right(unsigned(kernel_bram_addr_i), 2));
    reset_s <= reset_lite_s or (not(s00_axi_aresetn));
	-- User logic ends

end arch_imp;
