# Download this and put this file in the root folder: https://github.com/raczben/pysct
# HOW TO: https://voltagedivide.com/2022/12/13/fpga-xilinx-jtag-to-axi-master-from-xsdb-and-python/

#You need to install "wexpect" for python

# in Your vivado bin folder (windows) open a terminal and run 'xsdb' 
# This starts a XSDB session, Now enter "xsdbserver start -port 3010"

# Then Run this program

# SHould just be able to use xsct commands here: https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/XSCT-Commands

from pysct.core import *

def reg_dump(start_addr,num_reg_to_dump):
    regs = xsct.do(f"mrd -force 0x{start_addr} {num_reg_to_dump}")
    return regs

def invert_matrix(chanels_2_invert): # comand to invert the matrix input bits
    # Convert decimal number to hexadecimal
    hex_value = hex(chanels_2_invert)

    # Remove '0x' prefix and 'L' suffix (if present)
    hex_value = hex_value[2:].rstrip('L')

    # Pad with zeros to ensure the length is 16 characters (64 bits)
    hex_value = hex_value.zfill(16)

    # Split the 64-bit hexadecimal value into two 32-bit values
    hex_value1 = hex_value[:8]
    hex_value2 = hex_value[8:]

    xsct.do(f"mwr -force 0x1c {hex_value1}")
    xsct.do(f"mwr -force 0x20 {hex_value2}")
    return 

def wr_digital_matix(row_num, value ): #matrix in is the row we want to write to, value is which colums should be routed to that row
    hex_value = hex(value)

    # Remove '0x' prefix and 'L' suffix (if present)
    hex_value = hex_value[2:].rstrip('L')

    # Pad with zeros to ensure the length is 16 characters (64 bits)
    hex_value = hex_value.zfill(16)

    # Split the 64-bit hexadecimal value into two 32-bit values
    hex_value1 = hex_value[:8]
    hex_value2 = hex_value[8:]

    xsct.do(f"mwr -force 0x10 0x{hex_value1}")
    xsct.do(f"mwr -force 0x14 0x{hex_value2}")

    xsct.do(f"mwr -force 0x04 {row_num}")
    xsct.do(f"mwr -force 0x08 0x1") #trigger write to matrix
    xsct.do(f"mwr -force 0x08 0x0")
    return


################### make a reg translate function to turn the reg numbers into names 
# named_regs = [


#  04 ,matrix_out_addr_int
#   08 x"000000" & "0000000" & matrix_load_int; -- load flag
#   10 mask_lower;
#   14 mask_upper;
#    18 xxxxxxxxxxxx; saved for future matrix expantion
#   1C inv_lower; -- inverts the matrix inputs, lower 32
#   20 inv_upper; -- inverts the matrix inputs, upper 32
#   24 x"000000" & vid_span_int;

#   28 x"000000" & out_addr_int;
#   2C x"000000" & ch_addr_int;
#   30 x"000000" & "000" & gain_in_int;
#   34 x"000000" & "0000000" & anna_matrix_wr_int;

#   3C , pos_h_i_2 & pos_h_i_1 
#   40 , pos_v_i_2 & pos_v_i_1 
#   44 , zoom_h_i_2 & zoom_h_i_1 
#   48 , zoom_v_i_2 & zoom_v_i_1 
#   4C , circle_i_2 & circle_i_1 
#   50 , gear_i_2 & gear_i_1 
#   54 , lantern_i_2 & lantern_i_1 
#   5C , fizz_i_2 & fizz_i_1 

#   60 slew_in_i & noise_freq_i;
#   70 , cycle_recycle_i
#   74 , sync_sel_osc1_i & osc_1_derv_i & osc_1_freq_i
#   78 , sync_sel_osc2_i & osc_2_derv_i & osc_2_freq_i

#   64 , cr_level_i & y_level_i
#   68, cb_level_i
#   6C ,video_active

# ]

def print_dump(regs_list):
    regs_list = regs.split("\\n")
    for reg in regs_list:
        print(reg)
    return 

def connect(target_num):
    xsct.do("connect")
    xsct.do(f"target {target_num}")
    return

xsct = Xsct('localhost', 3010)
connect('9')


regs = reg_dump('80009200','10')
print_dump(regs)

print(xsct.do("mrd 0 10"))

# xsct.do("mrd -value 0 256") performs a read burst of 256 words instead of 1. 


#build a write comand for the digital matrix
    # add enumeration

# build a write comand for other functions