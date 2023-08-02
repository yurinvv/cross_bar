module fifo #(
	parameter DWIDTH = 32
)(
	input                     aclk,
	input                     aresetn,
	input                     pop,
	input                     push,
	input        [DWIDTH-1:0] push_data,
	output logic [DWIDTH-1:0] pop_data,
	output logic              full,
	output logic              not_empty
  );
  
	localparam FIFO_DEPTH = 4;
	localparam PTR_MSB    = $clog2(FIFO_DEPTH);
	localparam ADDR_MSB   = $clog2(FIFO_DEPTH) - 1;
	
	(* RAM_STYLE="BLOCK"*)
	reg [DWIDTH-1:0] memory [0:FIFO_DEPTH-1];
	logic [ PTR_MSB:0] readPtr, writePtr;
	wire  [ADDR_MSB:0] writeAddr = writePtr[ADDR_MSB:0];
	wire  [ADDR_MSB:0] readAddr = readPtr[ADDR_MSB:0]; 
  
	always_ff@(posedge aclk)
		if(!aresetn)begin
			readPtr     <= '0;
			writePtr    <= '0;
		end else begin
		
			if (push && ~full)begin
				memory[writeAddr] <= push_data;
				writePtr         <= writePtr + 1;
			end
			
			if(pop && not_empty)begin
				pop_data <= memory[readAddr];
				readPtr <= readPtr + 1;
			end
			
		end
  
    assign not_empty = (writePtr == readPtr) ? 1'b0: 1'b1;
    assign full  = ((writePtr[ADDR_MSB:0] == readPtr[ADDR_MSB:0])&(writePtr[PTR_MSB] != readPtr[PTR_MSB])) ? 1'b1 : 1'b0;

endmodule
















