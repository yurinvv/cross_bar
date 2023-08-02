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
		$display("T=%0t [Scoreboard] is starting...", $time);
	
		fork
		checkMonitorReqFifo0();
		checkMonitorReqFifo1();
		checkMonitorRespFifo0();
		checkMonitorRespFifo1();
		join
		
		if (mResp0_fails > 0 | mResp1_fails > 0 | mReq0_fails > 0 | mReq1_fails > 0) begin
			$display("##################################");
			$display("####     TEST FAILED! :-(   ######");
			$display("##################################");
			$display("#### mResp0_fails = %d", mResp0_fails);
			$display("#### mResp1_fails = %d", mResp1_fails);
			$display("#### mReq0_fails = %d",  mReq0_fails);
			$display("#### mReq1_fails = %d",  mReq1_fails);
			
		end else begin
			$display("######################################");
			$display("####    TEST PASSED!!! :-D      ######");
			$display("######################################");
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
			$display("| respTmp0.data = %h; refRespTmp0.data = %h", respTmp0.data, refRespTmp0.data);
			$display("+--------------------------------------");
			
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
			$display("| respTmp1.data = %h; refRespTmp1.data = %h", respTmp1.data, refRespTmp1.data);
			$display("+--------------------------------------");
			
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
			
//			$display("+--------------------------------------");
//			$display("| reqTmp0.addr = %h; refReqTmp0.addr = %h", reqTmp0.addr, refReqTmp0.addr);
//			$display("| reqTmp0.data = %h; refReqTmp0.data = %h", reqTmp0.data, refReqTmp0.data);
//			$display("| reqTmp0.cmd = %h; refReqTmp0.cmd = %h", reqTmp0.cmd, refReqTmp0.cmd);
//			$display("+--------------------------------------");
			
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
			
//			$display("+--------------------------------------");
//			$display("| reqTmp1.addr = %h; refReqTmp1.addr = %h", reqTmp1.addr, refReqTmp1.addr);
//			$display("| reqTmp1.data = %h; refReqTmp1.data = %h", reqTmp1.data, refReqTmp1.data);
//			$display("| reqTmp1.cmd = %h;  refReqTmp1.cmd = %h",  reqTmp1.cmd,  refReqTmp1.cmd);
//			$display("+--------------------------------------");			
//			
			if (reqTmp1.addr   != refReqTmp1.addr
				| reqTmp1.data != refReqTmp1.data
				| reqTmp1.cmd  != refReqTmp1.cmd) begin
				mReq1_fails++;
			end
		end
		
	endtask
	

	
endclass