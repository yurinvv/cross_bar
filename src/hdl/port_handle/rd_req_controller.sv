module rd_req_controller#(
	parameter AWIDTH = 32
)(
	input aclk,
	input aresetn,
	
	//Slave signals
	input req,
	input [AWIDTH - 1 : 0] addr,
	input cmd, //must be 0 for READ
	rd_req_if.master    rd_req_port
);	

	localparam DELAY_MAX = 3;
	logic [$clog2(DELAY_MAX) : 0] timer;
	
	logic fifo_full_reg;
	
	///////////////////////////////////
	// FSM
	
	typedef enum {
		IDLE,
		WAIT_REQ_HIGH,
		WAIT_FIFO_STATUS,
		WRITE_REQ,
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
			if (req & !cmd)
				next = WAIT_FIFO_STATUS;
				
		WAIT_FIFO_STATUS:
			if (timer == DELAY_MAX)
				next = WRITE_REQ;
				
		WRITE_REQ:
			if (!fifo_full_reg)
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
		end else begin
			case (state)
			WAIT_REQ_HIGH:
				rd_req_port.addr  <= addr;
			endcase
		end
		
	always_ff@(posedge aclk)
		if (!aresetn | cmd) begin
			rd_req_port.wren  <= '0;
		end else begin
			case (state)
			WRITE_REQ:
				if (!fifo_full_reg) begin
					rd_req_port.wren[0] <= !addr[AWIDTH - 1]; //Master 0
					rd_req_port.wren[1] <= addr[AWIDTH - 1];  //Master 1
				end
			default:
				begin
				rd_req_port.wren  <= '0;
				end
			endcase
		end
		
	/////////////////////////////////
	// Timer control
	
	always_ff@(posedge aclk)
		if (!aresetn | state != WAIT_FIFO_STATUS) begin
			timer <= '0;
		end else begin
			timer <= timer + 1;
		end
		
	///////////////////////////////
	// Reg fifo full

	always_ff@(posedge aclk)
		if (!aresetn) begin
			fifo_full_reg <= '0;
		end else begin
			fifo_full_reg <= rd_req_port.fifo_full;
		end	
	
endmodule