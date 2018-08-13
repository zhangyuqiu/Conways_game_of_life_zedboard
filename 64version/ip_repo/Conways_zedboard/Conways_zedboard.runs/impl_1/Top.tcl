proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {HDL-1065} -limit 10000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/Conways_zedboard.cache/wt [current_project]
  set_property parent.project_path C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/Conways_zedboard.xpr [current_project]
  set_property ip_repo_paths {
  c:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/Conways_zedboard.cache/ip
  C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard
  C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/conways_write_2_1.0
  C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/conways_write_1.0
} [current_project]
  set_property ip_output_repo c:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/Conways_zedboard.cache/ip [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/Conways_zedboard.runs/synth_1/Top.dcp
  read_xdc C:/Users/zhangyu/Desktop/Research18/64version/ip_repo/Conways_zedboard/constraints/constraints.xdc
  link_design -top Top -part xc7z020clg484-1
  write_hwdef -file Top.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force Top_opt.dcp
  report_drc -file Top_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force Top_placed.dcp
  report_io -file Top_io_placed.rpt
  report_utilization -file Top_utilization_placed.rpt -pb Top_utilization_placed.pb
  report_control_sets -verbose -file Top_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force Top_routed.dcp
  report_drc -file Top_drc_routed.rpt -pb Top_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file Top_timing_summary_routed.rpt -rpx Top_timing_summary_routed.rpx
  report_power -file Top_power_routed.rpt -pb Top_power_summary_routed.pb -rpx Top_power_routed.rpx
  report_route_status -file Top_route_status.rpt -pb Top_route_status.pb
  report_clock_utilization -file Top_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force Top.mmi }
  write_bitstream -force Top.bit 
  catch { write_sysdef -hwdef Top.hwdef -bitfile Top.bit -meminfo Top.mmi -file Top.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

