with open("mifInput.txt") as inputF:
    inputLines = inputF.readlines()

def padHex(value:int):
    output = hex(value)[2:]
    if len(output) < 3:
       output = (3-len(output))*"0" + output
    return output

outputLines = []
counter = 0
for line in inputLines:
    newLine = f"\t{padHex(counter)}  :   {line[:-2]};\n"
    outputLines.append(newLine)
    counter += 1


footer = f"\t[{padHex(counter)}..7FF]  :   00000000;\nEND;"
outputLines.append(footer)

with open("mifTemplate.txt") as templateF:
    template = templateF.readlines()

outputList = template + outputLines
print(''.join(outputList))
with open("mem.mif", 'w') as f:
    f.write(''.join(outputList))