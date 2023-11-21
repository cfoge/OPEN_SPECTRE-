import numpy as np

def generate_sine_table(bits=12, resolution=180):
    values = []
    for i in range(resolution + 1):
        # Calculate the sine value for each angle
        angle_rad = np.radians(i)
        sine_value = int((2**(bits-1) - 1) * np.sin(angle_rad))

        # Convert to 12-bit two's complement format
        if sine_value < 0:
            sine_value += 2**bits

        # Convert to binary representation and append to the list
        values.append(format(sine_value, f'0{bits}b'))

    return values

# Generate the sine table for 12-bit resolution covering 0 to 180 degrees
sine_table = generate_sine_table(bits=12, resolution=180)

# Print the generated values
for i, value in enumerate(sine_table):
    print('"' + f"{value}" + '",')

# You can use this sine_table in your VHDL code
