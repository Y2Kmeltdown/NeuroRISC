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

def normalised32Bit(num:float):
    return int(num*(pow(2,32))-1)

class neuron:
    excitatoryConnections = []
    inhibitoryConnections = []
    def __init__(self, 
                 index = 0, 
                 V = 0, 
                 U = 0, 
                 I = 0, 
                 t = 0, 
                 a = 0, 
                 b = 0, 
                 c = 0, 
                 d = 0):
        pass

    def set_index(self, value):
        self.index = value
    def get_index(self):
        return self.index
    
    def set_voltage(self, value):
        self.voltage = value
    def get_voltage(self):
        return self.voltage
    
    def set_uVal(self, value):
        self.uVal = value
    def get_uVal(self):
        return self.uVal
    
    def set_current(self, value):
        self.current = value
    def get_current(self):
        return self.current
    
    def set_time(self, value):
        self.time = value
    def get_time(self):
        return self.time
    
    def set_alpha(self, value):
        self.alpha = value
    def get_alpha(self):
        return self.alpha
    
    def set_bravo(self, value):
        self.bravo = value
    def get_bravo(self):
        return self.bravo
    
    def set_charlie(self, value):
        self.charlie = value
    def get_charlie(self):
        return self.charlie
    
    def set_delta(self, value):
        self.delta = value
    def get_delta(self):
        return self.delta
    
    # Auto Set variables to a specific type of izhikevich neuron
    def set_neuron_type(self, type):
        pass

    def connect_inhibitory_synapse(self, neurons:list):
        self.inhibitoryConnections.extend(neurons)
        
    def connect_excitatory_synapse(self, neurons:list):
        self.excitatoryConnections.extend(neurons)

    def generateMachineCode():
        pass
class neuronPopulation:
    def __init__(self, size:int, defaultParams:list):
        # Generate neuron list

        pass

    def generateMachineCode():
        pass
    
    pass

def projection(pop1:neuronPopulation, pop2:neuronPopulation, connectionList:list, connectionType:str):
    pass


if __name__ == "__main__":
    print(normalised32Bit(0.5))
    # Convert decimals to 32 bit integer representations
    # Generate List of integer values to store in memory
    # Convert integer list into hex list
    # Pad Hex values to fit 32 bits
    # Append Hex values to MIF format and save as a file
    pass