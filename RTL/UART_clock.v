module UART_clk
(
	input		clk,
	input		empty,
	output	uart_clk
);

	assign uart_clk = clk&&!empty;
	
endmodule
