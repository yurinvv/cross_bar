//////////////////////////////////////////////////////////////////////////////////
// Module Name: Arbiter Controller
// Project Name: Cross Bar
// Description: This module directly controls and arbitrates transactions in the
// arbiter module
//////////////////////////////////////////////////////////////////////////////////
module arbiter_controller#(
	parameter MATSER_NUM = 2
)(
	input aclk,
	input aresetn,

	cross_bar_if.master  m_base,
		
	rd_req_if.slave      rd_req_port [MATSER_NUM - 1 : 0],
	wr_req_if.in         wr_req_port [MATSER_NUM - 1 : 0],
	rd_if.out            resp_port0,
	rd_if.out            resp_port1
);
	
	localparam READ_OPP = 0;
	localparam WRITE_OPP = 1;
	
	wire any_requests = | {rd_req_port[0].req, 
                           wr_req_port[0].req,
                           rd_req_port[1].req,
                           wr_req_port[1].req};
	
	
	/**********************
	* FSM
	*/
	
	typedef enum {
		IDLE,
		DETECT_REQ,
		// Slave0 handling
		CHECK_SLAVE0,
		SET_WR_REQ0,
		SET_RD_REQ0,
		WAIT_ACK0,
		RETURN_RESP0,
		// Slave1 handling
		CHECK_SLAVE1,
		SET_WR_REQ1,
		SET_RD_REQ1,
		WAIT_ACK1,
		RETURN_RESP1
		
	} state_e;
	
	state_e state, next;
	
	always_ff@(posedge aclk)
		if (!aresetn) begin
			state <= IDLE;
		end else begin
			state <= next;
		end
		
	always_comb begin
		next = state;
		case(state)
		IDLE:
			next = DETECT_REQ;
			
		DETECT_REQ:
			if (any_requests)
				next = CHECK_SLAVE0;
				
		// Slave0 handling		
		CHECK_SLAVE0:
			if (wr_req_port[0].req)
				next = SET_WR_REQ0;
			else if (rd_req_port[0].req)
				next = SET_RD_REQ0;
			else
				next = CHECK_SLAVE1;
				
		SET_WR_REQ0, SET_RD_REQ0:
			next = WAIT_ACK0;	

		WAIT_ACK0:
			if (m_base.ack) begin
				if (m_base.cmd)
					//next = DETECT_REQ;
					next = CHECK_SLAVE1;
				else
					next = RETURN_RESP0; 
			end
				
		RETURN_RESP0:
			if (m_base.resp)
				next = CHECK_SLAVE1;			
		
		// Slave1 handling
		CHECK_SLAVE1:
			if (wr_req_port[1].req)
				next = SET_WR_REQ1;
			else if (rd_req_port[1].req)
				next = SET_RD_REQ1;
			else
				next = DETECT_REQ;		

		SET_WR_REQ1, SET_RD_REQ1:
			next = WAIT_ACK1;
			
		WAIT_ACK1:
			if (m_base.ack) begin
				if (m_base.cmd)
					next = DETECT_REQ;
				else
					next = RETURN_RESP0; 
			end
				
		RETURN_RESP1:
			if (m_base.resp)
				next = DETECT_REQ;				
			
		endcase
	end
	
	/////////////////////////////
	// State Implementations
		

	// REQ control
	always_ff@(posedge aclk)
		if (!aresetn) begin
			m_base.req <= 0;
		end else 
			case (state)
			SET_WR_REQ0, SET_WR_REQ1,
			SET_RD_REQ0, SET_RD_REQ1:
			
				m_base.req <= 1;
			default:
				if (m_base.ack)
					m_base.req <= 0;
			endcase
	
	// ADDR control
	always_ff@(posedge aclk)
		if (!aresetn | m_base.ack) begin
			m_base.addr <= '0;
		end else 
			case (state)
			SET_WR_REQ0:
				m_base.addr <= wr_req_port[0].addr;
				
			SET_WR_REQ1:
				m_base.addr <= wr_req_port[1].addr;
				
			SET_RD_REQ0:
				m_base.addr <= rd_req_port[0].addr;

			SET_RD_REQ1:
				m_base.addr <= rd_req_port[1].addr;	
			endcase
			

	// CMD and WDATA control
	always_ff@(posedge aclk)
		if (!aresetn | m_base.ack) begin
			m_base.cmd   <= '0;
			m_base.wdata <= '0;
		end else 
			case (state)
			SET_WR_REQ0:
				begin
				m_base.cmd   <= WRITE_OPP;
				m_base.wdata <= wr_req_port[0].wdata;
				end
			SET_WR_REQ1:
				begin
				m_base.cmd   <= WRITE_OPP;
				m_base.wdata <= wr_req_port[1].wdata;
				end
			endcase
	
	/*******************************************************
	* RD Port 0 control
	*/
	
	
	// RD0.RDATA and RD0.RESP control
	always_ff@(posedge aclk)
		if (!aresetn & state != RETURN_RESP0) begin
			resp_port0.rdata <= '0;
			resp_port0.resp  <= 0;
		end else begin
			resp_port0.rdata <= m_base.rdata;
			resp_port0.resp  <= m_base.resp;
		end
			
			
	// RD0.ACK control
	always_ff@(posedge aclk)
		if (!aresetn) begin
			resp_port0.ack <= 0;
		end else if (state == WAIT_ACK0)
			resp_port0.ack <= m_base.ack;
		else
			resp_port0.ack <= 0;
			
			
	/*****************************************************
	* RD Port 1 control
	*/
	
	// RD1.RDATA and RD1.RESP control
	always_ff@(posedge aclk)
		if (!aresetn & state != RETURN_RESP1) begin
			resp_port1.rdata <= '0;
			resp_port1.resp  <= 0;
		end else begin
			resp_port1.rdata <= m_base.rdata;
			resp_port1.resp  <= m_base.resp;
		end
			
			
	// RD1.ACK control
	always_ff@(posedge aclk)
		if (!aresetn) begin
			resp_port1.ack <= 0;
		end else if (state == WAIT_ACK1)
			resp_port1.ack <= m_base.ack;
		else	
			resp_port1.ack <= 0;
			
	/*******************************************************
	* FIFO control
	*/	
	
	// Read FIFO 0
	always_ff@(posedge aclk)
		if (!aresetn | state != SET_RD_REQ0)
			rd_req_port[0].rd_en <= 0;
		else 
			rd_req_port[0].rd_en <= 1;
			
	// Read FIFO 1
	always_ff@(posedge aclk)
		if (!aresetn | state != SET_RD_REQ1)
			rd_req_port[1].rd_en <= 0;
		else 
			rd_req_port[1].rd_en <= 1;		
				
	
endmodule