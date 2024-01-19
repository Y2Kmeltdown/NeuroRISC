module registerFile(
	input					reset,
	input					clk,
	input					wren,
	input		[4:0] 	writeAddress,
	input		[4:0] 	readAddressA,
	input		[4:0] 	readAddressB,
	input		[31:0] 	writeData,
	output	[31:0] 	readDataA,
	output	[31:0] 	readDataB
);

	reg [31:0] registerFile [31:0];
	
	assign readDataA = registerFile[readAddressA];
	assign readDataB = registerFile[readAddressB];
	
	integer i;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
				for (i = 0; i < 32; i = i +1) begin
					registerFile[i] <= 0;
				end
			end
		else if (wren) begin
			if (writeAddress != 0)
				registerFile[writeAddress] <= writeData;
			end
			
	end
	
endmodule
