//////////////////////////////////////////////////////////////////////////////////
// Module Name: Read Request Controller
// Project Name: Cross Bar
// Description: This module controls the transmission and routing of write requests
//////////////////////////////////////////////////////////////////////////////////
module wr_req_controller#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32
)(
	input aclk,
	input aresetn,
	
	input          req,
	input          cmd,
	input [AWIDTH - 1 : 0] addr,
	input [DWIDTH - 1 : 0] wdata,
	wr_req_if.out  wr_req_port,
	input          ack
);

	///////////////////////////////////
	// FSM
	
	typedef enum {
		IDLE,
		WAIT_REQ_HIGH,
		WAIT_ACK,
		WAIT_REQ_LOW
	} State_e;
	
	State_e state, next;
	
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
			next = WAIT_REQ_HIGH;
		WAIT_REQ_HIGH:
			if (req & cmd)
				next = WAIT_ACK;
		WAIT_ACK:
			if (ack)
				next = WAIT_REQ_LOW;
		WAIT_REQ_LOW:
			if (!req)
				next = WAIT_REQ_HIGH;
		endcase
	end

	///////////////////////////////
	// wr_req_controller control
	
	always_ff@(posedge aclk)
		if (!aresetn | !cmd) begin
			wr_req_port.sel   <= '0;
			wr_req_port.addr  <= '0;
			wr_req_port.wdata <= '0;
			wr_req_port.req   <= '0;
		end else begin
			case (state)
			WAIT_REQ_HIGH:
				if (req) begin
					wr_req_port.sel   <= addr[AWIDTH - 1];
					wr_req_port.addr  <= addr;
					wr_req_port.wdata <= wdata;
					wr_req_port.req   <= req;
				end
			default:
				if (ack) begin
					wr_req_port.sel   <= '0;
					wr_req_port.addr  <= '0;
					wr_req_port.wdata <= '0;
					wr_req_port.req   <= '0;
				end
			endcase
		end
	
endmodule
