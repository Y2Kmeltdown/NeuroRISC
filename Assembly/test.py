def normalised32Bit(num:float):
    return int(num*(pow(2,32))-1)

print(normalised32Bit(0.1))