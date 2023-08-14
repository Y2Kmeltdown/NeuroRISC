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
// CREATED		"Mon Aug 14 13:06:10 2023"

module NeuroRISC_SOC(
	rx_pin,
	reset_pin,
	clk_pin,
	switch1_pin,
	switch2_pin,
	switch3_pin,
	switch4_pin,
	button1_pin,
	reset_LED,
	spike_out,
	LED0
);


input wire	rx_pin;
input wire	reset_pin;
input wire	clk_pin;
input wire	switch1_pin;
input wire	switch2_pin;
input wire	switch3_pin;
input wire	switch4_pin;
input wire	button1_pin;
output wire	reset_LED;
output wire	spike_out;
output wire	LED0;

wire	[31:0] spike_out_line;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_4;
wire	[31:0] SYNTHESIZED_WIRE_5;

assign	reset_LED = SYNTHESIZED_WIRE_7;




NeuroRISC_With_MEM	b2v_inst(
	.reset_in(SYNTHESIZED_WIRE_7),
	.clk_in(SYNTHESIZED_WIRE_1),
	.rx_in(rx_pin),
	.spike_in_a(SYNTHESIZED_WIRE_2),
	.spike_in_b(SYNTHESIZED_WIRE_3),
	.spike_in_c(SYNTHESIZED_WIRE_4),
	.spike_in_d(SYNTHESIZED_WIRE_5),
	.spike_out(spike_out_line));


neurorisc_fpgaTB	b2v_inst1(
	.switch0(switch1_pin),
	.switch1(switch2_pin),
	.switch2(switch3_pin),
	.switch3(switch4_pin),
	.button1(button1_pin),
	
	.spikeA(SYNTHESIZED_WIRE_2),
	.spikeB(SYNTHESIZED_WIRE_3),
	.spikeC(SYNTHESIZED_WIRE_4),
	.spikeD(SYNTHESIZED_WIRE_5));


inverter	b2v_inst2(
	.a(reset_pin),
	.b(SYNTHESIZED_WIRE_7));


PLL1	b2v_inst3(
	.refclk(clk_pin),
	.rst(SYNTHESIZED_WIRE_7),
	.outclk_0(SYNTHESIZED_WIRE_1)
	
	);

assign	spike_out = spike_out_line[0];
assign	LED0 = spike_out_line[0];

endmodule
