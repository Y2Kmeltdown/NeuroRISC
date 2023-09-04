module counter(
	input					clk,
	input					reset,
	output	[31:0]	counter
);

reg	[30:0]	counter_reg;

always @ (posedge clk or posedge reset) begin
		if (reset) begin
			counter_reg <= 0;
		end
		else begin
			counter_reg <= counter_reg + 1;
		end
	end
	
assign counter = counter_reg;

endmodule 