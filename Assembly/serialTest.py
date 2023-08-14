import serial
import time

ser = serial.Serial(
    port = "COM16",
    baudrate=115200,
    parity=serial.PARITY_ODD,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)
ser.isOpen()
print('Enter your commands below.\r\nInsert "exit" to leave the application.')

data=1
while 1 :
    # get keyboard input
    data = input(">> ")
    if data == 'exit':
        ser.close()
        exit()
    else:
        # send the character to the device
        # (note that I happend a \r\n carriage return and line feed to the characters - this is requested by my device)
        ser.write((data).encode())
        out = ''
        # let's wait one second before reading output (let's give device time to answer)
        time.sleep(1)
        while ser.inWaiting() > 0:
            out += ser.read(1).decode()
            
        if out != '':
            print(">> " + out)