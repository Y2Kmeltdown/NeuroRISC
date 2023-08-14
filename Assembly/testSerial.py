import serial
import time

ser = serial.Serial(
    port = "COM16",
    baudrate=115200,
    parity=serial.PARITY_ODD,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

testAddr = b"\xCC\x08\x09\x0A\x0B"
testData = b"\xF3\x0C\x0D\x0E\x0F"
ser.write(testAddr)
ser.write(testData)
#time.sleep(1)
#ser.write(testData)

