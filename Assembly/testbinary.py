def write_integer_to_binary_file(number, file_path):
    binary_representation = format(number, '032b')  # Convert to 32-bit binary string
    byte_array = bytearray()

    for i in range(0, len(binary_representation), 8):
        byte = int(binary_representation[i:i+8], 2)
        byte_array.append(byte)

    with open(file_path, 'wb') as f:
        f.write(byte_array)

if __name__ == "__main__":
    integer_to_write = 1  # Change this to the integer you want to write
    output_file_path = 'output.bin'  # Change this to your desired output file path

    write_integer_to_binary_file(integer_to_write, output_file_path)
    print("Integer written to binary file with leading zeros.")