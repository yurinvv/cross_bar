virtual class Driver;
	int id;
	int no_resp;
	virtual cross_bar_if vif;
	event driver_done;
	mailbox fifo;
	
endclass