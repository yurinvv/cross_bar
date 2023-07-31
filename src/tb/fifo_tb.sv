`timescale 1ns/1ns

module fifo_tb;

	localparam DWIDTH = 32;
	localparam CLOCK_PERIOD = 10;

	bit aclk;
	bit aresetn;
	
	bit [DWIDTH - 1 : 0] push_data;
	bit [DWIDTH - 1 : 0] pop_data;
	bit push;
	bit pop;
	bit empty;
	bit full;
	
	task init_dut_ports();
		push_data <= '0;
		push <= '0;
		pop <= '0;
	endtask

	// Dut
	fifo #(
		.DWIDTH(DWIDTH)
	) dut (
		.aclk      (aclk     ),
		.aresetn   (aresetn  ),
		.push_data (push_data),
		.pop_data  (pop_data ),
		.push      (push     ),
		.pop       (pop      ),
		.empty     (empty    ),
		.full      (full     )
	);
		
	/////////////////////////////////
	// Clock generation

	initial begin
		aclk = 0;
		forever #(CLOCK_PERIOD/2) aclk = !aclk;
	end
	
	/////////////////////////////////
	// Reset

	initial begin
		aresetn <= 0;
		#1000 aresetn <= 1;
	end
	
	////////////////////////////////
	// Main thread
	initial begin
		init_dut_ports();
		wait (aresetn);
		repeat(6) begin
			@(posedge aclk);
			push_data <= push_data + 1;
			push <= 1;
			@(posedge aclk);
			push <= 0;
		end
		
		@(posedge aclk);
		push <= 0;
		
		repeat(6) begin
			@(posedge aclk);
			pop <= 1;
			@(posedge aclk);
			pop <= 0;
		end
		
	end
	
endmodule