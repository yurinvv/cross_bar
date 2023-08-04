class Sequencer;
	int id;
	Transaction item[$];
	mailbox fifo;
	event driver_done;
	//event seqr_done;
	
	local Transaction a_item;
	
	function new(int id);
		this.id = id;
	endfunction
	
	task run();
		//$display("T=%0t [Sequencer%d] is starting", $time, id);
		
		while (item.size > 0) begin
			a_item = item.pop_back();			
			fifo.put(a_item);
			@(driver_done);	
		end
		
		//-> seqr_done;
		//$display("T=%0t [Sequencer%d] is done", $time, id);
	endtask
endclass