class Environment;
	
	Agent#(0, DriverReq, MonitorResp) agentSlave0;
	Agent#(1, DriverReq, MonitorResp) agentSlave1;
	Agent#(2, DriverResp, MonitorReq) agentMaster0;
	Agent#(3, DriverResp, MonitorReq) agentMaster1;
	Scoreboard scoreboard0;
	
	virtual cross_bar_if slave0_vif;	
	virtual cross_bar_if slave1_vif;	
	virtual cross_bar_if master0_vif;	
	virtual cross_bar_if master1_vif;	
	
	mailbox monitor_fifo0;
	mailbox monitor_fifo1;
	mailbox monitor_fifo2;
	mailbox monitor_fifo3;
	
	// Constructor
	function new();
		agentSlave0 = new();
		agentSlave1 = new();
		agentMaster0 = new();
		agentMaster1 = new();
		
		monitor_fifo0 = new(20);
		monitor_fifo1 = new(20);
		monitor_fifo2 = new(20);
		monitor_fifo3 = new(20);
		
		scoreboard0 = new();
		
		agentMaster0.monitor0.fifo  = monitor_fifo0;
		agentMaster1.monitor0.fifo  = monitor_fifo1;
		agentSlave0.monitor0.fifo   = monitor_fifo2;
		agentSlave1.monitor0.fifo   = monitor_fifo3;
		
		
		scoreboard0.monitorReqFifo0  = monitor_fifo0;
		scoreboard0.monitorReqFifo1  = monitor_fifo1;
		scoreboard0.monitorRespFifo0 = monitor_fifo2;
		scoreboard0.monitorRespFifo1 = monitor_fifo3;
				
	endfunction
	
	task run();
		agentSlave0.vif = slave0_vif;
		agentSlave1.vif = slave1_vif;
		agentMaster0.vif = master0_vif;
		agentMaster1.vif = master1_vif;
		
		fork
			agentSlave0.run();
			agentSlave1.run();
			agentMaster0.run();
			agentMaster1.run();
		join_none
	endtask
	
endclass