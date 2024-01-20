module instruction_reg(
	input					clk,
	input					reset,
	input		[31:0]	instr_in,
	output	[31:0]	instr_out
);

	reg [31:0] instr;
	
	assign instr_out = instr;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			instr <= 32'b0;
		end
		else begin
			instr <= instr_in;
		end
	end

endmodule 