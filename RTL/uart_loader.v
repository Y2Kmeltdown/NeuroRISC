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
// CREATED		"Tue Aug 08 13:44:49 2023"

module uart_loader(
	clk,
	reset,
	rx_pin,
	wren,
	decode_error,
	uart_error,
	uart_active,
	addr,
	data
);


input wire	clk;
input wire	reset;
input wire	rx_pin;
output wire	wren;
output wire	decode_error;
output wire	uart_error;
output wire	uart_active;
output wire	[31:0] addr;
output wire	[31:0] data;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[7:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	[6:0] SYNTHESIZED_WIRE_5;
wire	[7:0] SYNTHESIZED_WIRE_6;





uartFIFO	b2v_inst(
	.wrreq(SYNTHESIZED_WIRE_0),
	.rdreq(SYNTHESIZED_WIRE_1),
	.clock(clk),
	.sclr(reset),
	.data(SYNTHESIZED_WIRE_2),
	.full(SYNTHESIZED_WIRE_3),
	.empty(SYNTHESIZED_WIRE_4),
	.q(SYNTHESIZED_WIRE_6),
	.usedw(SYNTHESIZED_WIRE_5));


uart_rx	b2v_inst3(
	.i_Clock(clk),
	.i_Rx_Serial(rx_pin),
	.o_Rx_DV(SYNTHESIZED_WIRE_0),
	.o_Rx_Error(uart_error),
	.o_Active(uart_active),
	.o_Rx_Byte(SYNTHESIZED_WIRE_2));
	defparam	b2v_inst3.CLKS_PER_BIT = 87;


uart_encoder	b2v_inst6(
	.clk(clk),
	.reset(reset),
	.i_FIFO_full(SYNTHESIZED_WIRE_3),
	.i_FIFO_empty(SYNTHESIZED_WIRE_4),
	.i_FIFO_usedw(SYNTHESIZED_WIRE_5),
	.i_uart_byte(SYNTHESIZED_WIRE_6),
	.o_FIFO_rdreq(SYNTHESIZED_WIRE_1),
	.o_wren(wren),
	.o_error(decode_error),
	.o_proc_addr(addr),
	.o_proc_data(data));
	defparam	b2v_inst6.c_ADDR = 8'b11001100;
	defparam	b2v_inst6.c_DATA = 8'b11110011;
	defparam	b2v_inst6.s_CLEANUP = 3'b100;
	defparam	b2v_inst6.s_DISPATCH_WORD = 3'b011;
	defparam	b2v_inst6.s_IDLE = 3'b000;
	defparam	b2v_inst6.s_READ_HEADER = 3'b001;
	defparam	b2v_inst6.s_READ_WORD = 3'b010;


endmodule
