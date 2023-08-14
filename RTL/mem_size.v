module mem_size(
	input		[31:0]	mem_data,
	input		[2:0]		size,
	
	output	[31:0]	mem_out
);

wire isByte = 		 (size == 3'b000);
wire isHalfWord =	 (size == 3'b001);
wire isWord = 		 (size == 3'b010);
wire isUByte = 	 (size == 3'b100);
wire isUHalfword = (size == 3'b101);

assign mem_out = 	isByte 		? {{24{mem_data[7]}}, mem_data[7:0]} 		: 
					  (isHalfWord	? {{16{mem_data[15]}}, mem_data[15:0]} 	: 
					  (isWord		? mem_data										: 
					  (isUByte		? {24'b0, mem_data[7:0]}					: 
					  (isUHalfword ? {16'b0, mem_data[15:0]}					: 
										  32'b0
						))));

endmodule 