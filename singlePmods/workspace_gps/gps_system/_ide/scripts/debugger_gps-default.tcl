# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\johnr\Projects\EmbeddedSystems2_FinalProject\singlePmods\workspace_gps\gps_system\_ide\scripts\debugger_gps-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\johnr\Projects\EmbeddedSystems2_FinalProject\singlePmods\workspace_gps\gps_system\_ide\scripts\debugger_gps-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351B100ECA" && level==0 && jtag_device_ctx=="jsn-Zybo Z7-210351B100ECA-13722093-0"}
fpga -file C:/Users/johnr/Projects/EmbeddedSystems2_FinalProject/singlePmods/workspace_gps/gps/_ide/bitstream/gps_design_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/johnr/Projects/EmbeddedSystems2_FinalProject/singlePmods/workspace_gps/gps_design_wrapper/export/gps_design_wrapper/hw/gps_design_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Users/johnr/Projects/EmbeddedSystems2_FinalProject/singlePmods/workspace_gps/gps/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Users/johnr/Projects/EmbeddedSystems2_FinalProject/singlePmods/workspace_gps/gps/Debug/gps.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
