import serial
import argparse
import pathlib
parser = argparse.ArgumentParser(description="RISC V programmer")
parser.add_argument("filename", metavar="f", type=str, help="Name of hex file to upload")
parser.add_argument("-p", "--port", type=str, help="COM port of RISC processor", required=True)
args = parser.parse_args()
fileInput = pathlib.Path(args.filename)
comPort = args.port

def serialEncode(data, pattern1, pattern2):
    result = bytearray()
    pattern1_byte = int(pattern1, 2)  # Convert binary string to integer
    pattern1_length = len(pattern1) // 8
    pattern2_byte = int(pattern2, 2)
    pattern2_length = len(pattern2) // 8

    for i in range(0, len(data), 4):
        addressString = format(int(i/4), '032b')
        result.extend([pattern2_byte] * pattern2_length)
        for j in range(0, len(addressString), 8):
            byte = int(addressString[j:j+8], 2)
            result.append(byte)
        result.extend([pattern1_byte] * pattern1_length)
        result.extend(data[i:i+4])

    return result

def main():
    pattern1 = '11110011'
    pattern2 = '11001100'

    ser = serial.Serial(
        port = comPort,
        baudrate=115200,
        parity=serial.PARITY_ODD,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
    )

    with open(fileInput, "rb") as f:
        programData = f.read()

    serialData = serialEncode(programData, pattern1, pattern2)
    
    ser.write(serialData)

if __name__ == "__main__":
    main()