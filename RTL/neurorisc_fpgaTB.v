module neurorisc_fpgaTB(
	input		switch0,
	input		switch1,
	input		switch2,
	input		switch3,
	input		button1,
	
	output		buttonCLK,
	output	[31:0]	spikeA,
	output	[31:0]	spikeB,
	output	[31:0]	spikeC,
	output	[31:0]	spikeD
);

assign spikeA = switch0 ?	32'd10 : 32'd0;
assign spikeB = switch1 ?	32'd1 : 32'd0;
assign spikeC = switch2 ?	32'd2 : 32'd0;
assign spikeD = switch3 ?	32'd5: 32'd0;




endmodule 