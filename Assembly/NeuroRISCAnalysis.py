import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import time
import os

v = -65
u = 0
I = 10

a = 0.1
b = 0.2
c = -65
d = 2


filename = f"C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\Results Data\\izhikevichFS{I}Stimulus.csv"

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
for n in range(len(membraneDataFiltered.values)):
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

vTimeFPGA = [tValue-timeData.values[0] for tValue in timeData.values]

p = plt.plot(membraneDataFiltered.values, color='r', label='FPGA')
p = plt.plot(vData, color='g', label='Software')
plt.title("Spike Train with current input")
plt.xlabel("TimeStep")
plt.ylabel("Membrane Potential (mV)")
plt.legend()
plt.show()
plt.savefig(f"C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\results\\FPGAvsSoftwareFS{I}StimulusUnitless")

