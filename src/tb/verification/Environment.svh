class Environment;
	
	Agent#(0, DriverReq, MonitorResp) agentSlave0;
	Agent#(1, DriverReq, MonitorResp) agentSlave1;
	Agent#(2, DriverResp, MonitorReq) agentMaster0;
	Agent#(3, DriverResp, MonitorReq) agentMaster1;
	Scoreboard scoreboard;
	
	virtual cross_bar_if slave0_vif;	
	virtual cross_bar_if slave1_vif;	
	virtual cross_bar_if master0_vif;	
	virtual cross_bar_if master1_vif;	
	
	// Constructor
	function new();
		agentSlave0 = new();
		agentSlave1 = new();
		agentMaster0 = new();
		agentMaster1 = new();
		scoreboard.monitorReqFifo0 = agentMaster0.monitor_fifo;
		scoreboard.monitorReqFifo1 = agentMaster1.monitor_fifo;
		scoreboard.monitorRespFifo0 = agentSlave0.monitor_fifo;
		scoreboard.monitorRespFifo1 = agentSlave1.monitor_fifo;
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