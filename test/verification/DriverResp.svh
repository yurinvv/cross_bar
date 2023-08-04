class DriverResp extends Driver;

	local RespDataTransaction respData;
	
	function new(int id);
		this.id = id;
		no_resp = 0;
	endfunction
	
	task run();
		//$display("T=%0t [DriverResp%d] is starting...", $time, id);
		vif.slaveInit();
		
		if (no_resp) begin			
			forever begin
				vif.sendAck();
			end
		end else begin
			forever begin
				fifo.get(respData);
				
				vif.sendAckRespRdata(respData.data);
				
				//$display("T=%0t [DriverResp%d] sended next: data %h", $time, id, respData.data);
				-> driver_done;
			end
		end	
		
	endtask
endclass