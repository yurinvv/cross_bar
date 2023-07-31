module cross_bar#(
	parameter AWIDTH = 32, // Public
	parameter DWIDTH = 32  // Public
)(
	input                aclk,
	input                aresetn,
	//For sim
	//cross_bar_if.slave   s[1:0],
	//cross_bar_if.master  m[1:0]

	input  s00_req    ,
	input  s00_addr   ,
	input  s00_cmd    ,
	input  s00_wdata  ,
	output s00_ack    ,
	output s00_rdata  ,
	output s00_resp   ,

	input  s01_req    ,
	input  s01_addr   ,
	input  s01_cmd    ,
	input  s01_wdata  ,
	output s01_ack    ,
	output s01_rdata  ,
	output s01_resp   ,

	output m00_req    ,
	output m00_addr   ,
	output m00_cmd    ,
	output m00_wdata  ,
	input  m00_ack    ,
	input  m00_rdata  ,
	input  m00_resp	  ,
					  
	output m01_req    ,
	output m01_addr   ,
	output m01_cmd    ,
	output m01_wdata  ,
	input  m01_ack    ,
	input  m01_rdata  ,
	input  m01_resp   
);
	
	localparam MATSER_NUM = 2; // Private
	
	cross_bar_if   s[$clog2(MATSER_NUM) - 1:0]();
	cross_bar_if   m[$clog2(MATSER_NUM) - 1:0]();
	
	
	rd_req_if#(AWIDTH, MATSER_NUM)           handle_rd_req_bus [$clog2(MATSER_NUM) - 1 : 0]();
	rd_req_if#(AWIDTH, MATSER_NUM)           arbiter_rd_req_bus0 [$clog2(MATSER_NUM) - 1 : 0]();
	rd_req_if#(AWIDTH, MATSER_NUM)           arbiter_rd_req_bus1 [$clog2(MATSER_NUM) - 1 : 0]();
	wr_req_if#(AWIDTH, DWIDTH, MATSER_NUM)   handle_wr_req_bus [$clog2(MATSER_NUM) - 1 : 0]();
	wr_req_if#(AWIDTH, DWIDTH, MATSER_NUM)   arbiter_wr_req_bus0 [$clog2(MATSER_NUM) - 1 : 0]();
	wr_req_if#(AWIDTH, DWIDTH, MATSER_NUM)   arbiter_wr_req_bus1 [$clog2(MATSER_NUM) - 1 : 0]();
	rd_if#(DWIDTH)                           resp0_bus [$clog2(MATSER_NUM) - 1 : 0]();
	rd_if#(DWIDTH)                           resp1_bus [$clog2(MATSER_NUM) - 1 : 0]();
	
	/**********************************************
	* Port Handlers
	 
	*/
	generate
		for (genvar i = 0; i < MATSER_NUM; i++)
			begin
			port_handler#(
				.AWIDTH     ( AWIDTH     ),
				.DWIDTH     ( DWIDTH     ),
				.MATSER_NUM ( MATSER_NUM )
			) port_handler_inst (
				.aclk        ( aclk                 ),
				.aresetn     ( aresetn              ),
				.base_port   ( s[i]                 ),
				.rd_req_port ( handle_rd_req_bus[i] ),
				.wr_req_port ( handle_wr_req_bus[i] ),
				.rd_port0    ( resp0_bus[i]         ),
				.rd_port1    ( resp1_bus[i]         )
			);
			
			rd_req_switch
			rd_req_switch0 (
				.s0_rd_req_port(handle_rd_req_bus[i]  ),
				.m0_rd_req_port(arbiter_rd_req_bus0[i]),
				.m1_rd_req_port(arbiter_rd_req_bus1[i])
			);
			
			wr_req_switch
			wr_req_switch0 (
				.i_wr_req_port0 (handle_wr_req_bus[i]  ),
				.o_wr_req_port0 (arbiter_wr_req_bus0[i]),
				.o_wr_req_port1 (arbiter_wr_req_bus1[i])
			);
			end
	endgenerate
	
	
	/**********************************************
	* Arbiter 0
	*/
	arbiter#(
		.AWIDTH     ( AWIDTH     ),
		.DWIDTH     ( DWIDTH     ),
		.MATSER_NUM ( MATSER_NUM ),
		.ID         ( 0          )
	) arbiter0 (
		.aclk        ( aclk                ),
		.aresetn     ( aresetn             ),
		.m_base      ( m[0]                ),
		.rd_req_port ( arbiter_rd_req_bus0 ),
		.wr_req_port ( arbiter_wr_req_bus0 ),
		.resp_port0  ( resp0_bus[0]        ),
		.resp_port1  ( resp1_bus[1]        )
	);
	
	
	/**********************************************
	* Arbiter 1
	*/
	arbiter#(
		.AWIDTH     ( AWIDTH     ),
		.DWIDTH     ( DWIDTH     ),
		.MATSER_NUM ( MATSER_NUM ),
		.ID         ( 1          )
	) arbiter1 (
		.aclk        ( aclk                ),
		.aresetn     ( aresetn             ),
		.m_base      ( m[1]                ),
		.rd_req_port ( arbiter_rd_req_bus1 ),
		.wr_req_port ( arbiter_wr_req_bus1 ),
		.resp_port0  ( resp1_bus[0]        ),
		.resp_port1  ( resp0_bus[1]        )
	);
	
	
	/**************************************************
	*   ASSIGNMENTS
	*/
	
	input  s00_req    ,
	input  s00_addr   ,
	input  s00_cmd    ,
	input  s00_wdata  ,
	assign s00_ack    ,
	assign s00_rdata  ,
	assign s00_resp   ,

	input  s01_req    ,
	input  s01_addr   ,
	input  s01_cmd    ,
	input  s01_wdata  ,
	assign s01_ack    ,
	assign s01_rdata  ,
	assign s01_resp   ,

	output m00_req    ,
	output m00_addr   ,
	output m00_cmd    ,
	output m00_wdata  ,
	input  m00_ack    ,
	input  m00_rdata  ,
	input  m00_resp	  ,
					  
	output m01_req    ,
	output m01_addr   ,
	output m01_cmd    ,
	output m01_wdata  ,
	input  m01_ack    ,
	input  m01_rdata  ,
	input  m01_resp   
		
endmodule