# Download this and put this file in the root folder: https://github.com/raczben/pysct
# HOW TO: https://voltagedivide.com/2022/12/13/fpga-xilinx-jtag-to-axi-master-from-xsdb-and-python/

#You need to install "wexpect" for python

# Start a XSDB session and enter "xsdbserver start -port 3010"

# Then Run this program

# SHould just be able to use xsct commands here: https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/XSCT-Commands

from pysct.core import *

xsct = Xsct('localhost', 3010)

xsct.do("connect")
xsct.do("target 9")

print(xsct.do("mrd 0 10"))

# xsct.do("mrd -value 0 256") performs a read burst of 256 words instead of 1. 


#build a write comand for the digital matrix
    # add enumeration

# build a write comand for other functions
