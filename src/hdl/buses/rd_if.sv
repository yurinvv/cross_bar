//////////////////////////////////////////////////////////////////////////////////
// Interface Name: Responce interface
// Project Name: Cross Bar
// Description: This interface is used to send a response to a read request 
// from the master port to the slave port.
//////////////////////////////////////////////////////////////////////////////////
interface rd_if#(
	parameter DWIDTH = 32
)(
	input aclk
);

	logic [DWIDTH - 1:0] rdata;
	logic                resp;
	logic                ack;
	
	modport in(
		input rdata,
		input resp,
		input ack
	);
	
	modport out(
		output rdata,
		output resp,
		output ack
	);

endinterface