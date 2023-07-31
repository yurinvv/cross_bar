interface rd_req_if#(
	parameter AWIDTH = 32,
	parameter MATSER_NUM = 2 // number of base master ports from cross-bar
)(
	input aclk
);

	logic                    req;
	logic [AWIDTH - 1:0]     addr;
	logic [MATSER_NUM - 1:0] wren; // for fifo
	logic                    rd_en; // for fifo
	logic                    fifo_full;
	
	modport slave(
		input req,
		input addr,
		input wren,
		output rd_en,
		output fifo_full
	);
	
	modport master(
		output req,
		output addr,
		output wren,
		input  rd_en,
		input  fifo_full
	);

	task masterReset();
		req   <= '0;
		addr  <= '0;
		wren  <= '0;
	endtask

endinterface