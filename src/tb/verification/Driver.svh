virtual class Driver;
	int id;
	virtual cross_bar_if vif;
	event driver_done;
	mailbox fifo;
	
endclass