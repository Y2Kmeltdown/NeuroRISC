module programCounter(
	input 				reset,
	input					clk,
	input					wren,
	input					pc_alu_sel,
	input					pc_next_sel,
	input		[31:0]	pc_imm,
	input		[31:0]	pc_alu_in,
	input		[31:0]	pc_in,
	input		[31:0]	pc_writeback,
	output 	[31:0]	pc_alu_out,
	output	[31:0]	pc_out
);

	// 1 is add 4 to program count
	// 0 is add immediate to program counter
	wire [31:0] pc_inc = pc_alu_sel ? 32'd4 : pc_imm-32'd4;
	
	// 1 is add alu to program counter
	// 0 is add program counter alu to program counter
	wire [31:0] pc_to_reg = pc_next_sel ? pc_writeback : pc_alu_in;
	
	assign pc_alu_out = pc_inc + pc_in;

	reg [31:0] pc;
	
	assign pc_out = pc;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			pc <= 32'b0;
			end
		else if (wren) begin
			pc <= pc_to_reg;
		end
	end

endmodule
