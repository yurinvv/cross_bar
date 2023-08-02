class MonitorReq extends Monitor;

	RequestTransaction item;
	
	function new(int id);
		this.id = id;
	endfunction
	
	task run();
		$display("T=%0t [MonitorReq%d] is starting...", $time, id);
		item = new(0, 0, 0);
		//@(posedge vif.aclk);
		forever begin
			vif.getRequest(item.addr, item.data, item.cmd);
			
			$display("T=%0t [MonitorReq%d] item: addr: %h, data: %h, cmd: %d", $time, id,
				item.addr, item.data, item.cmd);
			fifo.put(item);
		end
	endtask
	
endclass