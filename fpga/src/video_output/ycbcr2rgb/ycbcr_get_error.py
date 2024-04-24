import numpy as np

def get_error():
    #TODO: Ideally this should know where the vhdl outfile lives but that will be workspace setup dependent I guess
    #      Needs thinking about, for now you just need to copy the vhdl outfile to this directory
    model_outfile = open("ycbcr_model_outfile.txt", "r")
    vhdl_outfile  = open("ycbcr_vhdl_outfile.txt", "r")

    absolute_error_r = [] 
    absolute_error_g = []
    absolute_error_b = []

    for line_model, line_vhdl in zip(model_outfile, vhdl_outfile):
        r_m, g_m, b_m = [int(val, 16) for val in line_model.split(" ")]
        # Couldn't work out how to add spaces between the hex characters in stupid vhdl lol
        r_v = int(line_vhdl[0:2], 16)
        g_v = int(line_vhdl[2:4], 16)
        b_v = int(line_vhdl[4:6], 16) 

        absolute_error_r.append(np.abs(r_v - r_m))
        absolute_error_g.append(np.abs(g_v - g_m))
        absolute_error_b.append(np.abs(b_v - b_m))
    
    model_outfile.close()
    vhdl_outfile.close()

    mean_abs_err_r = np.mean(absolute_error_r)
    mean_abs_err_g = np.mean(absolute_error_g)
    mean_abs_err_b = np.mean(absolute_error_b)

    print(mean_abs_err_r)
    print(mean_abs_err_g)
    print(mean_abs_err_b)


if __name__ == "__main__":
    get_error()