class RequestTransaction extends Transaction;
	int addr;
	int data;
	int cmd;
	
	function new(int addr, int data, int cmd);
		this.addr = addr;
		this.data = data;
		this.cmd = cmd;
	endfunction
		
endclass