`timescale 1ns/1ns

module tb;
	
	import tb_pckg::*;
	
	/////////////////////////////////////
	//  Select the Test
	/////////////////////////////////////
	//DirectWriteTest test;
	DirectReadTest test;
	////////////////////////////////////
	
	parameter CLOCK_PERIOD = 10;
	parameter AWIDTH = 32; 
	parameter DWIDTH = 32; 

	bit aclk;
	bit aresetn;
	
	// DUT Interfaces
	cross_bar_if#(AWIDTH, DWIDTH) slave0_if (aclk, aresetn);
	cross_bar_if#(AWIDTH, DWIDTH) slave1_if (aclk, aresetn);
	cross_bar_if#(AWIDTH, DWIDTH) master0_if(aclk, aresetn);
	cross_bar_if#(AWIDTH, DWIDTH) master1_if(aclk, aresetn);
	
	// DUT
	cross_bar#(
		.AWIDTH(AWIDTH),
		.DWIDTH(DWIDTH) 
	) dut (
		.aclk    (aclk   ),
		.aresetn (aresetn),

		.s00_req    (slave0_if.req  ),
		.s00_addr   (slave0_if.addr ),
		.s00_cmd    (slave0_if.cmd  ),
		.s00_wdata  (slave0_if.wdata),
		.s00_ack    (slave0_if.ack  ),
		.s00_rdata  (slave0_if.rdata),
		.s00_resp   (slave0_if.resp ),
 
		.s01_req    (slave1_if.req  ),
		.s01_addr   (slave1_if.addr ),
		.s01_cmd    (slave1_if.cmd  ),
		.s01_wdata  (slave1_if.wdata),
		.s01_ack    (slave1_if.ack  ),
		.s01_rdata  (slave1_if.rdata),
		.s01_resp   (slave1_if.resp ),

		.m00_req    (master0_if.req  ),
		.m00_addr   (master0_if.addr ),
		.m00_cmd    (master0_if.cmd  ),
		.m00_wdata  (master0_if.wdata),
		.m00_ack    (master0_if.ack  ),
		.m00_rdata  (master0_if.rdata),
		.m00_resp	(master0_if.resp ),
		
		.m01_req    (master1_if.req  ),
		.m01_addr   (master1_if.addr ),
		.m01_cmd    (master1_if.cmd  ),
		.m01_wdata  (master1_if.wdata),
		.m01_ack    (master1_if.ack  ),
		.m01_rdata  (master1_if.rdata),
		.m01_resp   (master1_if.resp )
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
		test = new; 
		test.environment0.slave0_vif  = slave0_if;
		test.environment0.slave1_vif  = slave1_if;
		test.environment0.master0_vif = master0_if;
		test.environment0.master1_vif  = master1_if;
		test.run();
	end	

endmodule