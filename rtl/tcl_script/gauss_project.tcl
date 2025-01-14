#Defining directories for the project
cd ..
set root_dir [pwd]
cd tcl_script

set ipDir ../project/apply_gaussian_blur_1.0
set projectDir ../project/apply_gaussian_blur_design
set releaseDir ../release/apply_gaussian_blur

file mkdir $ipDir
file mkdir $projectDir
file mkdir $releaseDir


#Creating the project and adding all of the source files
create_project apply_gaussian_blur_1.0 ../project/apply_gaussian_blur_1.0  -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:2.0 [current_project]
set_property target_language VHDL [current_project]

add_files -norecurse ../rtl/kernel_bram.vhd
add_files -norecurse ../rtl/img_bram.vhd
add_files -norecurse ../rtl/data_path.vhd
add_files -norecurse ../rtl/control_path.vhd
add_files -norecurse ../rtl/image_processing_block.vhd
add_files -norecurse ../rtl/apply_gaussian_top.vhd
add_files -norecurse ../rtl/apply_gaussian_blur_v1_0_S00_AXI.vhd
add_files -norecurse ../rtl/apply_gaussian_blur_v1_0.vhd

update_compile_order -fileset sources_1


#IP packaging
ipx::package_project -root_dir $root_dir/project/ip_repo -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false
ipx::unload_core $root_dir/project/ip_repo/component.xml
ipx::edit_ip_in_project -upgrade true -name edit_apply_gaussian_blur_v1_0 -directory $root_dir/project/ip_repo $root_dir/project/ip_repo/component.xml
update_compile_order -fileset sources_1

set_property vendor grupa3.org [ipx::current_core]
set_property name apply_gaussian_blur [ipx::current_core]
set_property display_name apply_gaussian_blur_v1_0 [ipx::current_core]
set_property description {Module for applying gaussian blur to images} [ipx::current_core]
set_property supported_families {zynq Production} [ipx::current_core]

set_property value_validation_range_minimum 12 [ipx::get_user_parameters KERNEL_ADDR_WIDTH -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 12 [ipx::get_user_parameters KERNEL_ADDR_WIDTH -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "KERNEL_ADDR_WIDTH" -component [ipx::current_core]]
set_property value_validation_range_minimum 16 [ipx::get_user_parameters KERNEL_DATA_WIDTH -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 16 [ipx::get_user_parameters KERNEL_DATA_WIDTH -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "KERNEL_DATA_WIDTH" -component [ipx::current_core]]
set_property value_validation_range_minimum 625 [ipx::get_user_parameters KERNEL_SIZE -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 625 [ipx::get_user_parameters KERNEL_SIZE -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "KERNEL_SIZE" -component [ipx::current_core]]
set_property value_validation_range_minimum 8 [ipx::get_user_parameters IMG_BRAM_DATA_WIDTH -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 8 [ipx::get_user_parameters IMG_BRAM_DATA_WIDTH -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "IMG_BRAM_DATA_WIDTH" -component [ipx::current_core]]
set_property value_validation_range_minimum 16 [ipx::get_user_parameters IMG_BRAM_ADDR_WIDTH -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 16 [ipx::get_user_parameters IMG_BRAM_ADDR_WIDTH -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "IMG_BRAM_ADDR_WIDTH" -component [ipx::current_core]]
set_property value_validation_range_minimum 18000 [ipx::get_user_parameters IMG_BRAM_SIZE -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 18000 [ipx::get_user_parameters IMG_BRAM_SIZE -of_objects [ipx::current_core]]
ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name "IMG_BRAM_SIZE" -component [ipx::current_core]]
set_property display_name {Image Width} [ipgui::get_guiparamspec -name "IMG_WIDTH" -component [ipx::current_core] ]
set_property widget {textEdit} [ipgui::get_guiparamspec -name "IMG_WIDTH" -component [ipx::current_core] ]
set_property value_validation_range_minimum 825 [ipx::get_user_parameters IMG_WIDTH -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 1100 [ipx::get_user_parameters IMG_WIDTH -of_objects [ipx::current_core]]
set_property display_name {Image Height} [ipgui::get_guiparamspec -name "IMG_HEIGHT" -component [ipx::current_core] ]
set_property widget {textEdit} [ipgui::get_guiparamspec -name "IMG_HEIGHT" -component [ipx::current_core] ]
set_property value_validation_range_minimum 540 [ipx::get_user_parameters IMG_HEIGHT -of_objects [ipx::current_core]]
set_property value_validation_range_maximum 720 [ipx::get_user_parameters IMG_HEIGHT -of_objects [ipx::current_core]]


ipx::add_bus_interface AXIS_M [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property display_name AXIS_M [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property physical_name axis_wdata_o [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property physical_name axis_wlast_o [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property physical_name axis_wvalid_o [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]
set_property physical_name axis_wready_i [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces AXIS_M -of_objects [ipx::current_core]]]
ipx::associate_bus_interfaces -busif AXIS_M -clock s00_axi_aclk [ipx::current_core]

ipx::add_bus_interface AXIS_S [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property display_name AXIS_S [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property physical_name axis_rdata_i [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property physical_name axis_rlast_i [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property physical_name axis_rvalid_i [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]
set_property physical_name axis_rready_o [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces AXIS_S -of_objects [ipx::current_core]]]
ipx::associate_bus_interfaces -busif AXIS_S -clock s00_axi_aclk [ipx::current_core]



set_property core_revision 2 [ipx::current_core]
ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  $root_dir/project/ip_repo [current_project]
update_ip_catalog
ipx::check_integrity -quiet [ipx::current_core]
close_project

update_compile_order -fileset sources_1
close_project


#Creating block design
create_project apply_gaussian_blur_design ../project/apply_gaussian_blur_design -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo:part0:2.0 [current_project]
set_property  ip_repo_paths  $root_dir/project/ip_repo [current_project]
update_ip_catalog

create_bd_design "gauss_block_design"
update_compile_order -fileset sources_1

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells processing_system7_0]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
endgroup
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {22} CONFIG.c_sg_include_stscntrl_strm {0} CONFIG.c_mm2s_burst_size {256} CONFIG.c_s2mm_burst_size {256}] [get_bd_cells axi_dma_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (125 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_dma_0/S_AXI_LITE} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/axi_dma_0/M_AXI_MM2S} Slave {/processing_system7_0/S_AXI_HP0} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/processing_system7_0/FCLK_CLK0 (125 MHz)} Clk_xbar {/processing_system7_0/FCLK_CLK0 (125 MHz)} Master {/axi_dma_0/M_AXI_S2MM} Slave {/processing_system7_0/S_AXI_HP0} ddr_seg {Auto} intc_ip {/axi_mem_intercon} master_apm {0}}  [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]


startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
endgroup
set_property location {1.5 374 32} [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins processing_system7_0/IRQ_F2P]
connect_bd_net [get_bd_pins xlconcat_0/In0] [get_bd_pins axi_dma_0/mm2s_introut]
connect_bd_net [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (125 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (125 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
set_property range 4K [get_bd_addr_segs {processing_system7_0/Data/SEG_axi_bram_ctrl_0_Mem0}]
save_bd_design

startgroup
create_bd_cell -type ip -vlnv grupa3.org:user:apply_gaussian_blur:1.0 apply_gaussian_blur_0
endgroup
set_property location {2 407 -428} [get_bd_cells apply_gaussian_blur_0]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_addr_a] [get_bd_pins apply_gaussian_blur_0/kernel_bram_addr_i]
connect_bd_intf_net [get_bd_intf_pins apply_gaussian_blur_0/AXIS_M] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net [get_bd_intf_pins apply_gaussian_blur_0/AXIS_S] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/processing_system7_0/FCLK_CLK0 (125 MHz)} Clk_slave {Auto} Clk_xbar {/processing_system7_0/FCLK_CLK0 (125 MHz)} Master {/processing_system7_0/M_AXI_GP0} Slave {/apply_gaussian_blur_0/S00_AXI} ddr_seg {Auto} intc_ip {/ps7_0_axi_periph} master_apm {0}}  [get_bd_intf_pins apply_gaussian_blur_0/S00_AXI]
regenerate_bd_layout
save_bd_design


#Creating hw wrapper
make_wrapper -files [get_files $projectDir/apply_gaussian_blur_design.srcs/sources_1/bd/gauss_block_design/gauss_block_design.bd] -top
add_files -norecurse $projectDir/apply_gaussian_blur_design.gen/sources_1/bd/gauss_block_design/hdl/gauss_block_design_wrapper.v
update_compile_order -fileset sources_1
set_property top gauss_block_design_wrapper [current_fileset]
update_compile_order -fileset sources_1

#Launching synth, impl and bitstream gen
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1

#Copying the bitstream into the release folder
update_compile_order -fileset sources_1
file copy -force $projectDir/apply_gaussian_blur_design.runs/impl_1/gauss_block_design_wrapper.bit $releaseDir/gauss_block_design_wrapper.bit

#Exporting hardware
write_hw_platform -fixed -include_bit -force -file $projectDir/gauss_block_design_wrapper.xsa

#Copying the .xsa file into the vitis folder
file copy -force $projectDir/gauss_block_design_wrapper.xsa $root_dir/vitis/gauss_block_design_wrapper.xsa
