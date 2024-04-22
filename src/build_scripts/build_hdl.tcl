# build settings
set design_name "pong"
set arch "xc7"
set board_name "arty"
set fpga_part "xc7a35ticsg324-1L"

# set reference directories for source files
set lib_dir [file normalize "./../../../../lib"]
set origin_dir [file normalize "./../../"]

# read design sources
read_verilog -sv "${lib_dir}/clock/xc7/clock_480p.sv"
read_verilog -sv "${lib_dir}/essential/debounce.sv"
read_verilog -sv "${origin_dir}/${arch}/top_${design_name}.sv"
read_verilog -sv "${origin_dir}/simple_480p.sv"
read_verilog -sv "${origin_dir}/simple_score.sv"

# read constraints
read_xdc "${origin_dir}/${arch}/${board_name}.xdc"

# synth
synth_design -top "top_${design_name}" -part ${fpga_part}

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "${origin_dir}/${arch}/${design_name}.bit"