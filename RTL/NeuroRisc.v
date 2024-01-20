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
// CREATED		"Tue Aug 08 14:12:57 2023"

module NeuroRisc(
	CLK,
	RESET_IN,
	mem_wait,
	Data_Mem,
	Instr_Mem,
	wren_instr,
	wren_data,
	rden_instr,
	rden_data,
	Data_Addr_Out,
	Data_Out,
	Instr_Addr_Out,
	Instr_Out
);


input wire	CLK;
input wire	RESET_IN;
input wire	mem_wait;
input wire	[31:0] Data_Mem;
input wire	[31:0] Instr_Mem;
output wire	wren_instr;
output wire	wren_data;
output wire	rden_instr;
output wire	rden_data;
output wire	[31:0] Data_Addr_Out;
output wire	[31:0] Data_Out;
output wire	[31:0] Instr_Addr_Out;
output wire	[31:0] Instr_Out;

wire	[31:0] alu_out;
wire	[31:0] imm;
wire	insn_clk;
wire	[31:0] instr;
wire	[31:0] mdu_out;
wire	[31:0] pc_alu;
wire	pc_alu_sel;
wire	pc_clk;
wire	pc_next_sel;
wire	[31:0] pc_output;
wire	rd_clk;
wire	reset;
wire	[31:0] rs2_val;
wire	[2:0] sx_size;
wire	[31:0] writeback;
wire	SYNTHESIZED_WIRE_0;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[2:0] SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	[2:0] SYNTHESIZED_WIRE_20;
wire	[31:0] SYNTHESIZED_WIRE_21;
wire	[31:0] SYNTHESIZED_WIRE_22;
wire	[31:0] SYNTHESIZED_WIRE_12;
wire	[31:0] SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	[31:0] SYNTHESIZED_WIRE_19;





TwoPortMux	b2v_ALU_A(
	.sel(SYNTHESIZED_WIRE_0),
	.data0x(SYNTHESIZED_WIRE_1),
	.data1x(pc_output),
	.result(SYNTHESIZED_WIRE_21));


TwoPortMux	b2v_ALU_B(
	.sel(SYNTHESIZED_WIRE_2),
	.data0x(rs2_val),
	.data1x(imm),
	.result(SYNTHESIZED_WIRE_22));


mem_size	b2v_inst(
	.mem_data(rs2_val),
	.size(sx_size),
	.mem_out(SYNTHESIZED_WIRE_19));


FivePortMux	b2v_inst1(
	.data0x(pc_alu),
	.data1x(alu_out),
	.data2x(imm),
	.data3x(SYNTHESIZED_WIRE_3),
	.data4x(mdu_out),
	.sel(SYNTHESIZED_WIRE_4),
	.result(writeback));


imm_gen	b2v_inst10(
	.instr(instr),
	.imm(imm));


registerFile	b2v_inst11(
	.reset(reset),
	.clk(CLK),
	.wren(rd_clk),
	.readAddressA(instr[19:15]),
	.readAddressB(instr[24:20]),
	.writeAddress(instr[11:7]),
	.writeData(writeback),
	.readDataA(SYNTHESIZED_WIRE_1),
	.readDataB(rs2_val));


control_fsm	b2v_inst12(
	.clk(CLK),
	.reset_in(RESET_IN),
	.A_lt_UB(SYNTHESIZED_WIRE_5),
	.A_lt_B(SYNTHESIZED_WIRE_6),
	.EQ(SYNTHESIZED_WIRE_7),
	.mem_wait(mem_wait),
	.funct3(instr[14:12]),
	.funct7(instr[31:25]),
	.opcode(instr[6:0]),
	.sub_sra(SYNTHESIZED_WIRE_8),
	.alu_a_sel(SYNTHESIZED_WIRE_0),
	.alu_b_sel(SYNTHESIZED_WIRE_2),
	.pc_alu_sel(pc_alu_sel),
	.pc_next_sel(pc_next_sel),
	.reset(reset),
	.mem_clk(SYNTHESIZED_WIRE_17),
	.mem_rd_clk(SYNTHESIZED_WIRE_18),
	.rd_clk(rd_clk),
	.pc_clk(pc_clk),
	.ir_clk(insn_clk),
	.func(SYNTHESIZED_WIRE_20),
	.rd_sel(SYNTHESIZED_WIRE_4),
	.sx_size(sx_size));


alu	b2v_inst13(
	.sub_sra(SYNTHESIZED_WIRE_8),
	.func(SYNTHESIZED_WIRE_20),
	.in_a(SYNTHESIZED_WIRE_21),
	.in_b(SYNTHESIZED_WIRE_22),
	.EQ(SYNTHESIZED_WIRE_7),
	.A_lt_B(SYNTHESIZED_WIRE_6),
	.A_lt_UB(SYNTHESIZED_WIRE_5),
	.out_Q(alu_out));


mem_size	b2v_inst14(
	.mem_data(SYNTHESIZED_WIRE_12),
	.size(sx_size),
	.mem_out(SYNTHESIZED_WIRE_3));


MDU	b2v_inst2(
	.func(SYNTHESIZED_WIRE_20),
	.in_a(SYNTHESIZED_WIRE_21),
	.in_b(SYNTHESIZED_WIRE_22),
	.out_Q(mdu_out));


programCounter	b2v_inst4(
	.reset(reset),
	.clk(CLK),
	.wren(pc_clk),
	.pc_alu_sel(pc_alu_sel),
	.pc_next_sel(pc_next_sel),
	.pc_alu_in(pc_alu),
	.pc_imm(imm),
	.pc_in(pc_output),
	.pc_writeback(alu_out),
	.pc_alu_out(pc_alu),
	.pc_out(pc_output));


instruction_reg	b2v_inst5(
	.clk(CLK),
	.wren(insn_clk),
	.reset(reset),
	.instr_in(SYNTHESIZED_WIRE_16),
	.instr_out(instr));


memory_interface	b2v_inst9(
	.write_enable(SYNTHESIZED_WIRE_17),
	.read_enable(SYNTHESIZED_WIRE_18),
	.data_address(alu_out),
	.data_write(SYNTHESIZED_WIRE_19),
	.instr_address(pc_output),
	.q_a(Instr_Mem),
	.q_b(Data_Mem),
	.wren_a(wren_instr),
	.rden_a(rden_instr),
	.wren_b(wren_data),
	.rden_b(rden_data),
	.address_a(Instr_Addr_Out),
	.address_b(Data_Addr_Out),
	.data_a(Instr_Out),
	.data_b(Data_Out),
	.data_out(SYNTHESIZED_WIRE_12),
	.instr_out(SYNTHESIZED_WIRE_16));


endmodule
