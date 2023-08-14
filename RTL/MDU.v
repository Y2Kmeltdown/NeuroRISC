module MDU(
	
	input		[31:0]	in_a,
	input		[31:0]	in_b,
	input		[2:0]	func,
	
	output	reg	[31:0]	out_Q
);



wire	[63:0]	M_Q;
wire	[63:0]	M_QU;
wire	[63:0]	D_Q;
wire	[63:0]	D_QU;

risc_multiply rm(
	.dataa(in_a),
	.datab(in_b),
	.result(M_Q)
);

risc_multiply_unsigned rmu(
	.dataa(in_a),
	.datab(in_b),
	.result(M_QU)
);

risc_divide rd(
	.denom(in_a),
	.numer(in_b),
	.quotient(D_Q[63:32]),
	.remain(D_Q[31:0])
);

risc_divide_unsigned rdu(
	.denom(in_a),
	.numer(in_b),
	.quotient(D_QU[63:32]),
	.remain(D_QU[31:0])
);

always @(*) begin
	case (func)
		3'b000		:	out_Q = M_Q[31:0]; //MUL
		3'b001		:	out_Q = M_Q[63:32];// MULH
		3'b010		:	out_Q = M_QU[63:32];// MULHSU
		3'b011		:	out_Q = M_QU[63:32];// MULHU
		3'b100		:	out_Q = D_Q[63:32];// DIV
		3'b101		:	out_Q = D_QU[63:32];// DIVU
		3'b110		:	out_Q = D_Q[31:0];// REM
		3'b111		:	out_Q = D_QU[31:0];// REMU
		endcase
	end
endmodule 