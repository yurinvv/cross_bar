class RespDataTransaction extends Transaction;

	int data;
	
	function new(int data);
		this.data = data;
	endfunction

endclass