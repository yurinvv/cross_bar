//////////////////////////////////////////////////////////////////////////////////
// Module Name: Separate Arbiter
// Project Name: Cross Bar
// Description: This module is used to arbitrate responce transactions from master ports to 
// the slave port according to the Round- Robin algorithm
//////////////////////////////////////////////////////////////////////////////////
module resp_arbiter#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32,
	parameter MATSER_NUM = 2
)(
	input aclk,
	input aresetn,
	
	input     req,
	input     cmd,
	input     master_sel,  // addr [AWIDTH - 1]
	input     ack,
	
	rd_if.out rd_port_out,
	
	rd_if.in  rd_port0,
	rd_if.in  rd_port1
);
	localparam REQ_COUNTER_WIDTH = 8;
	localparam QUEUE_RESP_SIZE = 2;
	
	logic [MATSER_NUM - 1:0] push_en;
	
	logic [DWIDTH - 1:0] rdata [MATSER_NUM - 1 : 0];
	logic [MATSER_NUM - 1:0] pop;
	logic [MATSER_NUM - 1:0] fifo_not_empty ;
	
	logic                resp_queue0 [QUEUE_RESP_SIZE - 1:0];
	logic [DWIDTH - 1:0] rdata_queue0 [QUEUE_RESP_SIZE - 1:0];
	
	logic                resp_queue1 [QUEUE_RESP_SIZE - 1:0];
	logic [DWIDTH - 1:0] rdata_queue1 [QUEUE_RESP_SIZE - 1:0];
	
	logic  [MATSER_NUM-1:0] respToSep;
	
	assign respToSep[0] = resp_queue0[QUEUE_RESP_SIZE - 1];
	assign respToSep[1] = resp_queue1[QUEUE_RESP_SIZE - 1];
	
	logic rd_req_complete;
	
	wire any_resp = | fifo_not_empty;

	resp_separator#(
		.MATSER_NUM(MATSER_NUM)
	) resp_separator0(
		.aclk       (aclk            ),
		.aresetn    (aresetn         ),
		.rd_req     (rd_req_complete ),
		.master_sel (master_sel      ),
		.resp       (respToSep       ),
		.resp_en    (push_en         )
	);	
	
	wire push_fifo0 = resp_queue0[QUEUE_RESP_SIZE - 1] & push_en[0];
	
	fifo #(
		.DWIDTH(AWIDTH)
	) fifo_0 (
		.aclk      ( aclk              ),
		.aresetn   ( aresetn           ),
		.push_data ( rdata_queue0[QUEUE_RESP_SIZE - 1]),
		.pop_data  ( rdata[0]          ),
		.push      ( push_fifo0        ),
		.pop       ( pop[0]            ),
		.not_empty ( fifo_not_empty[0] ),
		.full      ()
	);

	wire push_fifo1 = resp_queue1[QUEUE_RESP_SIZE - 1] & push_en[1];

	fifo #(
		.DWIDTH(AWIDTH)
	) fifo_1 (
		.aclk      ( aclk              ),
		.aresetn   ( aresetn           ),
		.push_data ( rdata_queue1[QUEUE_RESP_SIZE - 1]),
		.pop_data  ( rdata[1]          ),
		.push      ( push_fifo1        ),
		.pop       ( pop[1]            ),
		.not_empty ( fifo_not_empty[1] ),
		.full      ()
	);

	///////////////////////////////////
	// RD Request counter for Master 0

	///////////////////////////////////
	// FSM
	
	typedef enum {
		IDLE,
		DETECT_RESP,
		// FIFO0 handling
		CHECK_FIFO0,
		RETURN_RESP0,
		// FIFO1 handling
		CHECK_FIFO1,
		RETURN_RESP1
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
			next = DETECT_RESP;
		DETECT_RESP:
			if (any_resp)
				next = CHECK_FIFO0;
		// FIFO0 handling
		CHECK_FIFO0:
			if (fifo_not_empty[0])
				next = RETURN_RESP0;
			else
				next = CHECK_FIFO1;
		RETURN_RESP0:
			next = CHECK_FIFO1;
		// FIFO1 handling
		CHECK_FIFO1:
			if (fifo_not_empty[1])
				next = RETURN_RESP1;
			else
				next = DETECT_RESP;
		RETURN_RESP1:
			next = DETECT_RESP;	
		endcase
	end
	
	
	//////////////////////////////
	// Resp Control
	
	always_ff@(posedge aclk)
		if (!aresetn) begin
			rd_port_out.resp <= 0;
			rd_port_out.rdata <= '0;
			pop <= '0;
		end else 
			case (state)
			RETURN_RESP0:
				begin
				rd_port_out.resp <= 1;
				rd_port_out.rdata <= rdata[0];
				pop[0] <= 1;
				end
			RETURN_RESP1:
				begin
				rd_port_out.resp <= 1;
				rd_port_out.rdata <= rdata[1];
				pop[1] <= 1;
				end
			default:
				begin
				pop <= '0;
				rd_port_out.resp <= 0;
				rd_port_out.rdata <= '0;
				end
			endcase
	
	
	///////////////////////////
	// rd_req_complete
	wire rd_req_complete_en = (req & ack) & !cmd;
	
	always_ff@(posedge aclk)
		if (!aresetn | !rd_req_complete_en)
			rd_req_complete <= 0;
		else 
			rd_req_complete <= 1;
			
			
	/////////////////////////////
	// Queue 0 Control
	
	always_ff@(posedge aclk)
		if (!aresetn) begin
			for (int i = 0; i < QUEUE_RESP_SIZE; i++) begin
				resp_queue0[i] <= '0;
				rdata_queue0[i] <= '0;
			end
		end else begin
		
			resp_queue0[0]  <= rd_port0.resp; 
			rdata_queue0[0] <= rd_port0.rdata;				
		
			for (int i = 1; i < QUEUE_RESP_SIZE; i++) begin				
				resp_queue0[i] <= resp_queue0[i-1];
				rdata_queue0[i] <= rdata_queue0[i-1];
			end
		end
	
	/////////////////////////////
	// Queue 1 Control
	
	always_ff@(posedge aclk)
		if (!aresetn) begin
			for (int i = 0; i < QUEUE_RESP_SIZE; i++) begin
				resp_queue1[i] <= '0;
				rdata_queue1[i] <= '0;
			end
		end else begin
		
			resp_queue1[0]  <= rd_port1.resp; 
			rdata_queue1[0] <= rd_port1.rdata;				
		
			for (int i = 1; i < QUEUE_RESP_SIZE; i++) begin				
				resp_queue1[i] <= resp_queue1[i-1];
				rdata_queue1[i] <= rdata_queue1[i-1];
			end
		end	

endmodule