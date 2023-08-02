interface cross_bar_if#(
	parameter AWIDTH = 32,
	parameter DWIDTH = 32
)(
	 input aclk,
	 input aresetn
);
	
	logic                  req;   // Request transaction execution. 1 - Active state
	logic [AWIDTH - 1 : 0] addr;  // Write/Read address
	logic                  cmd;   // 0 - Read; 1 - Write
	logic [DWIDTH - 1 : 0] wdata; //
	logic                  ack;   // 1 - request accepted for execution
	logic [DWIDTH - 1 : 0] rdata; // on next clock after ack
	logic                  resp;  // on next clock after ack
	
	modport slave(
		 input  req   
		,input  addr  
		,input  cmd   
		,input  wdata 
		,output ack
		,output rdata
		,output resp
	);
	
	modport master(
		 output req   
		,output addr  
		,output cmd   
		,output wdata 
		,input  ack
		,input  rdata
		,input  resp
	);
	
	task mastertInit();
		@(posedge aclk);
		{cmd, addr, wdata, req} <= '0;
	endtask
	
	task slaveInit();
		{ack, rdata, resp} <= '0;
	endtask
	
	task sendRequest(input [AWIDTH - 1 : 0] addr_val, input [DWIDTH - 1 : 0] data_val, input cmd_val);
		@(posedge aclk);
		cmd  <= cmd_val;
		addr <= addr_val;
		wdata <= data_val;
		req  <= 1;
		wait(ack);
		@(posedge aclk);
		{cmd, addr, wdata, req} <= '0;
	endtask
	
	task getRequest(output [AWIDTH - 1 : 0] addr_val, output [DWIDTH - 1 : 0] data_val, output cmd_val);
		@(posedge aclk);
		wait(req);
		@(posedge aclk);
		{addr_val, data_val, cmd_val} <= {addr, wdata, cmd};
		wait(!req);
	endtask
	
	task sendAckRespRdata(input [DWIDTH - 1 : 0] data_val);
		@(posedge aclk);
		wait(req);
		@(posedge aclk);
		ack <= 1;
		@(posedge aclk);
		ack <= 0;
		resp <= 1;
		rdata <= data_val;
		@(posedge aclk);
		{resp, rdata} <= '0;
	endtask
	
	
	task getRespData(output bit [DWIDTH - 1 : 0] rdata_val);
		wait(resp);
		@(posedge aclk);
		rdata_val <= rdata;
		wait(!resp);
	endtask
	
	task waitOnlyResp();
		wait(resp);
		@(posedge aclk);
		wait(!resp);
	endtask
	
	task sendAck();
		wait(req);
		@(posedge aclk);
		ack <= 1;
		wait(!req);
		@(posedge aclk);
		ack <= 0;
		@(posedge aclk);
	endtask
	
endinterface