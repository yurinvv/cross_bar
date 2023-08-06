//////////////////////////////////////////////////////////////////////////////////
// Module Name: Ack Controller
// Project Name: Cross Bar
// Description: This module controls the ack signal.
// When a read request comes in, the controller generates a ack signal if the FIFO
// is not full.
// When a write request comes in, the controller send a ack signal from the base 
// interface master port to slave port.
//////////////////////////////////////////////////////////////////////////////////
module ack_controller#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32
)(
	input aclk,
	input aresetn,

	input rd_ack,
	input req,
	input fifo_full,
	input cmd,
	
	output logic ack
);
	
	localparam RD_OPP = 0,
               WR_OPP = 1;
	
	localparam DELAY_MAX = 3;
	logic [$clog2(DELAY_MAX) : 0] timer;
	
	logic fifo_full_reg;
		
	///////////////////////////////////
	// FSM
	
	typedef enum {
		IDLE,
		WAIT_REQ_HIGH,
		WAIT_FIFO_STATUS,
		WAIT_AND_SET_ACK,
		SET_ACK,
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
			if (req) begin
				if (cmd) // WR_OPP
					next = WAIT_AND_SET_ACK;
				else     // RD_OPP
					next = WAIT_FIFO_STATUS;
			end
			
		WAIT_AND_SET_ACK:
			if (rd_ack)
				next = WAIT_REQ_LOW;
				
		WAIT_REQ_LOW:
			if (!req)
				next = WAIT_REQ_HIGH;
		
		WAIT_FIFO_STATUS:
			if (timer == DELAY_MAX)
				next = SET_ACK;
		
		SET_ACK:
			if (!fifo_full_reg)
				next = WAIT_REQ_LOW;
		
				
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

	/////////////////////////////////
	// ACK control		
	always_ff@(posedge aclk)
		if (!aresetn) begin
			ack <= 0;
		end else begin
			case (state)
			SET_ACK:
				ack <= ~fifo_full_reg;
			WAIT_AND_SET_ACK:
				ack <= rd_ack;
			default:
				ack <= 0;
			endcase
		end

		
	///////////////////////////////
	// Reg fifo full

	always_ff@(posedge aclk)
		if (!aresetn) begin
			fifo_full_reg <= '0;
		end else begin
			fifo_full_reg <= fifo_full;
		end	
		
endmodule