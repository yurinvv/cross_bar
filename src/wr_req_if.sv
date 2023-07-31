interface wr_req_if#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32,
	parameter MATSER_NUM = 2 // number of base master ports from cross-bar
)(
	input aclk
);

	logic [$clog2(MATSER_NUM) - 1:0] sel;
	logic [AWIDTH - 1:0]             addr;
	logic [DWIDTH - 1:0]             wdata;
	logic                            req;
	
	modport in(
		input sel,
		input addr,
		input wdata,
		input req

	);
	
	modport out(
		output sel,
		output addr,
		output wdata,
		output req
	);
	
	task busReset();
		sel   <= '0;
		addr  <= '0;
		wdata <= '0;
		req   <= '0;
	endtask
	
endinterface