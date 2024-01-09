import numpy as np
import math
import matplotlib.pyplot as plt

def create_distance_matrix(square_size):
    # Calculate the center coordinates
    center_x = square_size // 2
    center_y = square_size // 2

    # Create a matrix to store distance values
    distances = np.zeros((square_size, square_size))

    # Loop through each pixel and calculate the distance from the center
    for x in range(square_size):
        for y in range(square_size):
            # Calculate distance from the center using the Pythagorean theorem
            check1 = x - center_x
            check2 = (x - center_x)**2
            chck3 = (center_x - x)**2
            distance = math.sqrt((x - center_x)**2 + (y - center_y)**2)
            
            # Normalize the distance to be in the range [0, 255]
            normalized_distance = int(distance)#int((distance / 255) * 256)
            
            # Store the normalized distance in the matrix
            distances[y, x] = normalized_distance

    return distances

def plot_heatmap(distances):
    plt.imshow(distances, cmap='viridis', interpolation='nearest')
    plt.title("Heatmap")
    plt.xlabel("Column")
    plt.ylabel("Row")
    plt.colorbar(label="Normalized Distance")
    plt.show()

def plot_row(distance_matrix, row_number):
    row_values = distance_matrix[row_number, :]
    plt.plot(row_values)
    plt.title(f"Values along Row {row_number}")
    plt.xlabel("Column")
    plt.ylabel("Normalized Distance")
    plt.show()

if __name__ == "__main__":
    # Define the size of the square
    square_size = 512

    # Create the distance matrix
    distance_matrix = create_distance_matrix(square_size)

    # Plot the heatmap
    plot_heatmap(distance_matrix)

    # Choose a row number to plot
    row_number_to_plot = 00  # Change this to the desired row number
    plot_row(distance_matrix, row_number_to_plot)
