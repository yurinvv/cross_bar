interface cross_bar_if#(
	parameter DWIDTH = 32,
	parameter AWIDTH = 32
)(
	 input aclk
	,input aresetn
);
	
	logic                  req;   // Request transaction execution. 1 - Active state
	logic [AWIDTH - 1 : 0] addr;  // Write/Read address
	logic                  cmd;   // 0 - Read; 1 - Write
	logic [DWIDTH - 1 : 0] wdata; //
	logic                  ack;   // 1 - request accepted for execution
	logic                  rdata; // on next clock after ack
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
	
	
	
endinterface