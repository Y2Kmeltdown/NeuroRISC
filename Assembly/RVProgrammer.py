import serial
import argparse
import pathlib
#TODO add address headers and data headers
parser = argparse.ArgumentParser(description="RISC V programmer")
parser.add_argument("filename", metavar="f", type=str, help="Name of hex file to upload")
parser.add_argument("-p", "--port", type=str, help="COM port of RISC processor", required=True)
args = parser.parse_args()
fileInput = pathlib.Path(args.filename)
comPort = args.port


ser = serial.Serial(
    port = comPort,
    baudrate=115200,
    parity=serial.PARITY_ODD,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

with open(fileInput, "rb") as f:
    programData = f.read()

# addrHeader = b"\xCC"
# dataHeader = b"\xF3"
# serialData = []
# for i, j in enumerate(programData):
#     if i % 4 == 0:
#         serialData.append("")
    
ser.write(programData)
