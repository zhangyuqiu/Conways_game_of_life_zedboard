# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {HDL-1065} -limit 10000
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/Conways_zedboard.cache/wt [current_project]
set_property parent.project_path C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/Conways_zedboard.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_repo_paths {
  c:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard
  c:/Users/zhangyu/Desktop/Research18/ip_repo/conways_write_2_1.0
  c:/Users/zhangyu/Desktop/Research18/ip_repo/conways_write_1.0
} [current_project]
read_verilog -library xil_defaultlib -sv {
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/pe_array_decs.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/pe_decs.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/pe.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/pe_array.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/VESADriver.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/Timer.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/FSM.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/Display.sv
  C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/srcs/Top.sv
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/constraints/constraints.xdc
set_property used_in_implementation false [get_files C:/Users/zhangyu/Desktop/Research18/ip_repo/Conways_zedboard/constraints/constraints.xdc]


synth_design -top Top -part xc7z020clg484-1


write_checkpoint -force -noxdef Top.dcp

catch { report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb }
