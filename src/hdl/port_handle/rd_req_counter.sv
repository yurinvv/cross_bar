//////////////////////////////////////////////////////////////////////////////////
// Module Name: Read Request Counter
// Project Name: Cross Bar
// Description: This counter is used to implement the functionality of enabling 
// and disabling of the reception of responses from two ports of the master.
// If the responses received from the master are less than the number of read 
// requests sent to this master from this slave port, then the transfer of 
// responses from the master to the slave is enabled. Otherwise, disabled
//////////////////////////////////////////////////////////////////////////////////
module rd_req_counter#(
	parameter MASTER_ID = 0,
	parameter CNT_WIDTH = 8
)(
	input aclk,
	input aresetn,
	
	input rd_req,     // req & !cmd & ack
	input master_sel, // addr [AWIDTH - 1]
	input resp,
	output logic resp_en

);
	
	localparam INCREMENT = 2'b01;
	localparam DECREMENT = 2'b10;
	
	wire [1:0] counter_ctrl = {resp, rd_req};
	
	logic [CNT_WIDTH - 1 : 0] counter_next;
	
	logic [CNT_WIDTH - 1 : 0] counter;
	
	wire en = MASTER_ID[0];
	
	logic select;
	
	always_comb begin
		case (counter_ctrl)
		INCREMENT:
				counter_next = counter + 1;
		DECREMENT:
			if (counter > 0)
				counter_next = counter - 1;
			else
				counter_next = counter;
		default:
			counter_next = counter;
		endcase
	end
	
	always_ff@(posedge aclk)
		if (!aresetn) begin
			counter <= '0;
		end else if (select) begin
			counter <= counter_next;
		end
		
	always_ff@(posedge aclk)
		if (!aresetn | counter == 0) begin
			resp_en <= '0;
		end else begin
			resp_en <= 1;
		end
		
	always_ff@(posedge aclk)
		if (!aresetn | master_sel != en)
			select = 0;
		else
			select = 1;
	
endmodule