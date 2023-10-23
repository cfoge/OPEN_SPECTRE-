import tkinter as tk
from tkinter import ttk
import serial

class SerialGUI:
    def __init__(self, master, rows, columns):
        self.master = master
        self.master.title("Serial Communication GUI")

        # Serial port configuration
        self.serial_port = serial.Serial()
        self.serial_port.baudrate = 9600  # Set your baudrate
        self.serial_port.port = "COM1"  # Set your COM port

        # Create a canvas with a vertical scrollbar
        self.canvas = tk.Canvas(master)
        self.scrollbar = ttk.Scrollbar(master, orient="vertical", command=self.canvas.yview)
        self.canvas.configure(yscrollcommand=self.scrollbar.set)
        self.canvas.pack(side="left", fill="both", expand=True)
        self.scrollbar.pack(side="right", fill="y")

        # Create a frame inside the canvas to hold widgets
        self.frame = ttk.Frame(self.canvas)
        self.canvas.create_window((0, 0), window=self.frame, anchor="nw")

        # Bind the frame to the canvas
        self.frame.bind("<Configure>", self.on_frame_configure)

        # Dictionary to store slider variables
        self.slider_vars = {}

        # Create widgets
        self.create_sliders(["Rand Rate", "Slew", "Level", "Y","U","V"])
        # self.create_tick_boxes(rows, columns)

    def on_frame_configure(self, event):
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))

    def create_sliders(self, slider_names):
        # Create sliders
        for i, slider_name in enumerate(slider_names):
            label = ttk.Label(self.frame, text=f"{slider_name}:")
            label.grid(row=0, column=i * 2, pady=2, padx=2)

            var = tk.DoubleVar()
            slider = ttk.Scale(self.frame, from_=100, to=0, orient=tk.VERTICAL, variable=var, command=self.parse_gui)
            slider.grid(row=1, column=i * 2, pady=2, padx=2)

            # Store slider variable in the dictionary
            self.slider_vars[slider_name] = var

    def create_tick_boxes(self, row_labels, column_labels):
        # Tick boxes
        self.tick_box_row_labels = [ttk.Label(self.frame, text=label) for label in row_labels]
        for i, label in enumerate(self.tick_box_row_labels):
            label.grid(row=i + 1, column=0, pady=0, padx=0)

        self.tick_box_column_labels = [ttk.Label(self.frame, text=label) for label in column_labels]
        for i, label in enumerate(self.tick_box_column_labels):
            label.grid(row=0, column=i + 1, pady=0, padx=0)

        self.tick_vars = []
        for row in range(len(row_labels)):
            tick_row_vars = []
            for col in range(len(column_labels)):
                var = tk.IntVar()
                tick_box = ttk.Checkbutton(self.frame, variable=var, command=self.parse_gui)
                tick_box.grid(row=row + 1, column=col + 1)
                tick_row_vars.append(var)
            self.tick_vars.append(tick_row_vars)

    def parse_gui(self, *args):
        # Identify which slider has changed and its value
        changed_slider_name = None
        for slider_name, var in self.slider_vars.items():
            if var.get() != var.get():
                changed_slider_name = slider_name
                break

        # Get tick box states
        tick_box_states = [[var.get() for var in row] for row in self.tick_vars]

        # Construct command string (customize as needed)
        command = f"ChangedSlider:{changed_slider_name}, TickBoxes:{','.join(map(str, tick_box_states))}\n"
        print(self.slider_vars.items())
        print(tick_box_states)

        # Send command over serial port
        try:
            if not self.serial_port.is_open:
                self.serial_port.open()
            self.serial_port.write(command.encode())
        except serial.SerialException as e:
            print(f"Serial communication error: {e}")
        finally:
            if self.serial_port.is_open:
                self.serial_port.close()


def main():
    row_labels = [f"X{i}" for i in range(9)] + [f"Y{i}" for i in range(9)] + ["SC6", "SC3", "SC1.5", "SC0.8", "SC0.4", "SC0.2", "OL1", "OL2", "OL3", "OL4", "INVA", "INVB", "INVC", "INVD"] + [f"EDGE{i}" for i in range(4)] + ["DELAY"] + [f"FF{i}" for i in range(2)] + [f"SH1_{i}" for i in range(2)] + [f"SH2_{i}" for i in range(2)] + [f"VID_IN{i}" for i in range(7)]  # Change as needed
    column_labels = [f"invX{i}" for i in range(9)] + [f"invY{i}" for i in range(9)] + [f"OL1_{i}" for i in range(2)] + [f"OL2_{i}" for i in range(2)] + [f"OL3_{i}" for i in range(2)] + [f"OL4_{i}" for i in range(2)] + [f"inv_{i}" for i in range(4)] + ["EDGE","DLY","FF+","FF-"] + [f"LUM{i}" for i in range(4)] + [f"C1{i}" for i in range(3)] + [f"C2{i}" for i in range(3)]  + [f"LUM{i}" for i in range(4)] + [f"C1{i}" for i in range(3)] + [f"C2{i}" for i in range(3)]# Change as needed

    root = tk.Tk()
    app = SerialGUI(root, row_labels, column_labels)
    root.mainloop()

if __name__ == "__main__":
    main()
