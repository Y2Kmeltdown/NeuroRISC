import re
import argparse
import pathlib
import ast

instrOpcodes = {
    "lui": "0110111",
    "auipc": "0010111",
    "jal": "1101111",
    "jalr": "1100111",
    "beq": "1100011",
    "bne": "1100011",
    "blt": "1100011",
    "bge": "1100011",
    "bltu": "1100011",
    "bgeu": "1100011",
    "lb": "0000011",
    "lh": "0000011",
    "lw": "0000011",
    "lbu": "0000011",
    "lhu": "0000011",
    "sb": "0100011",
    "sh": "0100011",
    "sw": "0100011",
    "addi": "0010011",
    "slti": "0010011",
    "sltiu": "0010011",
    "xori": "0010011",
    "ori": "0010011",
    "andi": "0010011",
    "slli": "0010011",
    "srli": "0010011",
    "srai": "0010011",
    "add": "0110011",
    "sub": "0110011",
    "sll": "0110011",
    "slt": "0110011",
    "sltu": "0110011",
    "xor": "0110011",
    "srl": "0110011",
    "sra": "0110011",
    "or": "0110011",
    "and": "0110011",
    "fence": "0001111",
    "ecall": "1110011",
    "ebreak": "1110011",
    "mul": "0110011",
    "mulh": "0110011",
    "mulhsu": "0110011",
    "mulhu": "0110011",
    "div": "0110011",
    "divu": "0110011",
    "rem": "0110011",
    "remu": "0110011"
}

instrFunct3 = {
    "jalr": "000",
    "beq": "000",
    "bne": "001",
    "blt": "100",
    "bge": "101",
    "bltu": "110",
    "bgeu": "111",
    "lb": "000",
    "lh": "001",
    "lw": "010",
    "lbu": "100",
    "lhu": "101",
    "sb": "000",
    "sh": "001",
    "sw": "010",
    "addi": "000",
    "slti": "010",
    "sltiu": "011",
    "xori": "100",
    "ori": "110",
    "andi": "111",
    "slli": "001",
    "srli": "101",
    "srai": "101",
    "add": "000",
    "sub": "000",
    "sll": "001",
    "slt": "010",
    "sltu": "011",
    "xor": "100",
    "srl": "101",
    "sra": "101",
    "or": "110",
    "and": "111",
    "fence": "000",
    "ecall": "000",
    "ebreak": "000",
    "mul": "000",
    "mulh": "001",
    "mulhsu": "010",
    "mulhu": "011",
    "div": "100",
    "divu": "101",
    "rem": "110",
    "remu": "111"
}

instrFunct7 = {
    "slli": "0000000",
    "srli": "0000000",
    "srai": "0100000",
    "add": "0000000",
    "sub": "0100000",
    "sll": "0000000",
    "slt": "0000000",
    "sltu": "0000000",
    "xor": "0000000",
    "srl": "0000000",
    "sra": "0100000",
    "or": "0000000",
    "and": "0000000",
    "mul": "0000001",
    "mulh": "0000001",
    "mulhsu": "0000001",
    "mulhu": "0000001",
    "div": "0000001",
    "divu": "0000001",
    "rem": "0000001",
    "remu": "0000001"
}

instrType = {
    "lui": "U",
    "auipc": "U",
    "jal": "J",
    "jalr": "I",
    "beq": "B",
    "bne": "B",
    "blt": "B",
    "bge": "B",
    "bltu": "B",
    "bgeu": "B",
    "lb": "I",
    "lh": "I",
    "lw": "I",
    "lbu": "I",
    "lhu": "I",
    "sb": "S",
    "sh": "S",
    "sw": "S",
    "addi": "I",
    "slti": "I",
    "sltiu": "I",
    "xori": "I",
    "ori": "I",
    "andi": "I",
    "slli": "R",
    "srli": "R",
    "srai": "R",
    "add": "R",
    "sub": "R",
    "sll": "R",
    "slt": "R",
    "sltu": "R",
    "xor": "R",
    "srl": "R",
    "sra": "R",
    "or": "R",
    "and": "R",
    "fence": "I",
    "ecall": "I",
    "ebreak": "I",
    "mul": "R",
    "mulh": "R",
    "mulhsu": "R",
    "mulhu": "R",
    "div": "R",
    "divu": "R",
    "rem": "R",
    "remu": "R",
    "li": "P",
    "la": "P",
    "mv": "P",
    "not": "P",
    "neg": "P",
    "bgt": "P",
    "ble": "P",
    "bgtu": "P",
    "bleu": "P",
    "beqz": "P",
    "bnez": "P",
    "bgez": "P",
    "blez": "P",
    "bgtz": "P",
    "j": "P",
    "call": "P",
    "ret": "P",
    "nop": "P"
}

def signExtendBinary(binaryString:str, length:int):
    if binaryString[0] == "-":
        #Zero Extend
        zeroExtend = ("0"*(length-len(binaryString[3:])))+binaryString[3:]
        newStr = ""
        #Ones Complement
        for char in zeroExtend:
            if char == "0":
                newStr = newStr + "1"
            elif char == "1":
                newStr = newStr + "0"
        #Twos Complement
        newVal = bin(int(newStr,2)+1)[2:]
    else:
        #String is known positive so zero extend
        newVal = ("0"*(length-len(binaryString[2:])))+binaryString[2:]

    return newVal

def hexConvert(value:str):
    hexVal = hex(int(value,2))[2:]
    return "0"*(8-len(hexVal))+hexVal

def getRegisterBinary(stringValue:str):
    value = int(stringValue[1:])
    if value >= 32 or value < 0:
        raise Exception("Register is outside range of 0 to 31")
    registerBinary = bin(value)[2:]
    registerBinary = (5-len(registerBinary))*"0" + registerBinary
    return registerBinary

def generateMachineCode(parsedList:list[str]):
    mCodeList = []
    inst = parsedList[0].lower()

    iType = instrType[inst]
    if iType == "R":
        mCodeList.append(genRTypeInst(parsedList))
    elif iType == "I":
        mCodeList.append(genITypeInst(parsedList))
    elif iType == "S":
        mCodeList.append(genSTypeInst(parsedList))
    elif iType == "B":
        mCodeList.append(genBTypeInst(parsedList))
    elif iType == "U":
        mCodeList.append(genUTypeInst(parsedList))
    elif iType == "J":
        mCodeList.append(genJTypeInst(parsedList))
    elif iType == "P":
        pseudoMcode = genPseudo(parsedList)
        mCodeList = mCodeList + pseudoMcode
    return mCodeList


def genRTypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    func3 = instrFunct3[parsedList[0].lower()]
    func7 = instrFunct7[parsedList[0].lower()]
    rd = getRegisterBinary(parsedList[1])
    rs1 = getRegisterBinary(parsedList[2])
    if len(parsedList[3]) > 1:
        rs2 = getRegisterBinary(parsedList[3])
    elif len(parsedList[3]) == 1:
        rs2 = getRegisterBinary('x'+parsedList[3])
    out = func7+rs2+rs1+func3+rd+opcode
    return out

def genITypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    func3 = instrFunct3[parsedList[0].lower()]
    rd = getRegisterBinary(parsedList[1])

    if len(parsedList) == 3:
        indexData = re.split('\(',parsedList[2])
        rs1 = getRegisterBinary(indexData[1][:-1])

        imm12 = signExtendBinary(bin(int(indexData[0])), 12) # sign extend Fix immediate generation
    elif len(parsedList) == 4:
        rs1 = getRegisterBinary(parsedList[2])

        imm12 = signExtendBinary(bin(int(parsedList[3])), 12) # sign extend Fix immediate generation

    if len(imm12) > 12:
        raise Exception("Immediate Value Exceeds maximum of 4095")
    out = imm12+rs1+func3+rd+opcode
    return out

def genSTypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    func3 = instrFunct3[parsedList[0].lower()]
    rs2 = getRegisterBinary(parsedList[1])
    indexData = re.split('\(',parsedList[2])
    rs1 = getRegisterBinary(indexData[1][:-1])
    imm12 = signExtendBinary(bin(int(indexData[0])), 12)
    imm7 = imm12[0:7]
    imm5 = imm12[7:12]

    if len(imm12) > 12:
        raise Exception("Immediate Value Exceeds maximum of 4095")
    out = imm7+rs2+rs1+func3+imm5+opcode
    return out

def genBTypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    func3 = instrFunct3[parsedList[0].lower()]
    rs1 = getRegisterBinary(parsedList[1])
    rs2 = getRegisterBinary(parsedList[2])

    imm13 = signExtendBinary(bin(int(parsedList[3])), 13)
    if len(imm13) > 13:
        raise Exception("Immediate Value Exceeds maximum of 8191")
    imm7 = imm13[0]+imm13[2:8]
    imm5 = imm13[8:12]+imm13[1]
    out = imm7+rs2+rs1+func3+imm5+opcode
    return out

def genUTypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    rd = getRegisterBinary(parsedList[1])

    imm20 = signExtendBinary(bin(int(parsedList[2])), 20)
    if len(imm20) > 20:
        raise Exception("Immediate Value Exceeds maximum of 1048575")
    out = imm20+rd+opcode
    return out

def genJTypeInst(parsedList:list[str]):
    opcode = instrOpcodes[parsedList[0].lower()]
    rd = getRegisterBinary(parsedList[1])

    imm21 = signExtendBinary(bin(int(parsedList[2])), 21)
    if len(imm21) > 21:
        raise Exception("Immediate Value Exceeds maximum of 2097151")
    imm20 = imm21[0]+imm21[10:20]+imm21[9]+imm21[1:9]
    out = imm20+rd+opcode
    return out

def genPseudo(parsedList:list[str]):
    mCodeList = []
    if parsedList[0].lower() == "li":
        imm = int(parsedList[2])
        if imm < 2047 and imm >= -2048:
            parsedList.insert(2, "x0")
            parsedList[0] = "addi"
            mCodeList.append(genITypeInst(parsedList))
        else:
            val = signExtendBinary(bin(imm), 32)
            mCodeList.append(genUTypeInst(["lui", parsedList[1], str(int(val[0:20], 2))]))
            mCodeList.append(genITypeInst(["addi", parsedList[1], parsedList[1], str(int(val[20:32], 2))]))
    elif parsedList[0].lower() == "la":
        val = signExtendBinary(bin(int(parsedList[2])), 32)
        mCodeList.append(genUTypeInst(["auipc", parsedList[1], str(int(val[0:20], 2))]))
        mCodeList.append(genITypeInst(["addi", parsedList[1], parsedList[1], str(int(val[20:32], 2))]))
    elif parsedList[0].lower() == "mv":
        parsedList[0] = "addi"
        parsedList.append("0")
        mCodeList.append(genITypeInst(parsedList))
    elif parsedList[0].lower() == "not":
        parsedList[0] = "xori"
        parsedList.append("-1")
        mCodeList.append(genITypeInst(parsedList))
    elif parsedList[0].lower() == "neg":
        parsedList[0] = "sub"
        parsedList.insert(2, "x0")
        mCodeList.append(genRTypeInst(parsedList))
    elif parsedList[0].lower() == "bgt":
        parsedList[0] = "blt"
        parsedList.insert(1, parsedList[2])
        del parsedList[3]
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "ble":
        parsedList[0] = "bge"
        parsedList.insert(1, parsedList[2])
        del parsedList[3]
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "bgtu":
        parsedList[0] = "bltu"
        parsedList.insert(1, parsedList[2])
        del parsedList[3]
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "bleu":
        parsedList[0] = "bgeu"
        parsedList.insert(1, parsedList[2])
        del parsedList[3]
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "beqz":
        parsedList[0] = "beq"
        parsedList.insert(2, "x0")
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "bnez":
        parsedList[0] = "bne"
        parsedList.insert(2, "x0")
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "bgez":
        parsedList[0] = "bge"
        parsedList.insert(2, "x0")
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "blez":
        parsedList[0] = "bge"
        parsedList.insert(1, "x0")
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "bgtz":
        parsedList[0] = "blt"
        parsedList.insert(1, "x0")
        mCodeList.append(genBTypeInst(parsedList))
    elif parsedList[0].lower() == "j":
        parsedList[0] = "jal"
        parsedList.insert(1, "x0")
        mCodeList.append(genJTypeInst(parsedList))
    elif parsedList[0].lower() == "call":
        imm = int(parsedList[1])
        if imm < 2047 and imm >= -2048:
            mCodeList.append(genITypeInst(["jalr","x1",f"{imm}(x1)"]))
        else:
            val = signExtendBinary(bin(imm), 32)
            mCodeList.append(genUTypeInst(["auipc", "x1", str(int(val[0:20], 2))]))
            mCodeList.append(genITypeInst(["jalr","x1",f"{str(int(val[20:32], 2))}(x1)"]))
    elif parsedList[0].lower() == "ret":
        mCodeList.append(genITypeInst(["jalr","x0","0(x1)"]))
    elif parsedList[0].lower() == "nop":
        mCodeList.append(genITypeInst(["addi","x0","x0","0"]))

    return mCodeList
    
def generateMif(machineCode:list[str], filename:pathlib.Path):
    outputLines = []
    counter = 0
    for line in machineCode:
        newLine = f"\t{padHex(counter)}  :   {line};\n"
        outputLines.append(newLine)
        counter += 1

    footer = f"\t[{padHex(counter)}..FF]  :   00000000;\nEND;"
    outputLines.append(footer)

    with open("mifTemplate.txt") as templateF:
        template = templateF.readlines()

    outputList = template + outputLines
    #print(''.join(outputList))
    with open(filename.stem + ".mif", 'w') as f:
        f.write(''.join(outputList))

def generateHex(machineCode:list[str], filename:pathlib.Path):
    hexData = []
    for line in machineCode:
        hexLine = ["\\x"+line[i:i+2] for i in range(0, len(line), 2)]
        string = "".join(hexLine)
        hexData.append(string)

    byteString = "b'"+"".join(hexData)+"'"
    byteData = ast.literal_eval(byteString)

    with open(filename.stem+".bin", "wb") as f:
        f.write(byteData)
        

parser = argparse.ArgumentParser(description="RISC V assembler")
parser.add_argument("filename", metavar="f", type=str, help="Name of asm file to assemble")
parser.add_argument("-m", "--mif", action="store_true", help="Generate MIF file")
parser.add_argument("-b", "--bin", action="store_true", help="Generate raw binary file")
args = parser.parse_args()
fileInput = pathlib.Path(args.filename)
with open(fileInput) as f:
    inputAsm = f.readlines()

mCodeList = []
for line in inputAsm:
    try:
        commentStart = inputAsm[0].index("/*")
    except:
        commentStart = None


    if commentStart is not None:
        uncommentedLine = re.split('/\*',line)[0]
    else:
        uncommentedLine = line

    asmChars = re.split(',|\t| |\n',uncommentedLine)
    asmChars = [x for x in asmChars if x != '']
    if asmChars:
        mCodeList = mCodeList + generateMachineCode(asmChars)

mCodeList = [hexConvert(mCode) for mCode in mCodeList]

def padHex(value:int):
    output = hex(value)[2:]
    if len(output) < 3:
       output = (3-len(output))*"0" + output
    return output

if args.mif == True:
    generateMif(mCodeList, fileInput)

if args.bin == True:
    generateHex(mCodeList, fileInput)