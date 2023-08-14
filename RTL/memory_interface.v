module memory_interface(

	// Processor Side Interface
		// Instruction Interface
		input		[31:0]	instr_address,
		
		output	[31:0]	instr_out,
		
		// Data Interface
		input		[31:0]	data_address,
		input		[31:0]	data_write,
		input					write_enable,
		input					read_enable,
		
		output	[31:0]	data_out,
	
	// Memory Side Interface
		// Instruction interface
		output	[31:0]	data_a,
		output	[31:0]	address_a,
		output				wren_a,
		output				rden_a,
		
		input		[31:0]	q_a,
		
		// Data interface
		output	[31:0]	data_b,
		output	[31:0]	address_b,
		output				wren_b,
		output				rden_b,
		
		input		[31:0]	q_b
);

assign address_a = instr_address >> 2;
assign instr_out = q_a;
assign wren_a = 1'b0;
assign rden_a = 1'b1;
assign data_a = 32'b0;

assign address_b = data_address;
assign data_out = q_b;
assign wren_b = write_enable;
assign rden_b = read_enable;
assign data_b = data_write;


endmodule 