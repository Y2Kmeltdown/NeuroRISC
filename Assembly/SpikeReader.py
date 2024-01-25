import serial
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.axes_grid1 import ImageGrid

neuronGrid = np.zeros(64)





comPort = "COM8"

ser = serial.Serial(
        port = comPort,
        baudrate=115200,
        parity=serial.PARITY_ODD,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
    )


def bytes_to_integers(byte_data):
    integers_list = [int(byte) for byte in byte_data]
    return integers_list

spikeList = []
for n in range(10000):
    bytesToRead = ser.inWaiting()
    spikeByteData = ser.read(bytesToRead)
    spikes = bytes_to_integers(spikeByteData)
    print(spikes)
    for spike in spikes:
        neuronGrid[spike]+=1

#print(spikeList)
neuronGrid = neuronGrid.reshape((8,8))
pixel_plot = plt.figure()
plt.title("pixel_plot") 
pixel_plot = plt.imshow( 
  neuronGrid, cmap='plasma', interpolation='nearest') 
plt.colorbar(pixel_plot)
plt.title("Neuron Map")
plt.savefig(f"C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\NetworkResults\\SpikingNetwork10OutCur64InNeur5InjCur")
