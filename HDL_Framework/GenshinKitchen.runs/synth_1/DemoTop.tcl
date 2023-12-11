# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.cache/wt [current_project]
set_property parent.project_path D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/Input_Module.v
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/Output_Module.v
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/ScriptMem.v
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/UART.v
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/clock_frequency_divider.v
  D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/new/DemoTop.v
}
read_ip -quiet D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/ip/inst_ram/inst_ram.xci
set_property used_in_implementation false [get_files -all d:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/sources_1/ip/inst_ram/inst_ram_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/constrs_1/new/cons.xdc
set_property used_in_implementation false [get_files D:/OWEN/Undergraduate/2Autumn/DigitalLogic/DLProject/HDL_Framework/GenshinKitchen.srcs/constrs_1/new/cons.xdc]


synth_design -top DemoTop -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef DemoTop.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file DemoTop_utilization_synth.rpt -pb DemoTop_utilization_synth.pb"
