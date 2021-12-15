# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home/user/workspace/finalproject_design_wrapper/platform.tcl
# 
# OR launch xsct and run below command.
# source /home/user/workspace/finalproject_design_wrapper/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {finalproject_design_wrapper}\
-hw {/home/user/Desktop/finalproject_design_wrapper.xsa}\
-out {/home/user/workspace}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {finalproject_design_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform generate
platform config -updatehw {/home/user/Desktop/finalproject/finalproject_design_wrapper.xsa}
platform generate -domains 
