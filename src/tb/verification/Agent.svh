class Agent #(int ID = 0,
              type D = Driver,
			  type M = Monitor);

	// Connect it!
	virtual cross_bar_if vif;
	
	Sequencer seqr;
	D driver;
	M monitor;
	
	local event driver_done;
	local mailbox seqr_drv_fifo;
	
	// Connect it with Scoreboard!
	mailbox monitor_fifo;
			  
	// Constructor
	
	function new ();
		seqr_drv_fifo = new (20);
		monitor_fifo = new (20);
		
		seqr = new(ID);
		driver = new(ID);
		monitor = new(ID);
		
		seqr.fifo = seqr_drv_fifo;
		seqr.driver_done = driver_done;
		
		driver.fifo = seqr_drv_fifo;
		driver.driver_done = driver_done;
		
		monitor.fifo = monitor_fifo;
		
	endfunction
	
	task run();
		driver.vif = vif;
		monitor.vif = vif;
		
		fork
			seqr.run();
			driver.run();
			monitor.run();
		join_none
		
	endtask
	
	
	/////////////////////
	// Use!
	function void setSequence(Transaction queue[$]);
		seqr.item = queue;
	endfunction
endclass