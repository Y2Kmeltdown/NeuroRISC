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
// CREATED		"Tue Jan 16 15:57:07 2024"

module uart_dumper(
	clk,
	rdreq,
	data_in,
	uart_serial
);


input wire	clk;
input wire	rdreq;
input wire	[7:0] data_in;
output wire	uart_serial;

wire	SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;





UART_transmit_FIFO	b2v_inst(
	.wrreq(SYNTHESIZED_WIRE_4),
	.rdreq(rdreq),
	.clock(clk),
	.data(data_in),
	
	.empty(SYNTHESIZED_WIRE_3),
	.q(SYNTHESIZED_WIRE_2)
	);


uart_tx	b2v_inst1(
	.i_Clock(clk),
	.i_Tx_DV(SYNTHESIZED_WIRE_4),
	.i_Tx_Byte(SYNTHESIZED_WIRE_2),
	
	.o_Tx_Serial(uart_serial)
	);
	defparam	b2v_inst1.CLKS_PER_BIT = 87;


UART_clk	b2v_inst3(
	.clk(clk),
	.empty(SYNTHESIZED_WIRE_3),
	.uart_clk(SYNTHESIZED_WIRE_4));


endmodule
