import numpy as np

def generate_sine_table(bits=12, resolution=360):
    values = []
    for i in range(resolution + 1):
        # Calculate the sine value for each angle
        angle_rad = np.radians(i)
        if i < 180:
            sine_value = int((2**(bits-1) - 1) * np.sin(angle_rad) + ((2**(bits-1) - 1)))
        else:
            sine_value = int((2**(bits-1) - 1) * np.sin(angle_rad) - ((2**(bits-1) - 1)))

        # Convert to unsigned representation
        sine_value = sine_value & ((1 << bits) - 1)

        # Convert to binary representation and append to the list
        values.append(format(sine_value, f'0{bits}b'))

    # Repeat the sine wave for a full 360 degrees
    values *= 2

    return values

# Generate the sine table for 12-bit resolution covering 0 to 180 degrees
sine_table = generate_sine_table(bits=12, resolution=180)

# Print the generated values
# Print every 2nd value
for i in range(0, len(sine_table), 2):
    print('"' + f"{sine_table[i]}" + '",')

# You can use this sine_table in your VHDL code
