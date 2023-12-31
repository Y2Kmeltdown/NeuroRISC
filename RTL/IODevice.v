module IODevice(
	input		clk,
	input		reset,
	
	// Memory Controller Side
	
	input		[31:0]	data_in,
	input		[31:0]	addr,
	input					wren,
	output	[31:0]	data_out,
	
	// IO side
	input		[31:0]	spike_input_a, // address 0
	input		[31:0]	spike_input_b, // address 1
	input		[31:0]	spike_input_c, // address 2
	input		[31:0]	spike_input_d, // address 3
	output	[31:0] 	spike_data, 	// address 4
	input		[31:0]	counter_in 		// address 5
	
	// Method of writing instructions to instruction memory
	
	// LEDs
	// Buttons
	// Serial
	// Ethernet
	// HDMI
	// External Memory
	// Switches
	// IO PINs
	// SD Card
	// Spike_In
	// Spike_Out
);

reg	[31:0]	spike_in_a_reg;
reg	[31:0]	spike_in_b_reg;
reg	[31:0]	spike_in_c_reg;
reg	[31:0]	spike_in_d_reg;
reg	[31:0]	spike_out_reg;
reg	[31:0]	counter_in_reg;

wire	addrRegA =		(addr == 0);
wire	addrRegB =		(addr == 1);
wire	addrRegC =		(addr == 2);
wire	addrRegD =		(addr == 3);
wire	addrRegOut =	(addr == 4);
wire	addrCounter = 	(addr == 5);

assign data_out = 	addrRegA		?	spike_in_a_reg	:
						  (addrRegB		?	spike_in_b_reg	:
						  (addrRegC		?	spike_in_c_reg	:
						  (addrRegD		?	spike_in_d_reg	:
						  (addrRegOut	?	spike_out_reg	:
						  (addrCounter ?	counter_in_reg	:
												32'b0
												)))));

assign	spike_data = spike_out_reg;



always @(posedge clk or posedge reset) begin

	spike_in_a_reg <= spike_input_a;
	spike_in_b_reg <= spike_input_b;
	spike_in_c_reg <= spike_input_c;
	spike_in_d_reg <= spike_input_d;
	counter_in_reg <= counter_in;
	
	if (reset) begin
		spike_in_a_reg <= 0;
		spike_in_b_reg <= 0;
		spike_in_c_reg <= 0;
		spike_in_d_reg <= 0;
		spike_out_reg <= 0;
		counter_in_reg <= 0;
		end
	else if (addrRegOut && wren) begin
		spike_out_reg <= data_in;
		end
	end
		
		

	
endmodule
