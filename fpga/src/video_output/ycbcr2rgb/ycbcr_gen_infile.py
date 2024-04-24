import numpy as np
import random

# Golden model for YCBCR to RGB
# NOTE: this is using the ITU-R BT.709 standard
def ycbcr_to_rgb(y, cb, cr):
    y = int(y, 16)
    cb = int(cb, 16)
    cr = int(cr, 16)

    # Convert to rgb
    r = y + 1.402 * (cr - 128)
    g = y - 0.344136 * (cb - 128) - 0.714136 * (cr - 128)
    b = y + 1.772 * (cb - 128)

    # Clip the values to the range [0, 1]
    r = np.clip(r, 0, 255)
    g = np.clip(g, 0, 255)
    b = np.clip(b, 0, 255)

    # Scale the values back up to 0-255
    r = format(int(r), '02X')
    g = format(int(g), '02X')
    b = format(int(b), '02X')

    return r, g, b

# Generate a random ycbcr value [y, cb, cr]
def random_ycbcr():
    group = [format(random.randint(0, 255), '02X') for _ in range(3)]
    return group

def generate_infile():
    infile = open("ycbcr_infile.txt", "w")
    outfile = open("ycbcr_model_outfile.txt", "w")

    num_values = 30

    # Use a set to ensure each ycbcr value is unique
    ycbcr_values = set()

    while len(ycbcr_values) < num_values:
        ycbcr = tuple(random_ycbcr())
        ycbcr_values.add(ycbcr)

    ycbcr_values = [list(value) for value in ycbcr_values]

    for value in ycbcr_values:
        y, cb, cr = value
        infile.write(f"{y} {cb} {cr}\n")
        r,g,b = ycbcr_to_rgb(y, cb, cr)
        outfile.write(f"{r} {g} {b}\n")

    infile.close()
    outfile.close()

if __name__ == "__main__":
    generate_infile()