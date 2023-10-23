import tkinter as tk
from tkinter import ttk
import serial

class SerialGUI:
    def __init__(self, master):
        self.master = master
        self.master.title("Serial Communication GUI")

        # Serial port configuration
        self.serial_port = serial.Serial()
        self.serial_port.baudrate = 9600  # Set your baudrate
        self.serial_port.port = "COM1"  # Set your COM port

        # Dictionary to store slider variables
        self.slider_vars = {}

        # Create widgets
        self.create_sliders(["Slider1", "Slider2", "Slider3"])
        self.create_tick_boxes()

    def create_sliders(self, slider_names):
        # Create sliders
        for i, slider_name in enumerate(slider_names):
            label = ttk.Label(self.master, text=f"{slider_name}:")
            label.grid(row=0, column=i * 2, pady=10)

            var = tk.DoubleVar()
            slider = ttk.Scale(self.master, from_=0, to=100, orient=tk.HORIZONTAL, variable=var, command=self.parse_gui)
            slider.grid(row=0, column=i * 2 + 1, pady=10)
            
            # Store slider variable in the dictionary
            self.slider_vars[slider_name] = var

    def create_tick_boxes(self):
        # Tick boxes
        self.tick_box_label = ttk.Label(self.master, text="Tick Boxes:")
        self.tick_box_label.grid(row=1, column=0, pady=10)

        self.tick_vars = []
        for row in range(3):
            for col in range(3):
                var = tk.IntVar()
                tick_box = ttk.Checkbutton(self.master, variable=var, command=self.parse_gui)
                tick_box.grid(row=row + 1, column=col + 1)
                self.tick_vars.append(var)

    def parse_gui(self, *args):
        # Identify which slider has changed and its value
        changed_slider_name = None
        for slider_name, var in self.slider_vars.items():
            if var.get() != var.get():
                changed_slider_name = slider_name
                break

        # Get tick box states
        tick_box_states = [var.get() for var in self.tick_vars]

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
    root = tk.Tk()
    app = SerialGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()
