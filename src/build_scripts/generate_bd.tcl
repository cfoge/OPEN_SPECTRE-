# -tclargs
set BD_NAME        [ lindex $argv 0 ]
set TARGET_DEVICE  [ lindex $argv 1 ]
set NO_SYNTH       [ lindex $argv 2 ]
set EN_LANG_VHDL   [ lindex $argv 3 ]

# create a new project
create_project -force  $BD_NAME ./ -part $TARGET_DEVICE

# run the block diagram tcl
source ${BD_NAME}.tcl

# read block design file that was just created
add_files $BD_NAME.srcs/sources_1/bd/$BD_NAME/$BD_NAME.bd

# Set language for generating output products
if {${EN_LANG_VHDL} == 1} {
    set_property target_language VHDL [current_project]
} else {
    set_property target_language Verilog [current_project]
}

# build the project from the board file
set_property synth_checkpoint_mode Singular [get_files $BD_NAME.srcs/sources_1/bd/$BD_NAME/$BD_NAME.bd]
generate_target -force -verbose {all} [get_files $BD_NAME.srcs/sources_1/bd/$BD_NAME/$BD_NAME.bd]

# create the HW handoff file
write_hwdef -force -file $BD_NAME.hdf

# create the XSA hardware definition file to use later
set_property platform.board_id $BD_NAME [current_project]
set_property platform.name     $BD_NAME [current_project]
write_hw_platform -fixed -force -file ${BD_NAME}.xsa

if {${NO_SYNTH} == 0} {

    # This should trigger proc synthesis without the need for the wrapper
    # copied from the GUI.
    export_ip_user_files -of_objects [get_files $BD_NAME.bd] -no_script -sync -force -quiet
    create_ip_run [get_files -of_objects [get_fileset sources_1] $BD_NAME.bd]
    launch_runs -jobs 4 ${BD_NAME}_synth_1
    wait_on_run ${BD_NAME}_synth_1
}

close_project

