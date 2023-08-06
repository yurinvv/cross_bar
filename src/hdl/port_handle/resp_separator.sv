// Just to combine counters. 
// The contents of this module can be moved to the arbiter
module resp_separator#(
	parameter MATSER_NUM = 2
)(
	input aclk,
	input aresetn,
	
	input rd_req,     // some_reg = req & !cmd & ack
	input master_sel, // addr [AWIDTH - 1]
	input [MATSER_NUM - 1 : 0] resp,
	
	output [MATSER_NUM - 1:0] resp_en
);
	
	localparam CNT_WIDTH = 8;

	logic [CNT_WIDTH - 1 : 0] counter_bus [MATSER_NUM - 1 : 0];
	

	generate
		for (genvar i = 0; i < MATSER_NUM; i++)
			rd_req_counter#(
				.MASTER_ID(i),
				.CNT_WIDTH(CNT_WIDTH)
			)rd_req_counter_inst(
				.aclk       (aclk       ),
				.aresetn    (aresetn    ),
				
				.rd_req     (rd_req     ),
				.master_sel (master_sel ), 
				.resp       (resp[i]    ),
				.resp_en    (resp_en[i] )
			);
	endgenerate
	

endmodule