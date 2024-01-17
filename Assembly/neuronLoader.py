import pathlib
import random

def int_to_binary_sign_extended(value):
    # Ensure the input is within the 32-bit signed integer range
    if value < -2**31 or value > 2**31 - 1:
        raise ValueError("Input value is out of range for a 32-bit signed integer")

    # Convert to binary representation with sign extension
    binary_string = format(value & 0xFFFFFFFF, '032b')

    return binary_string

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
                 d = 0,
                 type = None):
        #TODO initialise neuron with izhikevich stuff
        self.index = index
        self.voltage = V
        self.uVal = U
        self.current = I
        self.time = t
        self.alpha = a
        self.bravo = b
        self.charlie = c
        self.delta = d
        if type is not None:
            self.set_neuron_type(type)
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
    
    def set_inhibit_conns(self, value):
        self.inhibitoryConnections = value
    def get_inhibit_conns(self):
        return self.inhibitoryConnections
    
    def set_excite_conns(self, value):
        self.excitatoryConnections = value
    def get_excite_conns(self):
        return self.excitatoryConnections

    # Auto Set variables to a specific type of izhikevich neuron
    def set_neuron_type(self, type:str):
        """
        Used to set parameters of neuron to a specified value to exhibit specific types of neurons

        Types of neurons available

        rs - Regular Spiking

        ib - Intrinsically Bursting

        ch - Chattering

        fs - Fast Spiking

        tc - Thalamo-Cortical

        rz - Resonator

        lts - Low-THreshold Spiking
        """
        if type == "rs":
            self.set_alpha(0.02)
            self.set_bravo(0.2)
            self.set_charlie(-65)
            self.set_delta(8)
        elif type == "ib":
            self.set_alpha(0.02)
            self.set_bravo(0.2)
            self.set_charlie(-55)
            self.set_delta(4)
        elif type == "ch":
            self.set_alpha(0.02)
            self.set_bravo(0.2)
            self.set_charlie(-50)
            self.set_delta(2)
        elif type == "fs":
            self.set_alpha(0.1)
            self.set_bravo(0.2)
            self.set_charlie(-65)
            self.set_delta(2)
        elif type == "tc":
            self.set_alpha(0.02)
            self.set_bravo(0.25)
            self.set_charlie(-65)
            self.set_delta(0.05)
        elif type == "rz":
            self.set_alpha(0.1)
            self.set_bravo(0.25)
            self.set_charlie(-65)
            self.set_delta(2)
        elif type == "lts":
            self.set_alpha(0.02)
            self.set_bravo(0.25)
            self.set_charlie(-65)
            self.set_delta(2)
        else:
            raise Exception(f"No such type exists {type}. Refer to function docstring for available types")
        pass

    def generateMachineCode(self):
        #
        pass
class neuronPopulation:
    def __init__(self, size:int, type:str):
        # Generate neuron list
        self.neurons = [self.generateNeuron(a, type = type) for a in range(size)]
        


    def generateNeuron(self, index:int, type:str):

        genNeuron = neuron(index=index, type=type)

        def generate_lists_with_seed(N, seed):
            random.seed(seed)
            list1 = [random.choice([0, 1]) for _ in range(N)]
            random.seed(seed + 1)  # Change the seed for list2
            list2 = [0 if val1 == 1 else random.choice([0, 1]) for val1 in list1]

            return list1, list2
        
        excite, inhibit = generate_lists_with_seed(64, 42)
        
        genNeuron.set_excite_conns(excite)
        genNeuron.set_inhibit_conns(inhibit)
        return genNeuron
    
    def getNeuronPop(self):
        return self.neurons

    def generateMachineCode(self):
        pass
    
    pass




if __name__ == "__main__":
    print(normalised32Bit(0.5))

    neuroPop = neuronPopulation(64, type='rs')
    print(neuroPop.getNeuronPop()[63].get_index())

    test = int_to_binary_sign_extended(255)
    print(hexConvert(test))
    # Convert decimals to 32 bit integer representations
    # Generate List of integer values to store in memory
    # Convert integer list into hex list
    # Pad Hex values to fit 32 bits
    # Append Hex values to MIF format and save as a file
    pass