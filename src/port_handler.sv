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

	
	localparam READ_OPP = 0;
	localparam WRITE_OPP = 1;
	
	localparam RD0 = 0;
	localparam RD1 = 1;
	
	logic ack_reg0;
	//logic ack_reg1; // This is base_port.ack
	
	logic resp_reg0;
	//logic resp_reg1; // This is base_port.resp
	
	logic rdata_reg0;
	//logic rdata_reg1; // This is base_port.rdata
	
	wire rd_port_select = base_port.addr[AWIDTH - 1];
	/******************************
	*  ACK Control
	*
	*/
	
	// ack_reg0 implementation	
	always_ff @(posedge aclk)
		if (!aresetn)
			ack_reg0 <= '0;
		else 
			// Ack Mux0 implementation
			case (rd_port_select)
			RD0:   
				ack_reg0 <= rd_port0.ack;
			RD1:
				ack_reg0 <= rd_port1.ack;
			endcase
	
	
	// ack_reg1 implementation
	always_ff @(posedge aclk)
		if (!aresetn | (rd_req_port.fifo_full & !base_port.cmd))
			base_port.ack <= '0;
		else 
			// Ack Mux1 implementation
			case (base_port.cmd)
			READ_OPP:   
				base_port.ack <= base_port.ack ^ base_port.cmd;
			WRITE_OPP:
				base_port.ack <= ack_reg0;
			endcase


	/******************************
	*  RD Req (rd_req_port) control. 
	*
	*/
	
	// REQ Reg0 and Decoder implementations
	always_ff @(posedge aclk)
		if (!aresetn | base_port.cmd != READ_OPP) begin
			rd_req_port.wren <= 0;
			rd_req_port.addr <= '0;
		end else begin
			rd_req_port.wren[0] <= !base_port.addr[AWIDTH - 1]; //Master 0
			rd_req_port.wren[1] <= base_port.addr[AWIDTH - 1];  //Master 1
			rd_req_port.addr <= base_port.addr;
		end
			
			
	/******************************
	*  WR Req (wr_req_port) control. 
	*
	*/
	
	// REQ Reg1 and Decoder implementations
	always_ff @(posedge aclk)
		if (!aresetn | base_port.cmd != WRITE_OPP) begin
			wr_req_port.sel   <= '0;
			wr_req_port.addr  <= '0;
			wr_req_port.wdata <= '0;
			wr_req_port.req   <= '0;
		end else begin
			wr_req_port.sel   <= base_port.addr[AWIDTH - 1 : AWIDTH - $clog2(MATSER_NUM)];
			wr_req_port.addr  <= base_port.addr;
			wr_req_port.wdata <= base_port.wdata;
			wr_req_port.req   <= base_port.req;
		end
		
		
	/******************************
	*  Resp and Rdata Control
	*
	*/
	
	// resp_reg1 and rdata_reg1 implementations
	always_ff @(posedge aclk)
		if (!aresetn) begin
			{resp_reg0, rdata_reg0}  <= '0;
		end else begin
			// Rd Mux implementation
			case (rd_port_select)
			RD0: 
				{resp_reg0, rdata_reg0} <= {rd_port0.resp, rd_port0.rdata};
			RD1:
				{resp_reg0, rdata_reg0} <= {rd_port1.resp, rd_port1.rdata};
			endcase
		end
	
	
	// resp_reg1 and rdata_reg1 implementations
	always_ff @(posedge aclk)
		if (!aresetn) begin
			{base_port.resp, base_port.rdata}  <= '0;
		end else begin
			{base_port.resp, base_port.rdata} <= {resp_reg0, rdata_reg0};
		end
		
endmodule