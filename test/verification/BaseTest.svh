class BaseTest#(string NAME = "Test");

	Environment environment0;
	
	string sequence_s0_path;     //Driver
	string sequence_s1_path;     //Driver
	string sequence_m0_path;     //Driver
	string sequence_m1_path;     //Driver
	
	string ref_sequence_s0_path; //Monitor
	string ref_sequence_s1_path; //Monitor
	string ref_sequence_m0_path; //Monitor
	string ref_sequence_m1_path; //Monitor
	
	RequestTransaction   sequence_s0[$];
	RequestTransaction   sequence_s1[$];
	RespDataTransaction  sequence_m0[$];
	RespDataTransaction  sequence_m1[$];

	RespDataTransaction  ref_sequence_s0[$];
	RespDataTransaction  ref_sequence_s1[$];
	RequestTransaction   ref_sequence_m0[$];
	RequestTransaction   ref_sequence_m1[$];
	
	typedef RequestTransaction reqQueue[$];

	
	// Method: Read Request sequences. Use in spec test
	function void readReqSequence(string path, ref RequestTransaction reqs[$]);
		int fd;
		string line, addr, data, cmd;
		RequestTransaction req = new(0,0,0);
		
		if (path != null) begin
			fd = $fopen(path, "r");
			
			while(!$feof(fd)) begin
			    
				//00000009_00000032_1
				$fgets(line, fd);
				
				if (line == "")
					break;
				
				addr = line.substr(0,7);
				data = line.substr(9,16);
				cmd  = line.substr(18,18);
				
				req = new(0,0,0);
				
				req.addr = addr.atohex();
				req.data = data.atohex();
				req.cmd  = cmd.atoi();
				
				reqs.push_front(req);
				
			end
			
			$fclose(fd);

		end
	endfunction
	
	// Method: Read Response sequences. Use in spec test
	function void readRespSequence(string path, ref RespDataTransaction resps[$]);
		int fd;
		string line, data;
		RespDataTransaction resp = new(0);
		
		if (path != null) begin
			fd = $fopen(path, "r");
			
			while(!$feof(fd)) begin
			    
				//00000032
				$fgets(line, fd);
				
				if (line == "")
					break;
				
				data = line.substr(0,7);
				
				resp = new(0);
				
				resp.data = data.atohex();
				//$display(">>>>>resp.data = %h", resp.data);
				resps.push_front(resp);
			end
			
			$fclose(fd);
		end
	endfunction
	
	// Constructor
	function new();
		environment0 = new;
	endfunction
	
	task run();
	
		$display("sequence_s0.size = %d", sequence_s0.size());
		$display("sequence_s1.size = %d", sequence_s1.size());
		$display("sequence_m0.size = %d", sequence_m0.size());
		$display("sequence_m1.size = %d", sequence_m1.size());
		$display("ref_sequence_m0.size = %d", ref_sequence_m0.size());
		$display("ref_sequence_m1.size = %d", ref_sequence_m1.size());
		$display("ref_sequence_s0.size = %d", ref_sequence_s0.size());
		$display("ref_sequence_s1.size = %d", ref_sequence_s1.size());
		
	
		environment0.agentSlave0.setSequence(sequence_s0);		
		environment0.agentSlave1.setSequence(sequence_s1);		
		environment0.agentMaster0.setSequence(sequence_m0);		
		environment0.agentMaster1.setSequence(sequence_m1);
		
		environment0.scoreboard0.refMonitorReqFifo0  = ref_sequence_m0;
		environment0.scoreboard0.refMonitorReqFifo1  = ref_sequence_m1;
		environment0.scoreboard0.refMonitorRespFifo0 = ref_sequence_s0;
		environment0.scoreboard0.refMonitorRespFifo1 = ref_sequence_s1;
		
		$display("");
		$display("");
		$display("######################################################");
		$display("####     T=%0t Test %s is starting...   ", $time, NAME);
		$display("######################################################");
		$display("");
		$display("");
		environment0.run();
	endtask
		
endclass