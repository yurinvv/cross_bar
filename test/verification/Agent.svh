class Agent #(int ID = 0,
              type D = Driver,
			  type M = Monitor);

	// Connect it!
	virtual cross_bar_if vif;
	
	Sequencer seqr;
	D driver0;
	M monitor0;
	
	local event driver_done;
	local mailbox seqr_drv_fifo;
	
	// Connect it with Scoreboard!
	//mailbox monitor_fifo;
			  
	// Constructor
	
	function new ();
		seqr_drv_fifo = new (20);
		//monitor_fifo = new (20);
		
		seqr = new(ID);
		driver0 = new(ID);
		monitor0 = new(ID);
		
		seqr.fifo = seqr_drv_fifo;
		seqr.driver_done = driver_done;
		
		driver0.fifo = seqr_drv_fifo;
		driver0.driver_done = driver_done;
		
		//monitor.fifo = monitor_fifo;
		
	endfunction
	
	task run();
		driver0.vif = vif;
		monitor0.vif = vif;
		
		fork
			seqr.run();
			driver0.run();
			monitor0.run();
		join_none
		
	endtask
	
	
	/////////////////////
	// Use!
	function void setSequence(Transaction queue[$]);
		seqr.item = queue;
	endfunction
endclass