import tkinter as tk
from tkinter import ttk
import serial

class SerialGUI:
    def __init__(self, master, columns):
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
        self.create_sliders(["Rand Rate", "Slew", "Level", "Y","U","V", "Vid in", "Osc1 Freq", "Dev1","level1", "Osc2 Freq", "Dev2","level2"])
        self.create_tick_boxes_column(columns)
        # self.create_tick_boxes(rows, columns)

    def on_frame_configure(self, event):
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))

    def create_sliders(self, slider_names):
        # Create sliders
        for i, slider_name in enumerate(slider_names):
            label = ttk.Label(self.frame, text=f"{slider_name}:")
            label.grid(row=0, column=i * 2, pady=2, padx=2)

            var = tk.DoubleVar()
            slider = ttk.Scale(self.frame, from_=511, to=0, orient=tk.VERTICAL, variable=var, command=self.parse_gui)
            slider.grid(row=1, column=i * 2, pady=2, padx=2)

            # Store slider variable in the dictionary
            self.slider_vars[slider_name] = var

    def get_slider_values(self):
        slider_values = {}
        for slider_name, var in self.slider_vars.items():
            slider_values[slider_name] = var.get()
        return slider_values
    

    def create_tick_boxes_column(self, column_labels):
        # Tick boxes in a single column
        self.tick_box_column_labels = [ttk.Label(self.frame, text=label) for label in column_labels]
        for i, label in enumerate(self.tick_box_column_labels):
            label.grid(row=6, column=i, pady=0, padx=0)

        self.tick_vars = []
        for row in range(len(column_labels)):
            var = tk.IntVar()
            tick_box = ttk.Checkbutton(self.frame, variable=var, command=self.parse_gui)
            tick_box.grid(row=7, column=row)
            self.tick_vars.append(var)

    def parse_gui(self, *args):
    # Get slider values
        slider_values = [self.get_slider_values()]
        for dicts in slider_values:
            for keys in dicts:
                dicts[keys] = int(dicts[keys])
        print("Slider Values:", slider_values)
        # Get tick box states
        tick_box_states = [var.get() for var in self.tick_vars]
        print("Tick Box States:", tick_box_states)

        # # Send command over serial port
        # try:
        #     if not self.serial_port.is_open:
        #         self.serial_port.open()
        #     self.serial_port.write(command.encode())
        # except serial.SerialException as e:
        #     print(f"Serial communication error: {e}")
        # finally:
        #     if self.serial_port.is_open:
        #         self.serial_port.close()


def main():
    column_labels = ["rand r/c", "osc1 sync+","osc1 sync-","osc2 sync+","osc2 sync-"]
    slider_values = None

    root = tk.Tk()
    app = SerialGUI(root, column_labels)
    root.mainloop()

if __name__ == "__main__":
    main()
