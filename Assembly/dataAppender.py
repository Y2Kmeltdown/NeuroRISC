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
    input_file_path = 'izhikevich.hex'    # Change this to your input file path
    output_file_path = 'test.bin'  # Change this to your output file path
    pattern1 = '11110011'
    pattern2 = '11001100'

    with open(input_file_path, 'rb') as f:
        file_data = f.read()

    modified_data = serialEncode(file_data, pattern1, pattern2)

    with open(output_file_path, 'wb') as f:
        f.write(modified_data)

    print("Pattern inserted successfully!")

if __name__ == "__main__":
    main()