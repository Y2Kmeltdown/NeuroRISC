module Memory_Mapper
#(
	parameter instr_mem_size = 256,
	parameter data_mem_size = 512,
	parameter io_data_size = 5
)
(

	input					clk,
	input					reset,
	output				o_mem_wait,
	output				o_reset_out,
	
	// Processor Bus
	input		[31:0]	i_proc_instr_in,
	input		[31:0]	i_proc_instr_addr,
	input					i_instr_wren,
	input					i_instr_rden,
	
	output	[31:0]	o_proc_instr_out,
	
	
	input		[31:0]	i_proc_data_in,
	input		[31:0]	i_proc_data_addr,
	input					i_data_wren,
	input					i_data_rden,
	
	output	[31:0]	o_proc_data_out,
	
	// IO Bus
	input		[31:0]	i_IO_data_in,
	
	output				o_IO_data_wren,
	output				o_IO_data_rden,
	output	[31:0]	o_IO_data_addr,
	output	[31:0]	o_IO_data_out,
	
	// Data Memory Bus
	input		[31:0]	i_mem_data_in,
	
	output				o_mem_data_wren,
	output				o_mem_data_rden,
	output	[31:0]	o_mem_data_addr,
	output	[31:0]	o_mem_data_out,
	
	// Instr Memory Bus
	
	input		[31:0]	i_mem_instr_in,
	
	output				o_mem_instr_wren,
	output				o_mem_instr_rden,
	output	[31:0]	o_mem_instr_addr,
	output	[31:0]	o_mem_instr_out,
	
	// Instr Load Bus
	
	input		[31:0]	i_ld_instr_in,
	input		[31:0]	i_ld_instr_addr,
	input					i_ld_instr_wren,
	input					i_ld_instr_active,
	
	// Instr Read Bus
	
	input		[31:0]	i_rd_instr_in,
	
	output				o_rd_instr_wren,
	output				o_rd_instr_rden,
	output	[31:0]	o_rd_instr_addr,
	output	[31:0]	o_rd_instr_out
	
	
);

	parameter instrStart = 0;
	parameter dataStart = instrStart + instr_mem_size;
	parameter IOStart = dataStart + data_mem_size;

	parameter s_PROC = 3'b000;
	parameter s_LD_INSTR = 3'b001;
	parameter s_CLEANUP = 3'b010;
	
	
	reg [2:0] 	r_SM_MAIN;
	reg			r_MEM_WAIT;
	reg			r_RESET;
	
	always @(posedge clk or posedge reset)
		begin
			if (reset)
				begin
					r_RESET	<= 0;
					r_MEM_WAIT <= 0;
					r_SM_MAIN <= s_PROC;
				end
			else
				begin
					case (r_SM_MAIN)
						s_PROC:
							begin
								if (i_ld_instr_active)
									begin
										r_MEM_WAIT 	<= 1;
										r_SM_MAIN 	<= s_LD_INSTR;
									end
							end
						s_LD_INSTR:
							begin
								if (!i_ld_instr_active)
									begin
										r_RESET 		<= 1;
										r_SM_MAIN	<= s_CLEANUP;
									end
							end
						s_CLEANUP:
							begin
								r_RESET	<= 0;
								r_MEM_WAIT <= 0;
								r_SM_MAIN <= s_PROC;
							end
						default:
							r_SM_MAIN <= s_PROC;
						endcase
				end
		end
		
	wire isPROCMODE = (r_SM_MAIN == 3'b000);
	wire isLDMODE = (r_SM_MAIN == 3'b001);
	wire isCLNMODE = (r_SM_MAIN == 3'b010);
	
	
	//fix this
	wire isInstrMem = (i_proc_data_addr >= 0 && i_proc_data_addr <= dataStart-1);
	wire isDataMem = (i_proc_data_addr >= dataStart && i_proc_data_addr <= IOStart-1);
	wire isIO = (i_proc_data_addr >= IOStart && i_proc_data_addr <= IOStart+io_data_size-1);

	wire	[31:0]	addr = 	isInstrMem 	?	i_proc_data_addr		:
								  (isDataMem	?	i_proc_data_addr-dataStart	:
								  (isIO			?	i_proc_data_addr-IOStart	:
														32'b0
														));
	
	assign o_IO_data_addr = isIO ? addr : 32'b0;
	assign o_IO_data_out = isIO ? i_proc_data_in : 32'b0;
	assign o_IO_data_wren = isIO ? i_data_wren : 1'b0;
	assign o_IO_data_rden = isIO ? i_data_rden : 1'b0;

	assign o_mem_data_addr = isDataMem ? addr : 32'b0;
	assign o_mem_data_out = isDataMem ? i_proc_data_in : 32'b0;
	assign o_mem_data_wren = isDataMem ? i_data_wren : 1'b0;
	assign o_mem_data_rden = isDataMem ? i_data_rden : 1'b0;

	assign o_mem_instr_addr = isInstrMem ? addr : 32'b0;
	assign o_mem_instr_out = isInstrMem ? i_proc_data_in : 32'b0;
	assign o_mem_instr_wren = isInstrMem ? i_data_wren : 1'b0;
	assign o_mem_instr_rden = isInstrMem ? i_data_rden : 1'b0;

	assign o_proc_data_out =	isInstrMem	?	i_mem_instr_in		:
									  (isDataMem	?	i_mem_data_in		:
									  (isIO			?	i_IO_data_in		:
															32'b0
															));
	
	assign o_reset_out = (isLDMODE || isCLNMODE) ? r_RESET : reset;
	assign o_mem_wait = r_MEM_WAIT;
	
	assign o_proc_instr_out = i_rd_instr_in;
	
	assign o_rd_instr_wren = isPROCMODE ? 	i_instr_wren		:
									(isLDMODE	? 	i_ld_instr_wren	:
														i_instr_wren);
														
	assign o_rd_instr_rden = isPROCMODE ? 	i_instr_rden		:
									(isLDMODE	? 	1'b0					:
														i_instr_rden);
														
	assign o_rd_instr_addr = isPROCMODE ? 	i_proc_instr_addr	:
									(isLDMODE	? 	i_ld_instr_addr	:
														i_proc_instr_addr);
														
	assign o_rd_instr_out  = isPROCMODE ? 	i_proc_instr_in	:
									(isLDMODE	? 	i_ld_instr_in		:
														i_proc_instr_in);
	

endmodule 