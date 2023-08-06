//////////////////////////////////////////////////////////////////////////////////
// Module Name: Port Handler
// Project Name: Cross Bar
// Description: This module separates requests from the base interface into 
// separate interfaces, routes requests and responses between the slave port and
// two master ports
//////////////////////////////////////////////////////////////////////////////////
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
	
	rd_if#(DWIDTH)  resp_out(aclk);

	/******************************
	* Mux ack
	*/
	
	wire sel_mux = base_port.addr[AWIDTH - 1];
	logic rd_ack;
	
	localparam MASTER0 = 0,
		       MASTER1 = 1;
	
	always_comb
		case (sel_mux)
		MASTER0:
			rd_ack = rd_port0.ack;
		MASTER1:
			rd_ack = rd_port1.ack;
		endcase
	
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
		.ack         (rd_ack)
	);

	/******************************
	* ACK Controller
	*/
	ack_controller#(
		.AWIDTH(AWIDTH),
		.DWIDTH(DWIDTH)
	) ack_controller0 (
		.aclk      (aclk    ),
		.aresetn   (aresetn ),

		.rd_ack    (rd_ack         ),
		.req       (base_port.req         ),
		.fifo_full (rd_req_port.fifo_full ),
		.cmd       (base_port.cmd         ),
		.ack       (base_port.ack         )
	);
	
	/******************************
	* RESP Controller
	*/
	
	resp_arbiter#(
		.AWIDTH    (AWIDTH    ),
		.DWIDTH    (DWIDTH    ),
		.MATSER_NUM(MATSER_NUM)
	) resp_arbiter0 (
		.aclk      (aclk    ),
		.aresetn   (aresetn ),
		
		.req       (base_port.req),
		.cmd       (base_port.cmd),
		.master_sel(base_port.addr[AWIDTH - 1]),
		.ack       (base_port.ack),
		
		.rd_port_out (resp_out),
		.rd_port0    (rd_port0),
		.rd_port1    (rd_port1)
	);
	
	assign base_port.rdata = resp_out.rdata;
	assign base_port.resp = resp_out.resp;
endmodule