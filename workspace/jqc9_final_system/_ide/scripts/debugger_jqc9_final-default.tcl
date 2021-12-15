# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/user/workspace/jqc9_final_system/_ide/scripts/debugger_jqc9_final-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/user/workspace/jqc9_final_system/_ide/scripts/debugger_jqc9_final-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351B100ECA" && level==0 && jtag_device_ctx=="jsn-Zybo Z7-210351B100ECA-13722093-0"}
fpga -file /home/user/workspace/jqc9_final/_ide/bitstream/finalproject_design_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home/user/workspace/finalproject_design_wrapper/export/finalproject_design_wrapper/hw/finalproject_design_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home/user/workspace/jqc9_final/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home/user/workspace/jqc9_final/Debug/jqc9_final.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
