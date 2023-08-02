module fifo #(
	parameter DWIDTH = 32
)(
	input  aclk,
	input  aresetn,
	input  [DWIDTH - 1 : 0] push_data,
	output logic[DWIDTH - 1 : 0] pop_data, // pick read availble
	input  push,
	input  pop, // next
	output not_empty,
	output full
);

	localparam DEPTH  = 4;
	
	(* RAM_STYLE="BLOCK"*)
	reg [DWIDTH - 1 : 0] mem [DEPTH - 1 : 0];
	
	logic [$clog2(DEPTH) - 1 : 0] wr_pointer;
	logic [$clog2(DEPTH) - 1 : 0] rd_pointer;
	
	logic [$clog2(DEPTH) : 0] counter;
		
	// Write pointer control
	always_ff @(posedge aclk)
		if (!aresetn) begin
			wr_pointer <= 0;
		end else if (push & ~full) begin
			wr_pointer <= wr_pointer + 1;
		end
	
	// Read pointer control	
	always_ff @(posedge aclk)
		if (!aresetn) begin
			rd_pointer <= 0;
		end else if (pop & not_empty) begin
			rd_pointer <= rd_pointer + 1;
		end
		
		
	////////////////////////////////////
	// State of fifo control
	
	wire [1:0] state = '{push, pop};
	
	always_ff @(posedge aclk)
		if (!aresetn) begin
			counter <= 0;
		end else begin
			case (state)
			2'b10:
				if (~full)
					counter <= counter + 1;
			2'b01:
				if (|counter)
					counter <= counter - 1;
			endcase
		end
	
	assign not_empty = | counter;
	assign full = counter[$clog2(DEPTH)];
	
	///////////////////////////////////////
	// Data access
	
	always_ff @(posedge aclk)
		if (!aresetn)
			pop_data <= 0;
		else
			pop_data <= mem[rd_pointer];
			
	always_ff @(posedge aclk)
		if (push & ~full)
			mem[wr_pointer] <= push_data; 
			
endmodule


















