// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Mon Aug 14 13:05:54 2023"

module NeuroRISC_With_MEM(
	reset_in,
	clk_in,
	rx_in,
	spike_in_a,
	spike_in_b,
	spike_in_c,
	spike_in_d,
	spike_out
);


input wire	reset_in;
input wire	clk_in;
input wire	rx_in;
input wire	[31:0] spike_in_a;
input wire	[31:0] spike_in_b;
input wire	[31:0] spike_in_c;
input wire	[31:0] spike_in_d;
output wire	[31:0] spike_out;

wire	[31:0] data_addr_line;
wire	[31:0] instr_addr_line;
wire	[31:0] instr_rd_line;
wire	SYNTHESIZED_WIRE_33;
wire	SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[31:0] SYNTHESIZED_WIRE_10;
wire	[31:0] SYNTHESIZED_WIRE_11;
wire	[31:0] SYNTHESIZED_WIRE_12;
wire	[31:0] SYNTHESIZED_WIRE_13;
wire	[31:0] SYNTHESIZED_WIRE_14;
wire	[31:0] SYNTHESIZED_WIRE_15;
wire	[31:0] SYNTHESIZED_WIRE_16;
wire	[31:0] SYNTHESIZED_WIRE_17;
wire	[31:0] SYNTHESIZED_WIRE_18;
wire	[31:0] SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	[31:0] SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_24;
wire	[31:0] SYNTHESIZED_WIRE_25;
wire	[31:0] SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_30;
wire	[31:0] SYNTHESIZED_WIRE_31;
wire	[31:0] SYNTHESIZED_WIRE_32;





NeuroRisc	b2v_inst(
	.CLK(clk_in),
	.RESET_IN(SYNTHESIZED_WIRE_33),
	.mem_wait(SYNTHESIZED_WIRE_1),
	.Data_Mem(SYNTHESIZED_WIRE_2),
	.Instr_Mem(SYNTHESIZED_WIRE_3),
	.wren_instr(SYNTHESIZED_WIRE_4),
	.wren_data(SYNTHESIZED_WIRE_6),
	.rden_instr(SYNTHESIZED_WIRE_5),
	.rden_data(SYNTHESIZED_WIRE_7),
	.Data_Addr_Out(SYNTHESIZED_WIRE_15),
	.Data_Out(SYNTHESIZED_WIRE_16),
	.Instr_Addr_Out(SYNTHESIZED_WIRE_17),
	.Instr_Out(SYNTHESIZED_WIRE_18));


Memory_Mapper	b2v_inst1(
	.clk(clk_in),
	.reset(reset_in),
	.i_instr_wren(SYNTHESIZED_WIRE_4),
	.i_instr_rden(SYNTHESIZED_WIRE_5),
	.i_data_wren(SYNTHESIZED_WIRE_6),
	.i_data_rden(SYNTHESIZED_WIRE_7),
	.i_ld_instr_wren(SYNTHESIZED_WIRE_8),
	.i_ld_instr_active(SYNTHESIZED_WIRE_9),
	.i_IO_data_in(SYNTHESIZED_WIRE_10),
	.i_ld_instr_addr(SYNTHESIZED_WIRE_11),
	.i_ld_instr_in(SYNTHESIZED_WIRE_12),
	.i_mem_data_in(SYNTHESIZED_WIRE_13),
	.i_mem_instr_in(SYNTHESIZED_WIRE_14),
	.i_proc_data_addr(SYNTHESIZED_WIRE_15),
	.i_proc_data_in(SYNTHESIZED_WIRE_16),
	.i_proc_instr_addr(SYNTHESIZED_WIRE_17),
	.i_proc_instr_in(SYNTHESIZED_WIRE_18),
	.i_rd_instr_in(SYNTHESIZED_WIRE_19),
	.o_mem_wait(SYNTHESIZED_WIRE_1),
	.o_reset_out(SYNTHESIZED_WIRE_33),
	.o_IO_data_wren(SYNTHESIZED_WIRE_24),
	
	.o_mem_data_wren(SYNTHESIZED_WIRE_20),
	.o_mem_data_rden(SYNTHESIZED_WIRE_21),
	.o_mem_instr_wren(SYNTHESIZED_WIRE_29),
	.o_mem_instr_rden(SYNTHESIZED_WIRE_30),
	.o_rd_instr_wren(SYNTHESIZED_WIRE_27),
	.o_rd_instr_rden(SYNTHESIZED_WIRE_28),
	.o_IO_data_addr(SYNTHESIZED_WIRE_25),
	.o_IO_data_out(SYNTHESIZED_WIRE_26),
	.o_mem_data_addr(data_addr_line),
	.o_mem_data_out(SYNTHESIZED_WIRE_22),
	.o_mem_instr_addr(instr_addr_line),
	.o_mem_instr_out(SYNTHESIZED_WIRE_32),
	.o_proc_data_out(SYNTHESIZED_WIRE_2),
	.o_proc_instr_out(SYNTHESIZED_WIRE_3),
	.o_rd_instr_addr(instr_rd_line),
	.o_rd_instr_out(SYNTHESIZED_WIRE_31));
	defparam	b2v_inst1.data_mem_size = 512;
	defparam	b2v_inst1.instr_mem_size = 256;
	defparam	b2v_inst1.io_data_size = 5;


uart_loader	b2v_inst2(
	.clk(clk_in),
	.reset(reset_in),
	.rx_pin(rx_in),
	.wren(SYNTHESIZED_WIRE_8),
	
	
	.uart_active(SYNTHESIZED_WIRE_9),
	.addr(SYNTHESIZED_WIRE_11),
	.data(SYNTHESIZED_WIRE_12));


data_memory	b2v_inst4(
	.wren(SYNTHESIZED_WIRE_20),
	.rden(SYNTHESIZED_WIRE_21),
	.clock(clk_in),
	.data(SYNTHESIZED_WIRE_22),
	.rdaddress(data_addr_line[8:0]),
	.wraddress(data_addr_line[8:0]),
	.q(SYNTHESIZED_WIRE_13));


IODevice	b2v_inst5(
	.clk(clk_in),
	.reset(SYNTHESIZED_WIRE_33),
	.wren(SYNTHESIZED_WIRE_24),
	.addr(SYNTHESIZED_WIRE_25),
	.data_in(SYNTHESIZED_WIRE_26),
	.spike_input_a(spike_in_a),
	.spike_input_b(spike_in_b),
	.spike_input_c(spike_in_c),
	.spike_input_d(spike_in_d),
	.data_out(SYNTHESIZED_WIRE_10),
	.spike_data(spike_out));


instr_mem	b2v_inst7(
	.wren_a(SYNTHESIZED_WIRE_27),
	.rden_a(SYNTHESIZED_WIRE_28),
	.wren_b(SYNTHESIZED_WIRE_29),
	.rden_b(SYNTHESIZED_WIRE_30),
	.clock(clk_in),
	.address_a(instr_rd_line[7:0]),
	.address_b(instr_addr_line[7:0]),
	.data_a(SYNTHESIZED_WIRE_31),
	.data_b(SYNTHESIZED_WIRE_32),
	.q_a(SYNTHESIZED_WIRE_19),
	.q_b(SYNTHESIZED_WIRE_14));


endmodule
