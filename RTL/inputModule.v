module inputModule(
	input		switch0,
	input		switch1,
	input		switch2,
	input		switch3,
	input		button1,
	
	output	[4:0]		outputA,
	output	[4:0]		outputB,
	output	[4:0]		outputC,
	output	[31:0]	outputD
);

assign outputD = 32'b10101;

assign outputA = ( switch3 && !button1) ? {2'b0,switch2,switch1,switch0} : 5'b0;
assign outputB = (!switch3 && !button1) ? {2'b0,switch2,switch1,switch0} : 5'b0;
assign outputC = (!switch3 && !button1) ? {2'b0,switch2,switch1,switch0} : 5'b0;

endmodule 