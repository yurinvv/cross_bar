class MonitorResp extends Monitor;

	RespDataTransaction item;
	
	function new(int id);
		this.id = id;
	endfunction
	
	task run();
		$display("T=%0t [MonitorResp%d] is starting...", $time, id);
		item = new(0);
		forever begin
			vif.getRespData(item.data);
			fifo.put(item);
		end
	endtask
	
endclass