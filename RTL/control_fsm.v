module control_fsm(

	input					clk,
	input					reset_in,
	input		[6:0]		opcode,
	input		[2:0]		funct3,
	input		[6:0]		funct7,
	input					A_lt_UB,
	input					A_lt_B,
	input					EQ,
	input					mem_wait,
	
	output		[2:0]	func,
	output				sub_sra,
	output		[2:0]	rd_sel,
	output				alu_a_sel,
	output				alu_b_sel,
	output				pc_alu_sel,
	output				pc_next_sel,
	output			[2:0]	sx_size,
	output					reset,
	output	reg			mem_clk,
	output	reg			mem_rd_clk,
	output	reg			rd_clk,
	output	reg			pc_clk,
	output	reg			ir_clk
);






wire isLUI = 		(opcode == 7'b0110111);
wire isAUIPC = 	(opcode == 7'b0010111);
wire isJAL = 		(opcode == 7'b1101111);
wire isJALR = 		(opcode == 7'b1100111);
wire isBranch = 	(opcode == 7'b1100011);
wire isLoad = 		(opcode == 7'b0000011);
wire isStore = 	(opcode == 7'b0100011);
wire isImmExe = 	(opcode == 7'b0010011);
wire isExe = 		(opcode == 7'b0110011 && funct7[0] == 1'b0);
wire isFence = 	(opcode == 7'b0001111);
wire isEins = 		(opcode == 7'b1110011);
wire isMul =		(opcode == 7'b0110011 && funct7[0] == 1'b1);

wire eqCheck =		(funct3 == 3'b000)	?	EQ			: 
					  ((funct3 == 3'b001)	?	~EQ		:
					  ((funct3 == 3'b100)	?	A_lt_B	:
					  ((funct3 == 3'b101)	?	~A_lt_B	:
					  ((funct3 == 3'b110)	?	A_lt_UB	:
					  ((funct3 == 3'b111)	?	~A_lt_UB	:
														1'b0
														)))));

assign sx_size = funct3;

assign func = 	(isExe || isMul) ?  funct3 : 3'b000;

assign reset = reset_in;

assign sub_sra = isExe ? funct7[5] : 1'b0;

assign rd_sel = 	(reset_in || isJAL || isJALR) 	?	3'b000	:
					  ((isImmExe || isExe)					?	3'b001	:
					  ((isLUI)									?	3'b010	:
					  ((isLoad)									?	3'b011	:
					  ((isMul)									?	3'b100	:
																		3'b000
																		))));
																		
assign alu_a_sel =	(reset_in || isLUI || isJALR || isBranch || isLoad || isStore || isImmExe || isExe || isMul)	?	1'b0	:
						  ((isJAL || isAUIPC)																									?	1'b1	:
																																							1'b0
																																							);
																																							
assign alu_b_sel = 	(reset_in || isExe || isMul || isBranch)											?	1'b0	:
						  ((isLUI || isAUIPC || isJAL || isJALR || isStore || isImmExe || isLoad)	?	1'b1	:
																																1'b0
																																);
																													
assign pc_next_sel = 	(reset_in || isLUI || isAUIPC || isBranch || isLoad || isStore || isImmExe || isExe || isMul) 	?	1'b0	:
							  ((isJAL || isJALR)																											?	1'b1	:
																																									1'b0	
																																									);

assign pc_alu_sel = 		(isAUIPC)																												?	1'b0			:
							  ((reset_in ||isLUI || isJAL || isJALR || isLoad || isStore || isImmExe || isExe || isMul)		?	1'b1			:
							  ((isBranch)																												?	~eqCheck	:
																																								1'b1
																																								));
							 																																						
always @(posedge clk or posedge reset_in) begin
	if (reset_in) begin
		rd_clk <= 1'b0;
		mem_clk <= 1'b0;
		ir_clk <= 1'b0;
		pc_clk <= 1'b1;
	end
	else if (mem_wait) begin
	end
	else if (isLUI) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else if (isAUIPC) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
	end
	else if (isJAL) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else if (isJALR) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else if (isBranch) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
	end
	else if (isLoad) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
		mem_rd_clk <= ~mem_rd_clk;
	end
	else if (isStore) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		mem_clk <= ~mem_clk;
	end
	else if (isImmExe) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else if (isExe) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else if (isFence) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		// No Clue
	end
	else if (isEins) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		// No Clue
	end
	else if (isMul) begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
		rd_clk <= ~rd_clk;
	end
	else begin
		ir_clk <= !ir_clk;
		pc_clk <= !pc_clk;
	end
	
end

endmodule 