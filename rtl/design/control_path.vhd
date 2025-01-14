----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2024 10:41:52 PM
-- Design Name: 
-- Module Name: control_path - Behavioral
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

entity control_path is
  Generic(
    IMG_HEIGHT: positive := 720
  );  
  Port (
  ---------- Clocking and reset interface----------
    clk: in std_logic;
    reset: in std_logic;  
    
  ---------- Command interface ----------
    start: in std_logic;  
  
  ---------- Status interface -----------
    ready: out std_logic;
    
  ---------- Img BRAM interface ---------
    img_bram_en_o: out std_logic;  
    img_bram_we_o: out std_logic_vector(3 downto 0);
    
  ---------- Kernel BRAM interface ------
    kernel_bram_en_o: out std_logic;    
    
  ---------- Data path interface --------
    l_loop_end_i: in std_logic; 
    i_loop_end_i: std_logic;
    j_loop_end_i: in std_logic;
    kern_size_delay_i: in std_logic;
    sumPix_rst_o: out std_logic_vector(1 downto 0);
    loop_en_o: out std_logic;
    kl_loop_init_o: out std_logic;
    switch_read_mode_o: out std_logic;   
    rready_ctrl_o: out std_logic;
    --end_work_i: in std_logic;

    
    ---- AXI STREAM ----
    ---- write result channel ----
    wvalid_o: out std_logic;
    wready_i: in std_logic;
    wlast_o: out std_logic;
    ---- read, cache add channel ----
    rvalid_i: in std_logic;
    rready_o: out std_logic;    
    rlast_i: in std_logic
  );
end control_path;

architecture Behavioral of control_path is
    constant IMG_HALF_HEIGHT : positive := IMG_HEIGHT / 2;

    type state_type is(idle, init, working, cache_init, cache_add);
    signal state_reg, state_next: state_type;
    
    signal bram_init_next, bram_init_reg, bram_init_rst: std_logic := '0';
    signal cache_add_cnt_next, cache_add_cnt_reg: std_logic_vector(10 downto 0) := (others => '0');   
    
    signal img_en_next, img_en12, img_en23, img_en34, img_en45, img_en56, img_en67: std_logic := '0';
    signal img_we_next, img_we12, img_we23, img_we34, img_we45, img_we56, img_we67: std_logic_vector(3 downto 0);
    signal kernel_en_next, kernel_en12, kernel_en23, kernel_en34, kernel_en45: std_logic := '0';
    
    signal l_loop_end12, l_loop_end23, l_loop_end34, l_loop_end45, l_loop_end56, l_loop_end67: std_logic := '0';
    signal sumPix_rst_next, sumPix_rst12, sumPix_rst23, sumPix_rst34, sumPix_rst45, sumPix_rst56, sumPix_rst67: std_logic := '0';
    signal switch_read_mode_next, switch_read_mode12, switch_read_mode23, switch_read_mode34, switch_read_mode45, switch_read_mode56, switch_read_mode67: std_logic := '0';
    
    signal wlast_next, wlast12, wlast23, wlast34, wlast45, wlast56, wlast67: std_logic := '0'; 
    signal axi_rready_next, axi_rready12, axi_rready23, axi_rready34, axi_rready45, axi_rready56, axi_rready67: std_logic := '0';    
    
begin



state_process: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            state_reg <= idle;
        else
            state_reg <= state_next;
        end if;
    end if;
end process;    

burst_len_process: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            cache_add_cnt_reg <= (others => '0');
        else  
            cache_add_cnt_reg <= cache_add_cnt_next;
        end if;    
end if;
end process;

bram_init_flag: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            bram_init_reg <= '0';
        else  
            if (bram_init_rst = '1') then
                bram_init_reg <= '0';
            else    
                bram_init_reg <= bram_init_next;
            end if;
        end if;                
end if;
end process;





state_proc: process(state_reg, start, j_loop_end_i, i_loop_end_i, l_loop_end_i, kern_size_delay_i, cache_add_cnt_reg, rlast_i, bram_init_reg, wready_i, wlast67, rvalid_i)
begin

    -- default assignments
    state_next <= state_reg;
    ready <= '0';   
    axi_rready_next <= '0';              
    cache_add_cnt_next <= cache_add_cnt_reg;
    switch_read_mode_next <= '0';
    sumPix_rst_next <= '1';
    kl_loop_init_o <= '0';
    loop_en_o <= '0';   
    kernel_en_next <= '0'; 
    img_en_next <= '0';  
    img_we_next <= "0000";   
    wlast_next <= '0';
    bram_init_rst <= '0';
    bram_init_next <= '0';

    case state_reg is
        when idle => 
            ready <= '1';
            loop_en_o <= '0';
            kl_loop_init_o <= '0';
            sumPix_rst_next <= '1';
            kernel_en_next <= '0';
            cache_add_cnt_next <= (others => '0');
            if(rlast_i = '1') then
                bram_init_next <= rlast_i;
            else
                bram_init_next <= bram_init_reg;
            end if;        
            
            if(bram_init_reg = '0') then
          --      ready <= '1';
                switch_read_mode_next <= '1';
                img_en_next <= '1';
                img_we_next <= "1111"; 
                axi_rready_next <= '1';
            else             
          --      ready <= '0';      
                axi_rready_next <= '0';
                switch_read_mode_next <= '0';
                img_en_next <= '0';
                img_we_next <= "0000";
                if(start = '1') then
                    state_next <= init;
                else
                    state_next <= idle;    
                end if; 
            end if;
--            if start = '1' and bram_init_reg = '1' then
--                state_next <= init;
--            else
--                state_next <= idle;
--            end if;
         
        when init => 
            ready <= '0';
            loop_en_o <= '0';
            kl_loop_init_o <= '1';
            sumPix_rst_next <= '0';
            img_en_next <= '0';
            kernel_en_next <= '0';            
            cache_add_cnt_next <= (others => '0');    
                     
            state_next <= working;
                        
            
        when working =>  
            ready <= '0';
            kl_loop_init_o <= '0';
            sumPix_rst_next <= '0';  
            cache_add_cnt_next <= (others => '0');    
            if(wready_i = '0') then
                img_en_next <= '0';
                kernel_en_next <= '0';                
                loop_en_o <= '0';   
            else            
                if(l_loop_end_i = '1' and kern_size_delay_i = '1') then
                    img_en_next <= '0';
                    kernel_en_next <= '0';                
                    loop_en_o <= '0';
                else
                    img_en_next <= '1';
                    kernel_en_next <= '1';            
                    loop_en_o <= '1';  
                end if;
            end if;   
            if(j_loop_end_i = '1') then
                wlast_next <= '1';
            else
                wlast_next <= '0';    
            end if;                   
            if wlast67 = '1' then
                state_next <= idle;
                bram_init_rst <= '1';
            else 
                if(i_loop_end_i = '1') then    
                    state_next <= cache_init;
                else    
                    state_next <= working;
                end if;        
            end if;
                                 
         when cache_init =>
            ready <= '0';
            loop_en_o <= '0';
            kl_loop_init_o <= '0';                                    
            sumPix_rst_next <= '0';
            img_en_next <= '0';
            kernel_en_next <= '0';            
            switch_read_mode_next <= '1';           
            axi_rready_next <= '0';                                                       
                                  
            state_next <= cache_add;     
            
        when cache_add =>
            switch_read_mode_next <= '1';
            if(to_integer(unsigned(cache_add_cnt_reg)) <= IMG_HALF_HEIGHT + 5) then
                    axi_rready_next <= '1';
                    img_en_next <= '1';
                    img_we_next <= "1111";   
                if(rvalid_i = '1') then
                    cache_add_cnt_next <= std_logic_vector(unsigned(cache_add_cnt_reg) + 1);
                else
                    cache_add_cnt_next <= cache_add_cnt_reg;
                end if;    
                state_next <= cache_add;
            else
                cache_add_cnt_next <= (others => '0');
                state_next <= working;   
            end if;     
                                  
                                             
    end case;
end process;



C_PHASE12: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            img_en12 <= '0';
            img_we12 <= (others => '0');
            kernel_en12 <= '0';
            sumPix_rst12 <= '0';
            axi_rready12 <= '0';
            switch_read_mode12 <= '0';
            wlast12 <= '0';
        else
            kernel_en12 <= kernel_en_next;   
            sumPix_rst12 <= sumPix_rst_next;
            wlast12 <= wlast_next;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
               axi_rready12 <= axi_rready_next;
               switch_read_mode12 <= switch_read_mode_next;
               img_en12 <= img_en_next;
               img_we12 <= img_we_next;
            else
                axi_rready12 <= '0';
                switch_read_mode12 <= '0';
                img_en12 <= '0';
                img_we12 <= (others => '0');
            end if;    
        end if;
    end if;
end process;


C_PHASE23: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            l_loop_end23 <= '0';
            img_en23 <= '0';
            img_we23 <= (others => '0');            
            kernel_en23 <= '0';
            sumPix_rst23 <= '0';  
            axi_rready23 <= '0';    
            switch_read_mode23 <= '0';
            wlast23 <= '0';        
        else
            if(state_reg = idle or state_reg = init) then
                l_loop_end23 <= '0';
            else    
                l_loop_end23 <= l_loop_end_i;
            end if;
            kernel_en23 <= kernel_en12;
            sumPix_rst23 <= sumPix_rst12;
            wlast23 <= wlast12;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
               axi_rready23 <= axi_rready12;
               switch_read_mode23 <= switch_read_mode12;
               img_en23 <= img_en12;
               img_we23 <= img_we12;                  
            else
                axi_rready23 <= '0';
                switch_read_mode23 <= '0';
                img_en23 <= '0';
                img_we23 <= (others => '0');             
            end if;    
        end if;
    end if;
end process;


C_PHASE34: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            l_loop_end34 <= '0';
            img_en34 <= '0';
            img_we34 <= (others => '0');            
            kernel_en34 <= '0';   
            sumPix_rst34 <= '0'; 
            axi_rready34 <= '0';
            switch_read_mode34 <= '0';
            wlast34 <= '0';     
        else
            l_loop_end34 <= l_loop_end23;
            kernel_en34 <= kernel_en23;
            sumPix_rst34 <= sumPix_rst23;
            wlast34 <= wlast23;
--            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 2) then
--                axi_rready34 <= axi_rready23;
--            else
--                axi_rready34 <= '0';
--            end if;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
                axi_rready34 <= axi_rready23;
                switch_read_mode34 <= switch_read_mode23;
                img_en34 <= img_en23;
                img_we34 <= img_we23;               
            else
                axi_rready34 <= '0';
                switch_read_mode34 <= '0';
                img_en34 <= '0';
                img_we34 <= (others => '0');                    
            end if;    
        end if;
    end if;
end process;




C_PHASE45: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then       
            l_loop_end45 <= '0';
            img_en45 <= '0';
            img_we45 <= (others => '0');  
            kernel_en45 <= '0';  
            sumPix_rst45 <= '0';    
            axi_rready45 <= '0';
            switch_read_mode45 <= '0';
            wlast45 <= '0';    
        else       
            l_loop_end45 <= l_loop_end34;
            kernel_en45 <= kernel_en34;
            sumPix_rst45 <= sumPix_rst34;
            wlast45 <= wlast34;
            --if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 3) then
            --axi_rready45 <= axi_rready34;
            --else
            --axi_rready45 <= '0';
            --end if;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
                switch_read_mode45 <= switch_read_mode34;
                img_en45 <= img_en34;
                img_we45 <= img_we34;
                axi_rready45 <= axi_rready34;
            else
                switch_read_mode45 <= '0';
                img_en45 <= '0';
                img_we45 <= (others => '0');  
                axi_rready45 <= '0';
            end if;    
        end if;
    end if;
end process;

img_enable_output: img_bram_en_o <= img_en67 when axi_rready67 = '1' or state_reg = cache_add else img_en45;
img_write_en_output: img_bram_we_o <= img_we67 when axi_rready67 = '1' or state_reg = cache_add else img_we45;
kernel_enable_output: kernel_bram_en_o <= kernel_en45;


C_PHASE56: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            l_loop_end56 <= '0';
            sumPix_rst56 <= '0';
            img_en56 <= '0';
            img_we56 <= (others => '0');  
            axi_rready56 <= '0';
            switch_read_mode56 <= '0';
            wlast56 <= '0';    
        else
            l_loop_end56 <= l_loop_end45;
            sumPix_rst56 <= sumPix_rst45;
            wlast56 <= wlast45;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 4) then
                axi_rready56 <= axi_rready45;
            else
                axi_rready56 <= '0';
            end if;            
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
          --      axi_rready56 <= axi_rready45;
                switch_read_mode56 <= switch_read_mode45;
                img_en56 <= img_en45;
                img_we56 <= img_we45;               
            else
          --      axi_rready56 <= '0';
                switch_read_mode56 <= '0';
                img_en56 <= '0';
                img_we56 <= (others => '0'); 
            end if;    
        end if;
    end if;
end process;



C_PHASE67: process(clk)
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            l_loop_end67 <= '0';
            sumPix_rst67 <= '0';
            img_en67 <= '0';
            img_we67 <= (others => '0');    
            axi_rready67 <= '0';
            switch_read_mode67 <= '0';
            wlast67 <= '0';     
        else         
            sumPix_rst67 <= sumPix_rst56;
            l_loop_end67 <= l_loop_end56;
            wlast67 <= wlast56;
            if(rlast_i = '0' and to_integer(unsigned(cache_add_cnt_reg)) < IMG_HALF_HEIGHT + 5) then 
                axi_rready67 <= axi_rready56;            
                switch_read_mode67 <= switch_read_mode56;
                img_en67 <= img_en56;
                img_we67 <= img_we56;              
            else
                axi_rready67 <= '0';
                switch_read_mode67 <= '0';
                img_en67 <= '0';
                img_we67 <= (others => '0');  
            end if;         
        end if;
    end if;
end process;

sumPix_ctrl: sumPix_rst_o <= "01" when state_reg = idle or state_reg = init else
                             img_en56&(sumPix_rst67 or l_loop_end67);                      
axi_rready_output:rready_o <= axi_rready56;             


switch_read_mode_output: switch_read_mode_o <= switch_read_mode67;
axi_rready_dapatapth_ctrl_output: rready_ctrl_o <= axi_rready67;
axi_write_valid_output: wvalid_o <= l_loop_end67; 
axi_write_last_output: wlast_o <= wlast67;

end Behavioral;
