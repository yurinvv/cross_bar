class Scoreboard;
	mailbox monitorReqFifo0;
	mailbox monitorReqFifo1;
	mailbox monitorRespFifo0;
	mailbox monitorRespFifo1;
	
	RequestTransaction  refMonitorReqFifo0 [$];
	RequestTransaction  refMonitorReqFifo1 [$];
	RespDataTransaction refMonitorRespFifo0[$];
	RespDataTransaction refMonitorRespFifo1[$];
	
	RequestTransaction reqTmp0, refReqTmp0;
	RequestTransaction reqTmp1, refReqTmp1;
	
	RespDataTransaction respTmp0, refRespTmp0;
	RespDataTransaction respTmp1, refRespTmp1;
		
	int mResp0_i;
	int mResp1_i;
	int mReq0_i;
	int mReq1_i;
	
	int mResp0_fails;
	int mResp1_fails;
	int mReq0_fails;
	int mReq1_fails;
	
	task run();
		//$display("T=%0t [Scoreboard] is starting...", $time);
	
		fork
		checkMonitorReqFifo0();
		checkMonitorReqFifo1();
		checkMonitorRespFifo0();
		checkMonitorRespFifo1();
		join
		
		if (mResp0_fails > 0 | mResp1_fails > 0 | mReq0_fails > 0 | mReq1_fails > 0) begin
			$display("");
			$display("##################################");
			$display("####     TEST FAILED! :-(   ######");
			$display("##################################");
			$display("");
			$display("#### Agent Slave0 -> Monitor Resp fails = %d", mResp0_fails);
			$display("#### Agent Slave1 -> Monitor Resp fails = %d", mResp1_fails);
			$display("#### Agent Master0 -> Monitor Req fails = %d",  mReq0_fails);
			$display("#### Agent Master1 -> Monitor Req fails = %d",  mReq1_fails);
			$display("");
			
		end else begin
			$display("");
			$display("######################################");
			$display("####    TEST PASSED!!! :-D      ######");
			$display("######################################");
			$display("");
			$display("#### Number of Agent Slave0 -> Monitor Resp transactions = %d", mResp0_i);
			$display("#### Number of Agent Slave1 -> Monitor Resp transactions = %d", mResp1_i);
			$display("#### Number of Agent Master0 -> Monitor Req transactions = %d",  mReq0_i);
			$display("#### Number of Agent Master1 -> Monitor Req transactions = %d",  mReq1_i);
			$display("");
		end
		
		#100 $finish;
	endtask
	
	// Checking Monitor Resp of Agent Slave 0
	task checkMonitorRespFifo0();
		mResp0_i = 0;
		mResp0_fails = 0;
		
		while (refMonitorRespFifo0.size > 0) begin
			mResp0_i++;
			monitorRespFifo0.get(respTmp0);
			refRespTmp0 = refMonitorRespFifo0.pop_back();
			
			$display("+--------------------------------------");
			$display("|No: %d Agent Slave0 -> Monitor Resp -> rdata = %h; reference rdata = %h", mResp0_i, respTmp0.data, refRespTmp0.data);
			
			if (respTmp0.data != refRespTmp0.data) begin
				mResp0_fails++;
			end
		end
		
	endtask	

	// Checking Monitor Resp of Agent Slave 1
	task checkMonitorRespFifo1();
		mResp1_i = 0;
		mResp1_fails = 0;
		
		while (refMonitorRespFifo1.size > 0) begin
			mResp1_i++;
			monitorRespFifo1.get(respTmp1);
			refRespTmp1 = refMonitorRespFifo1.pop_back();
			
			$display("+--------------------------------------");
			$display("|No: %d Agent Slave1 -> Monitor Resp -> rdata = %h; reference rdata = %h", mResp1_i, respTmp1.data, refRespTmp1.data);
			
			if (respTmp1.data != refRespTmp1.data) begin
				mResp1_fails++;
			end
		end
		
	endtask		
	
	// Checking Monitor Req of Agent Master 0
	task checkMonitorReqFifo0();
		mReq0_i = 0;
		mReq0_fails = 0;
		
		while (refMonitorReqFifo0.size > 0) begin
			mReq0_i++;
			monitorReqFifo0.get(reqTmp0);
			refReqTmp0 = refMonitorReqFifo0.pop_back();
			
			$display("+--------------------------------------");
			$display("| Agent Master0 -> Monitor Req -> addr = %h;  reference addr = %h",  reqTmp0.addr, refReqTmp0.addr);
				if (refReqTmp0.cmd)
					$display("| Agent Master0 -> Monitor Req -> wdata = %h; reference wdata = %h", reqTmp0.data, refReqTmp0.data);
			$display("| Agent Master0 -> Monitor Req -> cmd = %h;   reference cmd = %h",   reqTmp0.cmd, refReqTmp0.cmd);
			
			if (reqTmp0.addr   != refReqTmp0.addr
				| reqTmp0.data != refReqTmp0.data
				| reqTmp0.cmd  != refReqTmp0.cmd) begin
				mReq0_fails++;
			end
		end
		
	endtask

	// Checking Monitor Req of Agent Master 1
	task checkMonitorReqFifo1();
		mReq1_i = 0;
		mReq1_fails = 0;
		
		while (refMonitorReqFifo1.size > 0) begin
			mReq1_i++;
			monitorReqFifo1.get(reqTmp1);
			refReqTmp1 = refMonitorReqFifo1.pop_back();
			
			$display("+--------------------------------------");
			$display("| Agent Master1 -> Monitor Req -> addr = %h;  reference addr = %h",  reqTmp1.addr, refReqTmp1.addr);
				if (refReqTmp1.cmd)
					$display("| Agent Master1 -> Monitor Req -> wdata = %h; reference wdata = %h", reqTmp1.data, refReqTmp1.data);
			$display("| Agent Master1 -> Monitor Req -> cmd = %h;   reference cmd = %h",   reqTmp1.cmd, refReqTmp1.cmd);
			
			if (reqTmp1.addr   != refReqTmp1.addr
				| reqTmp1.data != refReqTmp1.data
				| reqTmp1.cmd  != refReqTmp1.cmd) begin
				mReq1_fails++;
			end
		end
		
	endtask
	

	
endclass