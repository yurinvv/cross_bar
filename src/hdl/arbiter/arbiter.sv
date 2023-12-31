//////////////////////////////////////////////////////////////////////////////////
// Module Name: Arbiter
// Project Name: Cross Bar
// Description: This module is used to arbitrate request transactions from slave ports to 
// the master port according to the Round-Robin algorithm
//////////////////////////////////////////////////////////////////////////////////
module arbiter#(
	parameter AWIDTH     = 32, // Public
	parameter DWIDTH     = 32,  // Public
	parameter MATSER_NUM = 2,
	parameter ID         = 0
)(
	input                aclk,
	input                aresetn,
	
	cross_bar_if.master  m_base,
	
	rd_req_if.slave      rd_req_port [MATSER_NUM - 1 : 0],
	wr_req_if.in         wr_req_port [MATSER_NUM - 1 : 0],
	rd_if.out            resp_port0,
	rd_if.out            resp_port1
);
		
	rd_req_if#(AWIDTH, MATSER_NUM) rd_req_bus [MATSER_NUM - 1 : 0](aclk);
	
	wire [MATSER_NUM - 1:0] push;
	
	assign push[0] = rd_req_port[0].wren[ID] ;
	assign push[1] = rd_req_port[1].wren[ID] ;
	
	
	// Fifo bufers for Read transactions
	generate
		for (genvar i = 0; i < MATSER_NUM; i++)
			fifo #(
				.DWIDTH(AWIDTH)
			) fifo_inst (
				.aclk      ( aclk                     ),
				.aresetn   ( aresetn                  ),
				.push_data ( rd_req_port[i].addr      ),
				.pop_data  ( rd_req_bus[i].addr       ),
				.push      ( push[i]                  ),
				.pop       ( rd_req_bus[i].rd_en      ),
				.not_empty ( rd_req_bus[i].req        ),
				.full      ( rd_req_port[i].fifo_full )
			);
	endgenerate
	
	
	arbiter_controller#(
		.MATSER_NUM(MATSER_NUM)
	) arb_ctrl (
		.aclk         ( aclk       ),
		.aresetn      ( aresetn    ),	
		               
		.m_base       ( m_base     ),
		
		.rd_req_port  (rd_req_bus  ),
		.wr_req_port  (wr_req_port ),
		.resp_port0   (resp_port0    ),
		.resp_port1   (resp_port1    )
	);	
	
endmodule