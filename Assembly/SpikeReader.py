import serial

comPort = "COM11"

ser = serial.Serial(
        port = comPort,
        baudrate=250000,
        parity=serial.PARITY_ODD,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
    )

def bytes_to_integers(byte_data):
    integers_list = [int(byte)-16 for byte in byte_data]
    return integers_list


while True:
    bytesToRead = ser.inWaiting()
    spikeByteData = ser.read(bytesToRead)
    print(bytes_to_integers(spikeByteData))
    
