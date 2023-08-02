module rd_req_controller#(
	parameter AWIDTH = 32
)(
	input aclk,
	input aresetn,
	
	//Slave signals
	input req,
	input [AWIDTH - 1 : 0] addr,
	input cmd, //must be 1 for READ
	rd_req_if.master    rd_req_port
);	
	
	///////////////////////////////////
	// FSM
	
	typedef enum {
		IDLE,
		WAIT_REQ_HIGH,
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
			if (req)
				next = WAIT_REQ_LOW;
		WAIT_REQ_LOW:
			if (!req)
				next = WAIT_REQ_HIGH;
		endcase
	end
	
	///////////////////////////////
	// rd_req_port control
	
	assign rd_req_port.req = 0;
	
	always_ff@(posedge aclk)
		if (!aresetn | cmd) begin
			rd_req_port.addr  <= '0;
			rd_req_port.wren  <= '0;
		end else begin
			case (state)
			WAIT_REQ_HIGH:
				if (req) begin
					rd_req_port.addr  <= addr;
					rd_req_port.wren[0] <= !addr[AWIDTH - 1]; //Master 0
					rd_req_port.wren[1] <= addr[AWIDTH - 1];  //Master 1
				end
			default:
				begin
				rd_req_port.addr  <= '0;
				rd_req_port.wren  <= '0;
				end
			endcase
		end
	
endmodule













