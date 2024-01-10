# NeuroRISC GitHub Portfolio

This Github is separated into three main components, The RTL design which is written in verilog and details the physical hardware design that is loaded on the FPGA, The bootloading which details the assembler, programmer and memory initialisation for the processor which is all written in python and finally the assembly which is the code that is executed by NeuroRISC at runtime that simulates a spiking neural network which is written in RISC V assembly code.

## HDL

This section of the code can be found in the HDL directory of the repository. It contains all of the verilog and schematic files used to compile the NeuroRISC processor. All of the work was done on Quartus Prime 18.1 and the design was compiled and run on a Terasic DE10-Nano

### NeuroRISC

The primary core design can be found in the NeuroRisc.bdf and NeuroRisc.v files. This is the file that describes the functional RISC V core that is used to perform the computations. The following files are submodules of this module.

- alu.v
- control_fsm.v
- FivePortMux.v
- imm_gen.v
- instruction_reg.v
- MDU.v
- mem_size.v
- memory_interface.v
- programCounter.v
- registerFile.v
- TwoPortMux.v
- writeback.v

![image here]()

The core is designed to conform to most of the RV32IM specifications excluding CSR instructions of RISC V which means it can perform all of the base instruction set and the multiply/divide extension. The intention of using this design is to provide a small and reprogrammable core that can efficiently emulate a spiking neural network using integer approximation.

### Memory Mapper

### UART Interface

## Bootloader

### RISC V Assembler

### NeuroRISC Programmer

### NeuroRISC Memory Loader

## Assembly

### Memory address load Routine

### Izhikevich parameter Load Routine

### Memory Pointer initialization Routine

### Spiking neuron load Routine

### IO Read Routine

### Calculation Routine

### Spike Detection Routine

### Reset Neuron Routine

### Spike Emission Routine

### Spike Store Routine

### Change neuron Routine
