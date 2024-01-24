import matplotlib.pyplot as plt
import pandas as pd
import os


filename = "C:\\Users\\damie\\Documents\\Coding Projects\\Verilog\\NeuroRISC\\Results Data\\izhikevichRegularSpiking5Stimulus.csv"

cur_path = os.path.dirname(__file__)

outputfiles = os.path.relpath('Results Data')

outputlist = os.listdir(outputfiles)

csvList = [i for i in outputlist if ".csv" in i]
#file = outputfiles+"\\"+csvList[4]
file = filename
print(file)
df = pd.read_csv(
    file,
    header=11,
    low_memory=False
)
df = df.drop([0])
#print(df)
#print(df.columns)
#spikeData = df.loc[:," spike_out"]
#timeSpike = df.loc[:,"time unit: ns"]

membraneData = df.filter(items=[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_in[31..0]", " NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]", "time unit: ns"])

#print(membraneData)
membraneDataFiltered = membraneData.loc[membraneData[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]"] == " 257"," NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_in[31..0]"]
print(membraneDataFiltered)
membraneDataFiltered = membraneDataFiltered.astype("int32")


timeData = membraneData.loc[membraneData[" NeuroRISC_With_MEM:inst|Memory_Mapper:inst1|i_proc_data_addr[31..0]"] == " 257","time unit: ns"]
timeData = timeData.astype("uint32")

p = plt.plot(timeData.values,membraneDataFiltered.values)
plt.title("Spike Train with current input")
plt.xlabel("Time (ns)")
plt.ylabel("Membrane Potential (mV)")
plt.show()

