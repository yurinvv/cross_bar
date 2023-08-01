class DriverResp extends Driver;

	local RespDataTransaction respData;
	
	function new(int id);
		this.id = id;
	endfunction
	
	task run();
		$display("T=%0t [DriverResp%d] is starting...", $time, id);
		vif.mastertInit();
		forever begin
			fifo.get(respData);
			vif.sendAckRespRdata(respData.data);
			-> driver_done;
		end
		
	endtask
endclass