import pathlib

def hexConvert(value:str):
    hexVal = hex(int(value,2))[2:]
    return "0"*(8-len(hexVal))+hexVal

def padHex(value:int):
    output = hex(value)[2:]
    if len(output) < 3:
       output = (3-len(output))*"0" + output
    return output

def generateMif(machineCode:list[str], filename:pathlib.Path):
    outputLines = []
    counter = 0
    for line in machineCode:
        newLine = f"\t{padHex(counter)}  :   {line};\n"
        outputLines.append(newLine)
        counter += 1

    footer = f"\t[{padHex(counter)}..1FF]  :   00000000;\nEND;"
    outputLines.append(footer)

    with open("neuronmif.txt") as templateF:
        template = templateF.readlines()

    outputList = template + outputLines
    #print(''.join(outputList))
    with open(filename.stem + ".mif", 'w') as f:
        f.write(''.join(outputList))

def normalised32Bit(num):
    print(int(num*(pow(2,32))-1))

if __name__ == "__main__":
    # Convert decimals to 32 bit integer representations
    # Generate List of integer values to store in memory
    # Convert integer list into hex list
    # Pad Hex values to fit 32 bits
    # Append Hex values to MIF format and save as a file
    pass