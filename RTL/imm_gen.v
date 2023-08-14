module imm_gen(
	input		[31:0]	instr,
	
	output	[31:0]	imm
);

// The five immediate formats, see RiscV reference (link above), Fig. 2.4 p. 12
	wire [31:0] Uimm = {instr[31],   instr[30:12], {12{1'b0}}}; //0
	wire [31:0] Iimm = {{21{instr[31]}}, instr[30:20]};//1
	wire [31:0] Simm = {{21{instr[31]}}, instr[30:25],instr[11:7]};//2
	wire [31:0] Bimm = {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],1'b0};//3
	wire [31:0] Jimm = {{12{instr[31]}}, instr[19:12],instr[20],instr[30:21],1'b0};//4
	
	wire isUimm = (instr[6:0] == 7'b0110111 || instr[6:0] == 7'b0010111);
	wire isIimm = (instr[6:0] == 7'b1100111 || instr[6:0] == 7'b0000011 || instr[6:0] == 7'b0010011 || instr[6:0] == 7'b0001111);
	wire isSimm = (instr[6:0] == 7'b0100011);
	wire isBimm = (instr[6:0] == 7'b1100011);
	wire isJimm = (instr[6:0] == 7'b1101111);
	
	assign imm = isUimm ? Uimm : 
					(isIimm ? Iimm :
					(isSimm ? Simm :
					(isBimm ? Bimm :
								 Jimm
								 )));

endmodule 