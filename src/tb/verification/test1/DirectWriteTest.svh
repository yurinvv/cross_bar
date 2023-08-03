class DirectWriteTest #(string NAME = "Direct writing test") extends BaseTest#(.NAME(NAME));
	
	function new();
		super.new();
		sequence_s0_path = "./dir_wr_seq_s0.txt";
		sequence_s1_path = "./dir_wr_seq_s1.txt";
		//sequence_m0_path;
		//sequence_m1_path;

		//ref_sequence_s0_path;
		//ref_sequence_s1_path;
		ref_sequence_m0_path = "./dir_wr_seq_m0.txt";
		ref_sequence_m1_path = "./dir_wr_seq_m1.txt";
		
		readReqSequence(sequence_s0_path,     sequence_s0    );		
		readReqSequence(sequence_s1_path,     sequence_s1    );		
		readReqSequence(ref_sequence_m0_path, ref_sequence_m0);		
		readReqSequence(ref_sequence_m1_path, ref_sequence_m1);		
		
		environment0.setNo_respMaster0();		
		environment0.setNo_respMaster1();		
	endfunction
	
endclass

/*
	local bit [64 : 0] testVectorsS0 [19:0];
	local bit [64 : 0] testVectorsS1 [19:0];
	
	local RequestTransaction req_sequence_s0[$];
	local RequestTransaction req_sequence_s1[$];
	
	local RequestTransaction tmp;
	
	function new();
		super.new();
		tmp = new(0,0,0);
		sequence_s0 = req_sequence_s0;
		sequence_s1 = req_sequence_s1;
		environment0.scoreboard.refMonitorReqFifo0 = req_sequence_s0;
		environment0.scoreboard.refMonitorReqFifo1 = req_sequence_s1;
		readSequences();
	endfunction
	
	local function void readSequences();
		$readmemh("test0_sequence_s0", testVectorsS0);
		$readmemh("test0_sequence_s1", testVectorsS1);
		
		for (int i = 0; i < 20; i++) begin
			{tmp.addr, tmp.data, tmp.cmd} = testVectorsS0[i];
			req_sequence_s0.push_front(tmp);
			
			{tmp.addr, tmp.data, tmp.cmd} = testVectorsS1[i];
			req_sequence_s1.push_front(tmp);
		end
	endfunction
*/