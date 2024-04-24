import serial

# Define the serial port parameters
serial_port = '/dev/ttyUSB0'  # Change this to your serial port name
baud_rate = 9600

try:
    # Open the serial port
    ser = serial.Serial(serial_port, baud_rate, timeout=1)

    if ser.is_open:
        print(f"Connected to {serial_port} at {baud_rate} bps.")
        
        # Send the data
        data_to_send = "aaaa"
        ser.write(data_to_send.encode())
        print(f"Sent: {data_to_send}")

        # Close the serial port
        ser.close()
        print("Serial port closed.")

except serial.SerialException as e:
    print(f"Error: {e}")
