module uart_encoder
(
	input					clk,
	input					reset,
	input 	[7:0]		i_uart_byte,
	input					i_FIFO_full,
	input					i_FIFO_empty,
	input		[6:0]		i_FIFO_usedw,
	
	output				o_FIFO_rdreq,
	output	[31:0]	o_proc_data,
	output	[31:0]	o_proc_addr,
	output				o_wren,
	output				o_error
);

parameter 	s_IDLE				= 3'b000;
parameter	s_READ_HEADER		= 3'b001;
parameter	s_READ_WORD			= 3'b010;
parameter	s_DISPATCH_WORD 	= 3'b011;
parameter	s_CLEANUP			= 3'b100;

parameter	c_ADDR				= 8'b11001100;
parameter	c_DATA				= 8'b11110011;

reg			r_wren			= 0;
reg			r_rdreq			= 1;
reg			r_Data_Flag		= 0;
reg			r_Addr_Flag		= 0;
reg			r_Data_Ready	= 0;
reg			r_Addr_Ready	= 0;
reg			r_Header_Error = 0;
reg [2:0]	r_SM_Main		= 0;
reg [2:0]	r_Byte_Cnt		= 0;
reg [7:0]	r_Read_Buffer[3:0];
reg [31:0]	r_Addr_Buffer;
reg [31:0]	r_Data_Buffer;
reg [31:0]	r_Addr;
reg [31:0]	r_Data;


always @(posedge clk or posedge reset)
	begin
		if (reset)
			begin
			r_wren 			<= 0;
			r_rdreq 			<= 1;
			r_Data_Flag 	<= 0;
			r_Addr_Flag		<= 0;
			r_Data_Ready	<= 0;
			r_Addr_Ready	<= 0;
			r_Header_Error	<=	0;
			r_SM_Main 		<= 0;
			r_Byte_Cnt		<= 0;
			r_Addr_Buffer	<=	0;
			r_Data_Buffer	<= 0;
			r_Addr			<= 0;
			r_Data			<= 0;
			end
		else
			begin
				case (r_SM_Main)
					s_IDLE:
						begin
							if (!i_FIFO_empty)
								begin
									r_SM_Main <= s_READ_HEADER;
								end
						end
					s_READ_HEADER:
						begin
							if (r_rdreq)
								begin
									r_rdreq <= 0;
								end
							else
								begin
									if (i_uart_byte == c_ADDR)
										begin
											r_Addr_Flag <= 1;
											r_SM_Main <= s_READ_WORD;
											r_rdreq <= 1;
										end
									else if (i_uart_byte == c_DATA)
										begin
											r_Data_Flag <= 1;
											r_SM_Main <= s_READ_WORD;
											r_rdreq <= 1;
										end
									else
										begin
											r_Header_Error <= 1;
											r_SM_Main <= s_CLEANUP;
											r_rdreq <= 1;
										end
								end
						end
					s_READ_WORD:
						begin
							if (!r_rdreq && r_Byte_Cnt == 3)
								begin
									if (r_Addr_Flag)
										begin
											r_Addr_Buffer <= {r_Read_Buffer[0],r_Read_Buffer[1],r_Read_Buffer[2],i_uart_byte};
											r_Addr_Ready <= 1;
											r_SM_Main <= s_DISPATCH_WORD;
										end
									else if (r_Data_Flag)
										begin
											r_Data_Buffer <= {r_Read_Buffer[0],r_Read_Buffer[1],r_Read_Buffer[2],i_uart_byte};
											r_Data_Ready <= 1;
											r_SM_Main <= s_DISPATCH_WORD;
										end
								end
							else if (r_rdreq && !i_FIFO_empty)
								begin
									r_rdreq <= 0;
								end
							else if (!r_rdreq && !i_FIFO_empty)
								begin
									r_Read_Buffer[r_Byte_Cnt] <= i_uart_byte;
									r_Byte_Cnt <= r_Byte_Cnt + 1;
									r_rdreq <= 1;
								end	
						end
					s_DISPATCH_WORD:
						begin
							if (r_Addr_Ready && r_Data_Ready)
								begin
									r_Addr <= r_Addr_Buffer;
									r_Data <= r_Data_Buffer;
									r_wren <= 1;
									r_SM_Main <= s_CLEANUP;
								end
							else
								begin
									r_SM_Main <= s_CLEANUP;
								end
						end
					s_CLEANUP:
						begin
							if (r_wren)
								begin
									r_Byte_Cnt <= 0;
									r_Data_Ready <= 0;
									r_Addr_Ready <= 0;
									r_Addr_Flag <= 0;
									r_Data_Flag <= 0;
									r_rdreq <= 1;
									r_Header_Error <= 0;
									r_wren <= 0;
									r_SM_Main <= s_IDLE;
								end
							else
								begin
									r_Byte_Cnt <= 0;
									r_Addr_Flag <= 0;
									r_Data_Flag <= 0;
									r_rdreq <= 1;
									r_Header_Error <= 0;
									r_SM_Main <= s_IDLE;
								end
						end
					default:
						r_SM_Main <= s_IDLE;
					endcase
			end
	end
	
	assign o_FIFO_rdreq 	= r_rdreq;
	assign o_proc_data	= r_Data;
	assign o_proc_addr	= r_Addr;
	assign o_wren			= r_wren;
	assign o_error			= r_Header_Error;

endmodule 