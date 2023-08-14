module alu(

	input		[31:0]	in_a,
	input		[31:0]	in_b,
	input		[2:0]		func,
	input					sub_sra,
	
	output	reg	[31:0]	out_Q,
	output				EQ,
	output				A_lt_B,
	output				A_lt_UB
);

wire signed [31:0] in_a_s;
wire signed [31:0] in_b_s;

assign in_a_s = in_a;
assign in_b_s = in_b;
assign EQ = (in_a == in_b);
assign A_lt_B = (in_a_s < in_b_s);
assign A_lt_UB = (in_a < in_b);

always @(*) begin
	case (func)
		3'b000	:	begin
			case (sub_sra)
				1'b1	:	out_Q = in_a_s - in_b_s; // SUB
				1'b0	:	out_Q = in_a_s + in_b_s; // ADD
			endcase
		end
		3'b001	:	out_Q = in_a << in_b[4:0]; // SLL
		3'b010	:	out_Q = (in_a_s < in_b_s) ? {31'b0,1'b0} : 32'b0; // SLT
		3'b011	:	out_Q = (in_a < in_b) ? {31'b0,1'b0} : 32'b0; // SLTU
		3'b100	:	out_Q = in_a ^ in_b; // XOR
		3'b101	:	begin
			case	(sub_sra)
				1'b1	:	out_Q = in_a_s >>> in_b_s[4:0]; // SRA
				1'b0	:	out_Q = in_a >> in_b[4:0]; // SRL
			endcase
		end
		3'b110	:	out_Q = in_a || in_b; // OR
		3'b111	:	out_Q = in_a && in_b; // AND
	endcase
end


endmodule 