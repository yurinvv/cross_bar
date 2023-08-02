module port_handler#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32,
	parameter MATSER_NUM = 2
)(
	input aclk,
	input aresetn,
	
	cross_bar_if.slave  base_port,
	rd_req_if.master    rd_req_port,
	wr_req_if.out       wr_req_port,
	rd_if.in            rd_port0,
	rd_if.in            rd_port1
);

	rd_if#(DWIDTH) o_mux_rd_port(aclk);
	logic sel_mux;
	
	/******************************
	* Mux
	*/
	rd_mux
	rd_mux0(
		.sel        (sel_mux),
		.i_rd_port0 (rd_port0),
		.i_rd_port1 (rd_port1),
		.o_rd_port  (o_mux_rd_port)
	);
	
	/******************************
	* RD Req Controller
	*/
	rd_req_controller#(
		.AWIDTH(AWIDTH)
	) rd_req_controller0 (
		.aclk   (aclk   ),
		.aresetn(aresetn),
		
		//Slave signals
		.req         (base_port.req),
		.addr        (base_port.addr),
		.cmd         (base_port.cmd), //must be 1 for READ
		.rd_req_port (rd_req_port)
	);	
	
	/******************************
	* WR Req Controller
	*/
	wr_req_controller#(
		.AWIDTH(AWIDTH),
		.DWIDTH(DWIDTH)
	) wr_req_controller0 (
		.aclk        (aclk             ),
		.aresetn     (aresetn          ),
		.req         (base_port.req    ),
		.addr        (base_port.addr   ),
		.cmd         (base_port.cmd    ),
		.wdata       (base_port.wdata  ),
		.wr_req_port (wr_req_port      ),
		.ack         (o_mux_rd_port.ack)
	);

	/******************************
	* Answer Controller
	*/
	answer_controller#(
		.AWIDTH(AWIDTH),
		.DWIDTH(DWIDTH)
	) answer_controller0 (
		.aclk      (aclk    ),
		.aresetn   (aresetn ),

		.rd_port   (o_mux_rd_port         ),
		.req       (base_port.req         ),
		.fifo_full (rd_req_port.fifo_full ),
		.addr      (base_port.addr         ),
		.cmd       (base_port.cmd         ),
		.sel       (sel_mux               ),
		.ack       (base_port.ack         ),
		.rdata     (base_port.rdata       ),
		.resp      (base_port.resp        )
	);
endmodule