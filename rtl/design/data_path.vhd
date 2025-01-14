----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2024 01:01:37 PM
-- Design Name: 
-- Module Name: data_path - Behavioral
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

entity data_path is
  Generic(
    IMG_WIDTH: positive := 1100;
    IMG_HEIGHT: positive := 720;
     
    KERNEL_ADDR_WIDTH : positive := 12;
    KERNEL_DATA_WIDTH: positive := 16;
     
    IMG_BRAM_DATA_WIDTH: positive := 8;
    IMG_BRAM_ADDR_WIDTH: positive := 16
     
 
  );
  Port (
  ---------- Clocking and reset interface----------
    clk: in std_logic;
    reset: in std_logic;  
    
    ---------- Input ----------------------
    kernel_size_i: in std_logic_vector(4 downto 0);
    
    ---------- KERNEL interface  ---------- 
    kernel_bram_addr_read_o: out std_logic_vector(KERNEL_ADDR_WIDTH-1 downto 0);
    kernel_bram_data_read_i: in std_logic_vector(KERNEL_DATA_WIDTH-1 downto 0);
         
    -----------IMG BRAM interface----------
    img_bram_addr_read_o: out std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    img_bram_data_read_i: in std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0);  
    img_bram_addr_read_b_o: out std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0);
    img_bram_data_read_b_i: in std_logic_vector(IMG_BRAM_DATA_WIDTH - 1 downto 0);  
    
    ---------- AXI Stream - DDR  ----------    
    dram_data_write_o: out std_logic_vector(15 downto 0);
    ---------- AXI Stream - Cache add -----
    axi_rvalid_i: in std_logic;
    
    ---------- Control path interface -----
    sumPix_rst_i: in std_logic_vector(1 downto 0);
    loop_en_i: in std_logic;
    kl_loop_init_i: in std_logic;
    switch_read_mode_i: in std_logic;
    rready_ctrl_i: in std_logic;    
    kern_size_delay_o: out std_logic;
    l_loop_end_o: out std_logic; 
    i_loop_end_o: out std_logic;
    j_loop_end_o: out std_logic 


  );
end data_path;

architecture Behavioral of data_path is

    function min_max(a: integer; b: integer; mm: integer) return unsigned is
        -- mm -> 0 = min , 1 = max
        -- mm -> 0 = min , 1 = max
        -- mm -> 0 = min , 1 = max
        variable c: integer;
    begin
        c := 0;
        if(mm = 0)then
            if b >= a then
                c := a;
            else
                c := b;
            end if;
        elsif(mm = 1)then
            if b <= a then
                c := a;
            else
                c := b;
            end if;     
       end if;
     
       return to_unsigned(c, 11);
    end min_max; 


    signal j_next, j_reg, j_inc_out, j_reg12, j_reg23: std_logic_vector(10 downto 0) := (others => '0');
    signal i_next, i_reg, i_inc_out, i_reg12, i_reg23: std_logic_vector(10 downto 0) := (others => '0');
    signal l_next, l_reg, l_inc_out, l_reg12, l_reg23: std_logic_vector(4 downto 0) := (others => '0');
    signal k_next, k_reg, k_inc_out, k_reg12, k_reg23: std_logic_vector(4 downto 0) := (others => '0');
    signal k_end_sel: std_logic;
    signal l_end_sel,j_end_sel, i_end_sel: std_logic_vector(1 downto 0);
    
    signal kernel_size_next, kernel_size_reg: std_logic_vector(4 downto 0) := (others => '0');
    signal kernel_size_reg12, kernel_size_reg23: std_logic_vector(4 downto 0);
    signal half_size_inc_out: std_logic_vector(4 downto 0);
    signal half_size_reg12: std_logic_vector(4 downto 0);
    
    signal comp_j_out, comp_i_out, comp_k_out, comp_l_out, comp_k_dram_we: std_logic;
    signal rc_mod_sel, comp_cache, comp_kern_size: std_logic;
      
    signal req_cnt_reg12, req_cnt_inc, req_cnt_reg23: std_logic_vector(10 downto 0);
    signal rc_mod_reg12, rc_mod_inc, rc_mod_reg23: std_logic_vector(4 downto 0);
    signal rc_minus_req, rc_minus_req_reg23: std_logic_vector(11 downto 0);
    signal cache_size_next, cache_size_reg23, cache_size_mod_next, cache_size_reg34, cache_size_mod_reg34: std_logic_vector(15 downto 0);
    
    signal rowIndex_next, rowIndex_reg23, colIndex_next, colIndex_reg23: std_logic_vector(10 downto 0);
    signal k_plus_hs, l_plus_hs, k_plus_hs_reg23, l_plus_hs_reg23: std_logic_vector(4 downto 0);    
    
    signal kernel_addr_calc_out, kernel_bram_addr_reg34, kernel_bram_addr_reg45: std_logic_vector(KERNEL_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal img_addr_sel: std_logic := '0';
    signal sub_img_addr_out, img_mux_out, img_bram_addr_reg45: std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0) := (others => '0');

    signal sumPixel_next: std_logic_vector(23 downto 0) := (others => '0');
    signal sumPixel_reg67: std_logic_vector(15 downto 0):= (others => '0');
    
    signal img_bram_addr_mode, img_bram_addr_inc_out, img_bram_waddr_mult_out, img_bram_waddr_reg23, img_bram_waddr_reg34: std_logic_vector(15 downto 0);


    signal rowIndex_b_next, rowIndex_b_reg23: std_logic_vector(10 downto 0) := (others => '0');
    signal cache_size_mod_b_next, cache_size_mod_b_reg34: std_logic_vector(15 downto 0) := (others => '0');
    signal img_addr_sel_b: std_logic := '0';
    signal sub_img_addr_out_b, img_mux_out_b, img_bram_addr_b_reg45: std_logic_vector(IMG_BRAM_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal sumPixel_b_next: std_logic_vector(23 downto 0) := (others => '0');
    signal sumPixel_b_reg67: std_logic_vector(15 downto 0):= (others => '0');
    signal img_bram_addr_mode_b, img_bram_addr_inc_out_b: std_logic_vector(15 downto 0);
begin


loops: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            j_reg <= (others => '0');
            i_reg <= (others => '0');
            k_reg <= (others => '0');   
            l_reg <= (others => '0');
        else
            if(kl_loop_init_i = '1') then
                j_reg <= (others => '0');
                i_reg <= (others => '0');  
                k_reg <= std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1);  
                l_reg <= std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1);              
            else
                if(loop_en_i = '1') then
                    j_reg <= j_next;
                    i_reg <= i_next;  
                    k_reg <= k_next;  
                    l_reg <= l_next;   
                end if;
            end if;                 
        end if;
    end if;
end process;    

j_inc: j_inc_out <= std_logic_vector(unsigned(j_reg) + 1);
j_mux: j_next <= (others => '0') when j_end_sel = "11" else 
                 j_inc_out when j_end_sel = "01" else
                 j_reg; 
  
i_inc: i_inc_out <= std_logic_vector(unsigned(i_reg) + 2);
i_mux: i_next <=  (others => '0') when i_end_sel = "11" else    
                  i_inc_out when i_end_sel = "01" else
                  i_reg; 
                 
l_inc: l_inc_out <= std_logic_vector(signed(l_reg) + 1);
l_mux: l_next <= std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1) when l_end_sel = "11" else
                 l_inc_out when l_end_sel = "01" else
                 l_reg; 
 
k_inc: k_inc_out <= std_logic_vector(signed(k_reg) + 1);
k_mux: k_next <= k_inc_out when k_end_sel = '0' else
                 std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1);
                                 

input_reg: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            kernel_size_reg <= (others => '0');
        else
            kernel_size_reg <= kernel_size_i;
        end if;
    end if;
end process;


halfSize_inc: half_size_inc_out <= std_logic_vector(signed(shift_right(unsigned(kernel_size_reg), 1)));    
    
PHASE12:process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            j_reg12 <= (others => '0');
            i_reg12 <= (others => '0');
            l_reg12 <= (others => '0');
            k_reg12 <= (others => '0');
            half_size_reg12 <= (others => '0');
            kernel_size_reg12 <= (others => '0');
            rc_mod_reg12 <= (others => '0');
            req_cnt_reg12 <= (others => '0');
        else
            if(to_integer(unsigned(j_reg)) = 0) then
                rc_mod_reg12 <= (others => '0');
                req_cnt_reg12 <= (others => '0');            
            else
                rc_mod_reg12 <= rc_mod_reg23;
                req_cnt_reg12 <= req_cnt_reg23;
            end if;    
            half_size_reg12 <= half_size_inc_out;
            kernel_size_reg12 <= kernel_size_reg;
            if(kl_loop_init_i = '1') then
                j_reg12 <= (others => '0');
                i_reg12 <= (others => '0');  
                k_reg12 <= std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1);  
                l_reg12 <= std_logic_vector(not(signed(shift_right(unsigned(kernel_size_reg), 1))) + 1);        
            else
                j_reg12 <= j_reg;
                i_reg12 <= i_reg;
                l_reg12 <= l_reg;
                k_reg12 <= k_reg;
             end if;       
        end if;    
    end if;
end process;

comp_j: comp_j_out <= '1' when to_integer(unsigned(j_reg12)) = IMG_WIDTH - 1 else
                      '0';                        
comp_i: comp_i_out <= '1' when to_integer(unsigned(i_reg12)) = IMG_HEIGHT - 2 else
                      '0';                
comp_l: comp_l_out <= '1' when to_integer(signed(l_reg12)) = to_integer(unsigned(half_size_reg12)) else
                      '0';                                                                      
comp_k: comp_k_out <= '1' when to_integer(signed(k_reg12)) = to_integer(unsigned(half_size_reg12)) - 1 else
                      '0';  
                      
comp_k_true: comp_k_dram_we <= '1' when to_integer(signed(k_reg12)) = to_integer(unsigned(half_size_reg12)) else
                              '0';                       

cache_comp: comp_cache <= '1' when to_integer(unsigned(j_reg12)) >= to_integer(unsigned(half_size_reg12)) and to_integer(unsigned(j_reg12)) < IMG_WIDTH - to_integer(unsigned(half_size_reg12)) - 1 else
                          '0';
kern_comp: comp_kern_size <= '1' when to_integer(unsigned(kernel_size_reg12)) = 3 else
                             '0';                           


and_j: j_end_sel <= comp_j_out&(comp_i_out and comp_l_out and comp_k_out);    
and_i: i_end_sel <= comp_i_out&(comp_k_out and comp_l_out);
and_l: l_end_sel <= comp_l_out&comp_k_out;
and_k: k_end_sel <= comp_k_out;   


l_end_output: l_loop_end_o <= comp_l_out and comp_k_dram_we; 
i_end_output: i_loop_end_o <= comp_cache and comp_i_out and comp_l_out and comp_k_out;
j_end_output: j_loop_end_o <= comp_j_out and comp_i_out and comp_l_out and comp_k_out;    



dram_write_delay_output: kern_size_delay_o <= comp_kern_size;

rc_mod_sel_sig: rc_mod_sel <= comp_cache and comp_i_out and comp_l_out and comp_k_out;

       

req_cnt_increment: req_cnt_inc <= std_logic_vector(unsigned(req_cnt_reg23) + 1) when rc_mod_sel = '1' else
                                  req_cnt_reg23;
rc_mod_increment: rc_mod_inc <= std_logic_vector(unsigned(rc_mod_reg23) + 1) when rc_mod_sel = '1' and to_integer(unsigned(rc_mod_reg23)) < to_integer(unsigned(kernel_size_reg12)) - 1 else
                                (others => '0') when rc_mod_sel = '1' and to_integer(unsigned(rc_mod_reg23)) >= to_integer(unsigned(kernel_size_reg12)) - 1 else
                                rc_mod_reg23;        
                                
img_bram_write_addr_mult: img_bram_waddr_mult_out <= std_logic_vector(to_unsigned(to_integer(unsigned(rc_mod_reg12)) * IMG_HEIGHT, IMG_BRAM_ADDR_WIDTH)) when rc_mod_sel = '1' else                                                       
                                                     (others => '0');   
row_min_max: rowIndex_next <= std_logic_vector( min_max(to_integer( min_max( to_integer(unsigned(i_reg12)) + to_integer(signed(k_reg12)), 0 , 1)), IMG_HEIGHT - 1 , 0)); 
row_min_max_b: rowIndex_b_next <= std_logic_vector( min_max(to_integer( min_max( to_integer(unsigned(i_reg12)) + 1 + to_integer(signed(k_reg12)), 0 , 1)), IMG_HEIGHT - 1 , 0));
col_min_max: colIndex_next <= std_logic_vector( min_max(to_integer( min_max( to_integer(unsigned(j_reg12)) + to_integer(signed(l_reg12)), 0 , 1)), IMG_WIDTH -1, 0));    
    
kern_bram_addr_adder1: k_plus_hs <= std_logic_vector(to_unsigned(to_integer(signed(k_reg12)) + to_integer(unsigned(half_size_reg12)), 5));    
kern_bram_addr_adder2: l_plus_hs <= std_logic_vector(to_unsigned(to_integer(signed(l_reg12)) + to_integer(unsigned(half_size_reg12)), 5)); 
    
sub_cs_mod: rc_minus_req <=  std_logic_vector(to_unsigned(to_integer(unsigned(rc_mod_reg12)) - to_integer(unsigned(req_cnt_reg12)), 12));    
 
cache_size_mult: cache_size_next <= std_logic_vector(to_unsigned(to_integer(unsigned(kernel_size_reg12)) * IMG_HEIGHT, 16));  
 
PHASE23: process(clk) 
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            rowIndex_reg23 <= (others => '0');
            rowIndex_b_reg23 <= (others => '0');
            colIndex_reg23 <= (others => '0');
            rc_minus_req_reg23 <= (others => '0');
            cache_size_reg23 <= (others => '0');
            k_plus_hs_reg23 <= (others => '0');
            l_plus_hs_reg23 <= (others => '0');
            j_reg23 <= (others => '0');
            i_reg23 <= (others => '0');
            l_reg23 <= (others => '0');
            k_reg23 <= (others => '0');   
            req_cnt_reg23 <= (others => '0');           
            rc_mod_reg23 <= (others => '0');  
            img_bram_waddr_reg23 <= (others => '0');
        else
            rowIndex_reg23 <= rowIndex_next;
            rowIndex_b_reg23 <= rowIndex_b_next;
            colIndex_reg23 <= colIndex_next;
            rc_minus_req_reg23 <= rc_minus_req;
            cache_size_reg23 <= cache_size_next;
            kernel_size_reg23 <= kernel_size_reg12; 
            k_plus_hs_reg23 <= k_plus_hs;
            l_plus_hs_reg23 <= l_plus_hs;
            j_reg23 <= j_reg12;
            i_reg23 <= i_reg12;      
            l_reg23 <= l_reg12;  
            k_reg23 <= k_reg12;    
            req_cnt_reg23 <= req_cnt_inc;                             
            rc_mod_reg23 <= rc_mod_inc;   
            if(rc_mod_sel = '1') then
            img_bram_waddr_reg23 <= img_bram_waddr_mult_out;
            
            end if;
        end if;
    end if;
end process;    
    
     
    
cache_size_mod_calc: cache_size_mod_next <= std_logic_vector(to_unsigned((to_integer(unsigned(colIndex_reg23)) + to_integer(signed(rc_minus_req_reg23))) * IMG_HEIGHT + to_integer(unsigned(rowIndex_reg23)), 16));    
cache_size_mod_calc_b: cache_size_mod_b_next <= std_logic_vector(to_unsigned((to_integer(unsigned(colIndex_reg23)) + to_integer(signed(rc_minus_req_reg23))) * IMG_HEIGHT + to_integer(unsigned(rowIndex_b_reg23)), 16));  
kernel_addr_calc: kernel_addr_calc_out <= std_logic_vector(to_unsigned( to_integer(unsigned(l_plus_hs_reg23)) * to_integer(unsigned(kernel_size_reg23)) +  to_integer(unsigned(k_plus_hs_reg23)),  KERNEL_ADDR_WIDTH) );    
   
PHASE34: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            cache_size_mod_reg34 <= (others => '0');
            cache_size_mod_b_reg34 <= (others => '0');
            cache_size_reg34 <= (others => '0');
            kernel_bram_addr_reg34 <= (others => '0');
            img_bram_waddr_reg34 <= (others => '0');
        else
            cache_size_mod_reg34 <= cache_size_mod_next;
            cache_size_mod_b_reg34 <= cache_size_mod_b_next;
            cache_size_reg34 <= cache_size_reg23;
            kernel_bram_addr_reg34 <= kernel_addr_calc_out;      
            img_bram_waddr_reg34 <= img_bram_addr_inc_out;
        end if;
    end if;
end process;    
    
cache_size_mod_comp: img_addr_sel <= '1' when to_integer(unsigned(cache_size_mod_reg34)) >= to_integer(unsigned(cache_size_reg34)) else
                                     '0';
cache_size_mod_comp_b: img_addr_sel_b <= '1' when to_integer(unsigned(cache_size_mod_b_reg34)) >= to_integer(unsigned(cache_size_reg34)) else
                                     '0';                                     
sub2: sub_img_addr_out <= std_logic_vector(to_unsigned(to_integer(unsigned(cache_size_mod_reg34)) - to_integer(unsigned(cache_size_reg34)), IMG_BRAM_ADDR_WIDTH));  
sub2_b: sub_img_addr_out_b <= std_logic_vector(to_unsigned(to_integer(unsigned(cache_size_mod_b_reg34)) - to_integer(unsigned(cache_size_reg34)), IMG_BRAM_ADDR_WIDTH));                                      
img_bram_addr_mux: img_mux_out <= sub_img_addr_out when img_addr_sel = '1' else
                                  cache_size_mod_reg34;     
img_bram_addr_mux_b: img_mux_out_b <= sub_img_addr_out_b when img_addr_sel = '1' else
                                      cache_size_mod_b_reg34;    

PHASE45: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            img_bram_addr_reg45 <= (others => '0');
            img_bram_addr_b_reg45 <= (others => '0');
            kernel_bram_addr_reg45 <= (others => '0');
        else
            img_bram_addr_reg45 <= img_bram_addr_mode;
            img_bram_addr_b_reg45 <= img_bram_addr_mode_b;
            kernel_bram_addr_reg45 <= kernel_bram_addr_reg34;   
        end if;
    end if;
end process;    


img_addr_output: img_bram_addr_read_o <= img_bram_addr_reg45;
img_addr_output_b: img_bram_addr_read_b_o <= img_bram_addr_b_reg45;
kernel_addr_output: kernel_bram_addr_read_o <= kernel_bram_addr_reg45;

img_bram_addr_choose_mode: img_bram_addr_mode <= img_bram_addr_inc_out when switch_read_mode_i = '1' else
                                                 img_mux_out; 

img_bram_waddr_incrementer: img_bram_addr_inc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(img_bram_waddr_reg34)) + 2, 16)) when axi_rvalid_i = '1' and rready_ctrl_i = '1' else
                                                     std_logic_vector(to_unsigned(to_integer(unsigned(img_bram_waddr_reg23)), 16));

img_bram_addr_choose_mode_b: img_bram_addr_mode_b <= img_bram_addr_inc_out_b when switch_read_mode_i = '1' else
                                                     img_mux_out_b; 

img_bram_waddr_incrementer_b: img_bram_addr_inc_out_b <=  std_logic_vector(to_unsigned(to_integer(unsigned(img_bram_addr_inc_out) + 1), 16));


--PHASE56: img bram

  
sumPix_add_mult: sumPixel_next <= std_logic_vector( unsigned(kernel_bram_data_read_i) * unsigned(img_bram_data_read_i) + unsigned(sumPixel_reg67 & "00000000") ) when sumPix_rst_i = "10" else
                                  std_logic_vector( unsigned(kernel_bram_data_read_i) * unsigned(img_bram_data_read_i)) when sumPix_rst_i = "11" else 
                                  (others => '0');   
sumPix_add_mult_b: sumPixel_b_next <= std_logic_vector( unsigned(kernel_bram_data_read_i) * unsigned(img_bram_data_read_b_i) + unsigned(sumPixel_b_reg67 & "00000000") ) when sumPix_rst_i = "10" else
                                  std_logic_vector( unsigned(kernel_bram_data_read_i) * unsigned(img_bram_data_read_b_i)) when sumPix_rst_i = "11" else 
                                  (others => '0');   




PHASE67: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            sumPixel_reg67 <= (others => '0');
            sumPixel_b_reg67 <= (others => '0');
        else
            sumPixel_reg67 <= sumPixel_next(23 downto 8);
            sumPixel_b_reg67 <= sumPixel_b_next(23 downto 8);
        end if;
    end if;
end process;




dram_wdata_output: dram_data_write_o <= sumPixel_reg67(15 downto 8)&sumPixel_b_reg67(15 downto 8);   
    
 

    
end Behavioral;
