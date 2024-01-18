module UART_FIFO_req
(
	input		clk,
	input		idle,
	input		empty,
	output	wrreq
);

	assign wrreq = clk&&idle&&!empty;
	
endmodule