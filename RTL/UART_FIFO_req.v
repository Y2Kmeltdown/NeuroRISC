module UART_FIFO_req
(
	input		clk,
	input		idle,
	input		empty,
	output	o_rdreq
);

	reg	r_rdreq;

	always @(posedge clk)
	begin
		if (idle && ~empty) begin
			r_rdreq <= 1'b1;
		end
		else begin
			r_rdreq <= 1'b0;
		end
	end

	
	
	assign o_rdreq = r_rdreq;
	
endmodule 