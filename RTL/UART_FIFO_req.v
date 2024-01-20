module UART_FIFO_req
(
	input		clk,
	input		idle,
	input		empty,
	output	rdreq
);

	assign rdreq = clk&&idle&&!empty;
	
endmodule