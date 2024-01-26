import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import time
import os

neuronType="CH"

if neuronType == "IB":
    v = -55
    u = 0
    I = 10

    a = 0.02
    b = 0.2
    c = -55
    d = 4
elif neuronType == "RS":
    v = -65
    u = 0
    I = 10

    a = 0.02
    b = 0.2
    c = -65
    d = 8

elif neuronType == "CH":
    v = -50
    u = 0
    I = 10

    a = 0.02
    b = 0.2
    c = -50
    d = 2

elif neuronType == "FS":
    v = -65
    u = 0
    I = 10

    a = 0.1
    b = 0.2
    c = -65
    d = 2



filename = f"C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\Results Data\\izhikevich{neuronType}{I}Stimulus.csv"

file = filename
print(file)
df = pd.read_csv(
    file,
    header=15,
    low_memory=False
)
df = df.drop([0])
#print(df)
#print(df.columns)
#spikeData = df.loc[:," spike_out"]
#timeSpike = df.loc[:,"time unit: ns"]

membraneData = df.filter(items=[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_in[31..0]", " NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]", "time unit: ns"])

membraneData = membraneData[(membraneData[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]"] == " 256").idxmax():]


#print(membraneData)
membraneDataFiltered = membraneData.loc[membraneData[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]"] == " 257"," NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_in[31..0]"]
membraneDataFiltered = membraneDataFiltered.astype("int32")


timeData = membraneData.loc[membraneData[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]"] == " 257","time unit: ns"]
timeData = timeData.astype("uint32")


vData = [v]
vTime = [0]
vTimeInit = time.perf_counter_ns()
t = time.perf_counter_ns()
for n in range(len(membraneDataFiltered.values)-1):
    tNew = time.perf_counter_ns() - vTimeInit
    dt = tNew - t
    dtsecs = dt*10**-9

    dv = 0.04*v**2 + 5*v + 140 - u + I
    du = a*(b*v -u)
    

    v+=dv
    u+=du

    vData.append(v)
    vTime.append(tNew)
    if v >= 30:
        v = c
        u+=d
    t = tNew

error = []
for vS, vF in zip(vData,membraneDataFiltered.values):
    error.append(abs(((vF-vS)/vS)*100))

print(error)

vTimeFPGA = [tValue-timeData.values[0] for tValue in timeData.values]

fig, (ax1, ax2) = plt.subplots(2,1,sharey=True)
ax1.plot(membraneDataFiltered.values, color='r', label='FPGA')
ax1.set_title("FPGA Neuron")
#ax1.ylabel("Membrane Potential(mV)")
ax2.plot(vData, color='g', label='Software')
ax2.set_title("Software Neuron")
#ax2.ylabel("Membrane Potential(mV)")

#p = plt.plot(membraneDataFiltered.values, color='r', label='FPGA')
#p = plt.plot(error, color='b', label='Software')
#plt.title("Relative Error of integer based calculation.")
plt.xlabel("TimeStep")
plt.ylabel("Membrane Potential (mV)")
#plt.legend()
#plt.show()

#print(len(vData))
#print(len(membraneDataFiltered.values))
#plt.savefig(f"C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\results\\FPGAvsSoftwareFS{I}StimulusUnitless")
plt.show()

