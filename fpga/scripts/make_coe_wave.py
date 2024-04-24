import math

def generate_waveform(width, depth, waveform_type):
    # Calculate the maximum value based on the width of the hex number
    max_value = pow(2,width)

    # Calculate the step size for the waveform
    step_size = 2 * math.pi / depth

    # Generate the waveform and convert each value to a hex string
    tally = []
    waveform = []
    for i in range(depth):
        t = i / (depth - 1)
        if waveform_type == 'ramp':
            value = int(max_value * t)
        elif waveform_type == 'sine':
           value = int(max_value * (math.sin(t * math.pi * 2) + 1) / 2)
        elif waveform_type == 'cos':
            value = int(max_value * (1 + math.cos(i * step_size)) / 2)
        elif waveform_type == 'triangle':
            value = int(max_value * abs(1 - 2 * (i / depth))*-1 + (max_value-1))
        elif waveform_type == 'parabola':
            value = int(max_value * (i / depth) ** 2)
        elif waveform_type == 'staircase':
            value = int(max_value * math.floor(i / (depth / 8)))
        elif waveform_type == 'sqrt':
            value = int(max_value * math.sqrt(i / depth))
        elif waveform_type == 'scurve':
            value = int((max_value-1) * (1 - math.cos(i * step_size)) / 2)
        else:
            raise ValueError("Invalid waveform type: {}".format(waveform_type))
        
        tally.append(value)#.zfill(width))
        waveform.append(hex(value)[2:])#.zfill(width))

    maxValMade = max(tally)
    maxValMade = maxValMade

    return waveform



def save_waveform(waveform, filename, concatenate, last):
    # Open the file for writing
    with open(filename, 'a' if concatenate else 'w') as f:
        if not concatenate:
            # Write the header lines
            f.write("; ********************************************************** \n")
            f.write("; Auto generated .coe waveform file\n")
            f.write("; ********************************************************** \n")
            f.write("memory_initialization_radix=16;\n")
            f.write("memory_initialization_vector=\n")

        # Write each value in the waveform to the file as a hex number
        for i, value in enumerate(waveform):
            if i == len(waveform) - 1:
                if (last):
                    f.write(value + ';')
                else:
                    f.write(value + ',\n')
            else:
                f.write(value + ',\n')


def display_waveform(waveform):
    # Determine the maximum value in the waveform
    max_value = int('f' * len(waveform[0]), 16)

    # Determine the number of values to sample
    sample_count = min(50, len(waveform))

    # Calculate the index increment between samples
    increment = max(len(waveform) // (sample_count - 1), 1)

    # Calculate the height of the ASCII art graph
    height = 10

    # Create a list of lists to represent the graph
    graph = [[' ' for _ in range(sample_count)] for _ in range(height)]

    # Fill in the graph with the sampled waveform data
    for i in range(sample_count):
        index = i * increment
        if index >= len(waveform):
            index = len(waveform) - 1
        value = waveform[index]
        y = max_value - int(value, 16)
        for j in range(height):
            if y // (max_value // height) == j:
                graph[j][i] = '#'

    # Print the graph
    for row in graph:
        print(''.join(row))

# Define the width and depth of the waveform
width = 10
depth =  pow(2,width)

# Generate and save the waveforms

sqrt        = generate_waveform(width, depth, 'sqrt')
parab       = generate_waveform(width, depth, 'parabola')
scurve      = generate_waveform(width, depth, 'scurve')
str         = generate_waveform(width, depth, 'staircase')
sine        = generate_waveform(width, depth, 'sine')
tri         = generate_waveform(width, depth, 'triangle')


# display_waveform(sqrt)
# display_waveform(parab)
# display_waveform(scurve)
# display_waveform(str)
# display_waveform(sine)
# display_waveform(tri)

save_waveform(sqrt  , 'waveforms.coe', False, False)
save_waveform(parab , 'waveforms.coe', True,False)
save_waveform(scurve, 'waveforms.coe', True,False) # needs to be fixed so it doesnt fall at the end
save_waveform(sine  , 'waveforms.coe', True,False)
save_waveform(tri   , 'waveforms.coe', True,True)

