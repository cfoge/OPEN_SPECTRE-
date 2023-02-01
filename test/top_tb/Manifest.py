files = [
    # SystemVerilog testbench for the top module.
    "top_tb.sv"
]

# Include the top module so the testbench's use of it is found in ModelSim
modules = {
"local" : [ "../../top/" ],
}
