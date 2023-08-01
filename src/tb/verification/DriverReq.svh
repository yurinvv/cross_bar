class DriverReq extends Driver;

	local RequestTransaction reqData;
	
	function new(int id);
		this.id = id;
	endfunction
	
	task run();
		$display("T=%0t [DriverReq%d] is starting...", $time, id);
		vif.mastertInit();
		forever begin
			fifo.get(reqData);
			vif.sendRequest(reqData.addr, reqData.data, reqData.cmd);
			$display("T=%0t [DriverReq%d] sended next: addr %h, data %h, cmd %h", $time, id, reqData.addr, reqData.data, reqData.cmd);
			if (reqData.cmd == 0) // Read ?
				vif.waitOnlyResp();
			-> driver_done;
		end
		
	endtask
endclass