import serial
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.axes_grid1 import ImageGrid

neuronGrid = np.zeros(64)





comPort = "COM8"

ser = serial.Serial(
        port = comPort,
        baudrate=250000,
        parity=serial.PARITY_ODD,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
    )


def bytes_to_integers(byte_data):
    integers_list = [(int(bin(byte)[2:][-4:], base=2), int(bin(byte)[2:][:-4]+"0"*14, base = 2)) for byte in byte_data]
    return integers_list

spikeList = []
for n in range(100000):
    bytesToRead = ser.inWaiting()
    spikeByteData = ser.read(bytesToRead)
    spikes = bytes_to_integers(spikeByteData)
    print(spikes)
    for spike in spikes:
        neuronGrid[spike[0]]+=1

#print(spikeList)
neuronGrid = neuronGrid.reshape((8,8))
pixel_plot = plt.figure()
plt.title("pixel_plot") 
pixel_plot = plt.imshow( 
  neuronGrid, cmap='plasma', interpolation='nearest') 
plt.colorbar(pixel_plot)

plt.show()
